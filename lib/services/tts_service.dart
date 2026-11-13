
import 'package:flutter_tts/flutter_tts.dart';

/// Reads the supplied text using the language chosen in the app.
/// Requires a matching TTS voice to be installed on the device.
class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static bool _ready = false;

  static Future<void> init() async {
    if (_ready) return;
    await _tts.awaitSpeakCompletion(true);
    _ready = true;
  }

  static Future<void> speak(String text, {String? language}) async {
    if (text.trim().isEmpty) return;

    final locale = switch (language) {
      'en' => 'en-US',
      'ur' => 'ur-PK',
      _ => 'ar-SA',
    };

    try {
      await init();
      await _tts.stop();
      await _tts.setLanguage(locale);

      // Natural, fixed reading speed.
      await _tts.setSpeechRate(0.6);

      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.speak(text);
    } catch (error) {
      // Do not substitute English for Arabic/Urdu text.
      assert(() {
        print('TTS failed for $locale: $error');
        return true;
      }());
    }
  }

  static Future<void> stop() => _tts.stop();
}
