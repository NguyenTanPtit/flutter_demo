package com.demogemma3

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel // For streaming
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import com.google.mediapipe.tasks.genai.llminference.LlmInferenceSession
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.demogemma3/genai"
    private val EVENT_CHANNEL = "com.demogemma3/genai_events"

    private var llmInference: LlmInference? = null
    private var llmSession: LlmInferenceSession? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1. Setup Method Channel (Commands from Flutter)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initModel" -> {
                    initModel()
                    result.success(null)
                }
                "startStreamingResponse" -> {
                    val prompt = call.argument<String>("prompt")
                    if (prompt != null) {
                        generateResponse(prompt)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARG", "Prompt is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // 2. Setup Event Channel (Streaming back to Flutter)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }

    private fun initModel() {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                // Logic to copy model from assets to cache (Same as your RN code)
                val modelName = "gemma-3n-E2B-it-int4.task"
                val file = File(cacheDir, modelName)
                if (!file.exists()) {
                    assets.open(modelName).use { input ->
                        FileOutputStream(file).use { output -> input.copyTo(output) }
                    }
                }

                val options = LlmInference.LlmInferenceOptions.builder()
                    .setModelPath(file.absolutePath)
                    .setMaxTokens(1024)
                    .build()

                llmInference = LlmInference.createFromOptions(context, options)
                llmSession = LlmInferenceSession.createFromOptions(llmInference!!, LlmInferenceSession.LlmInferenceSessionOptions.builder().build())

                runOnUiThread { eventSink?.success(mapOf("status" to "ready")) }
            } catch (e: Exception) {
                Log.e("GenAI", "Error", e)
                runOnUiThread { eventSink?.error("INIT_ERROR", e.message, null) }
            }
        }
    }

    private fun generateResponse(prompt: String) {
        CoroutineScope(Dispatchers.IO).launch {
            llmSession?.addQueryChunk(prompt)
            llmSession?.generateResponseAsync { partialResult, done ->
                runOnUiThread {
                    if (partialResult != null) {
                        eventSink?.success(mapOf("chunk" to partialResult))
                    }
                    if (done) {
                        eventSink?.success(mapOf("end" to true))
                    }
                }
            }
        }
    }
}