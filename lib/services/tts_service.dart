// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  TtsService() {
    // Configuraciones iniciales
    _tts.setLanguage('mx-ES');
    _tts.setSpeechRate(0.5);
    _tts.setPitch(1.0);
    _tts.setVolume(1.0);
    _tts.awaitSpeakCompletion(true); // Espera a que termine de hablar
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }
}
