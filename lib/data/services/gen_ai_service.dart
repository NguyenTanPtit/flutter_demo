import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_gemma/flutter_gemma.dart';

class GenAIService {
  final StreamController<String> _responseController = StreamController<String>.broadcast();
  final StreamController<void> _endController = StreamController<void>.broadcast();
  final StreamController<String> _errorController = StreamController<String>.broadcast();
  final StreamController<int> _progressController = StreamController<int>.broadcast();

  Stream<String> get onStreamData => _responseController.stream;
  Stream<void> get onStreamEnd => _endController.stream;
  Stream<String> get onStreamError => _errorController.stream;
  Stream<int> get onProgress => _progressController.stream;

  InferenceModel? _model;
  InferenceChat? _chat;

  Future<void> installModel({required String token}) async {
    try {
      final isInstalled = await FlutterGemma.isModelInstalled(ModelType.gemmaIt.name);
      if (!isInstalled) {
        await FlutterGemma.installModel(
          modelType: ModelType.gemmaIt,
        )
        .fromNetwork(
           'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview/resolve/main/gemma-3n-E2B-it-int4.task',
           token: token,
        )
        .withProgress((progress) {
          _progressController.add(progress);
        })
        .install();
      }
      
      _model = await FlutterGemma.getActiveModel(
        maxTokens: 2048,
        preferredBackend: PreferredBackend.gpu,
      );
      
      _chat = await _model!.createChat(
         supportImage: true,
      );

    } catch (e) {
      _errorController.add('Failed to init model: $e');
      throw Exception('Failed to init model: $e');
    }
  }

  Future<void> startStreamingResponse(String prompt, {Uint8List? imageBytes}) async {
    if (_chat == null) {
      _errorController.add("Model not initialized");
      return;
    }

    try {
      final message = imageBytes != null 
          ? Message.withImage(text: prompt, imageBytes: imageBytes, isUser: true)
          : Message.text(text: prompt, isUser: true);

      await _chat!.addQueryChunk(message);
      
      _chat!.generateChatResponseAsync().listen((ModelResponse response) {
        if (response is TextResponse) {
           _responseController.add(response.token);
        } else if (response is FunctionCallResponse) {
           // Not handled in this basic demo, but logging it
           print("Function call received: ${response.name}");
        } else if (response is ThinkingResponse) {
           // Should not happen for Gemma 2B
        }
      }, onDone: () {
        _endController.add(null);
      }, onError: (e) {
        _errorController.add(e.toString());
      });

    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  // Simplified methods that map to the generic one
  Future<void> sendImagePrompt(String prompt, Uint8List imageBytes) async {
     await startStreamingResponse(prompt, imageBytes: imageBytes);
  }

  // Audio handling would typically involve STT first, but if the model supported audio directly we'd use that.
  // Gemma 3 Nano (multimodal) supports image. Audio is not supported directly in the basic flutter_gemma flow 
  // without a separate STT or if the model specifically consumes audio tokens (which 3n-E2B-it does not, primarily text/image).
  // For now, we will assume the previous implementation was sending base64 audio which might have been a placeholder.
  // We'll keep the signature but maybe throw or handle differently.
  Future<void> sendAudioPrompt(String base64Audio) async {
     // TODO: Implement STT or use a model that supports audio if available.
     // For now, we can't process audio directly with Gemma 3 Nano E2B text/vision model.
     _errorController.add("Audio input not supported directly by this model version.");
  }

  Future<void> resetConversation() async {
    // Re-create chat to reset context
    if (_model != null) {
      _chat = await _model!.createChat(supportImage: true);
    }
  }

  Future<void> shutdown() async {
    await _responseController.close();
    await _endController.close();
    await _errorController.close();
    await _progressController.close();
    // Do not close model/chat here if you want to keep it alive for the session
    // But typically you might want to.
  }
}
