
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../theme/app_style.dart';

/// Voice command increments the counter once per microphone press.
class VoiceIncrementButton extends StatefulWidget {
  final String language;
  final int value;
  final int maximum;
  final VoidCallback onIncrement;

  const VoiceIncrementButton({
    super.key,
    required this.language,
    required this.value,
    required this.maximum,
    required this.onIncrement,
  });

  @override
  State<VoiceIncrementButton> createState() =>
      _VoiceIncrementButtonState();
}

class _VoiceIncrementButtonState extends State<VoiceIncrementButton> {
  static final stt.SpeechToText _speech = stt.SpeechToText();

  static bool _initialized = false;
  static bool _busy = false;
  static _VoiceIncrementButtonState? _active;

  bool _listening = false;
  bool _starting = false;
  bool _consumed = false;
  bool _stopping = false;

  String _text(String ar, String en, String ur) {
    if (widget.language == 'en') return en;
    if (widget.language == 'ur') return ur;
    return ar;
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 5),
        ),
      );
  }

  bool _heardOne(String spoken) {
    final text = spoken
        .toLowerCase()
        .trim()
        .replaceAll('١', '1')
        .replaceAll('۱', '1')
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');

    final words = text.split(
      RegExp(r'[\s،,.!?؟:;]+'),
    );

    const validWords = {
      '1',
      'واحد',
      'واحدة',
      'وحده',
      'one',
      'ایک',
      'اک',
      'ek',
    };

    return words.any((word) => validWords.contains(word));
  }

  static void _handleStatus(String status) {
    final owner = _active;

    if (status == 'done' || status == 'notListening') {
      if (owner != null && owner.mounted) {
        owner.setState(() {
          owner._listening = false;
        });
      }

      // Do not release the recognizer while stop is pending.
      if (owner == null || !owner._stopping) {
        _active = null;
        _busy = false;
      }
    }
  }

  static void _handleError(dynamic error) {
    final owner = _active;

    if (owner == null || !owner.mounted) {
      _active = null;
      _busy = false;
      return;
    }

    owner.setState(() {
      owner._listening = false;
    });

    final message = error.toString();

    owner._message(
      owner._text(
        'تعذر التعرف على الصوت: $message',
        'Speech recognition failed: $message',
        'آواز کی شناخت میں خرابی: $message',
      ),
    );

    if (!owner._stopping) {
      _active = null;
      _busy = false;
    }
  }

  Future<void> _stopListening() async {
    if (_stopping) return;

    _stopping = true;

    try {
      await _speech.stop();

      // Give the browser recognition engine time to finish
      // closing the previous recognition session.
      await Future<void>.delayed(
        const Duration(milliseconds: 400),
      );
    } catch (error) {
      if (mounted) {
        _message(
          _text(
            'تعذر إيقاف الميكروفون: $error',
            'Could not stop the microphone: $error',
            'مائیکروفون بند نہیں ہو سکا: $error',
          ),
        );
      }
    } finally {
      _stopping = false;

      if (identical(_active, this)) {
        _active = null;
      }

      _busy = false;

      if (mounted) {
        setState(() {
          _listening = false;
          _starting = false;
        });
      }
    }
  }

  Future<void> _toggle() async {
    if (_starting ||
        _stopping ||
        widget.value >= widget.maximum) {
      return;
    }

    if (_listening) {
      await _stopListening();
      return;
    }

    // Prevent overlapping recognition sessions.
    if (_busy) return;

    _busy = true;

    setState(() {
      _starting = true;
    });

    try {
      if (!_initialized) {
        final available = await _speech.initialize(
          onStatus: _handleStatus,
          onError: _handleError,
          debugLogging: true,
        );

        if (!available) {
          _message(
            _text(
              'خدمة التعرف على الكلام غير متاحة للتطبيق. '
                  'تأكدي من صلاحية الميكروفون وخدمة Google.',
              'Speech recognition is not available to this app. '
                  'Check microphone permission and speech services.',
              'اس ایپ میں آواز کی شناخت دستیاب نہیں۔ '
                  'مائیکروفون کی اجازت اور آواز کی سروس چیک کریں۔',
            ),
          );
          return;
        }

        _initialized = true;
      }

      if (!mounted) return;

      String? localeId;

      try {
        final locales = await _speech.locales();
        final wanted = widget.language.toLowerCase();

        for (final locale in locales) {
          final languageCode = locale.localeId
              .toLowerCase()
              .split(RegExp(r'[-_]'))
              .first;

          if (languageCode == wanted) {
            localeId = locale.localeId;
            break;
          }
        }
      } catch (_) {
        // Use device default if locales are unavailable.
      }

      if (!mounted) return;

      _active = this;
      _consumed = false;

      setState(() {
        _listening = true;
      });

      await _speech.listen(
        localeId: localeId,
        listenFor: const Duration(seconds: 12),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        onResult: (result) {
          if (!mounted ||
              !identical(_active, this) ||
              _consumed) {
            return;
          }

          final spoken = result.recognizedWords;

          if (_heardOne(spoken)) {
            _consumed = true;

            if (widget.value < widget.maximum) {
              widget.onIncrement();
            }

            // Wait for recognition to stop before
            // allowing another microphone press.
            _stopListening();
            return;
          }

          if (result.finalResult &&
              spoken.trim().isNotEmpty) {
            _message(
              _text(
                'سمعت: $spoken. قولي «واحد».',
                'Heard: $spoken. Say "one".',
                'سنا گیا: $spoken۔ «ایک» کہیں۔',
              ),
            );
          }
        },
      );

      if (_speech.isNotListening &&
          mounted &&
          !_consumed &&
          !_stopping) {
        await _stopListening();
      }
    } catch (error) {
      if (mounted) {
        _message(
          _text(
            'تعذر تشغيل الميكروفون: $error',
            'Could not start the microphone: $error',
            'مائیکروفون شروع نہیں ہو سکا: $error',
          ),
        );
      }

      await _stopListening();
    } finally {
      if (mounted) {
        setState(() {
          _starting = false;
        });
      }

      if (!_listening && !_stopping) {
        _busy = false;
      }
    }
  }

  @override
  void dispose() {
    if (identical(_active, this)) {
      _active = null;
      _busy = false;
      _speech.stop();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: _text(
        'اضغطي وقولي «واحد» لزيادة العدد',
        'Tap and say "one" to add one',
        'دبائیں اور «ایک» کہیں',
      ),
      onPressed:
      (widget.value >= widget.maximum ||
          _starting ||
          _stopping)
          ? null
          : _toggle,
      style: IconButton.styleFrom(
        backgroundColor:
        _listening ? Colors.red : AppStyle.gold,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade400,
      ),
      icon: Icon(
        _listening ? Icons.mic : Icons.mic_none,
      ),
    );
  }
}
