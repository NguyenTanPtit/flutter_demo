import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/services/gen_ai_service.dart';

class ChatRepository {
  final GenAIService _service;

  ChatRepository(this._service);

  // Updated init to accept token if needed, or rely on main initialization, 
  // but usually we might want to trigger the installation here.
  // We'll hardcode the token here or pass it from config. 
  // For now, let's assume the service handles the token internally or we pass it here.
  // The plan said "Use the provided HuggingFace token".
  Future<void> init(String token) => _service.installModel(token: token);

  Future<void> sendText(String text) => _service.startStreamingResponse(text);

  Future<void> sendImage(String base64Image, {String prompt = "Describe this image"}) async {
    // Convert base64 to Uint8List
    final bytes = base64Decode(base64Image);
    await _service.sendImagePrompt(prompt, bytes);
  }

  Future<void> sendAudio(String base64) => _service.sendAudioPrompt(base64);

  Stream<String> get streamData => _service.onStreamData;
  Stream<void> get streamEnd => _service.onStreamEnd;
  Stream<String> get streamError => _service.onStreamError;
  Stream<int> get downloadProgress => _service.onProgress;

  Future<void> dispose() => _service.shutdown();
}
