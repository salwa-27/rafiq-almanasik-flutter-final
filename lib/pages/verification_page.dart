
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import '../services/api_service.dart';

import 'reset_password_page.dart';

enum VerificationType {
  register,
  login,
  forgotPassword,
}

class VerificationPage extends StatefulWidget {
  final VerificationType type;
  final String email;
  final String phone;

  const VerificationPage({
    super.key,
    required this.type,
    this.email = '',
    this.phone = '',
  });

  @override
  State<VerificationPage> createState() =>
      _VerificationPageState();
}

class _VerificationPageState
    extends State<VerificationPage> {

  final _code = TextEditingController();

  bool _isLoading = false;

  String get lang {
    final selected = AppLanguage.currentLanguage;

    if (selected == 'ar' ||
        selected == 'en' ||
        selected == 'ur') {
      return selected;
    }

    return 'ar';
  }

  bool get isRtl => lang != 'en';

  String tr(String ar, String en, String ur) {
    if (lang == 'en') return en;
    if (lang == 'ur') return ur;
    return ar;
  }

  bool get isPhoneVerification {
    return widget.type == VerificationType.register ||
        (widget.type == VerificationType.forgotPassword &&
            widget.phone.isNotEmpty);
  }

  String get destination {
    if (isPhoneVerification) {
      return widget.phone.isNotEmpty
          ? widget.phone
          : tr(
        'رقم الجوال',
        'Phone number',
        'موبائل نمبر',
      );
    }

    return widget.email;
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget soundButton(String text) {
    return IconButton(
      tooltip: tr(
        'استمع',
        'Listen',
        'سنیں',
      ),
      onPressed: () {
        TtsService.speak(
          text,
          language: lang,
        );
      },
      icon: const Icon(
        Icons.volume_up_rounded,
        color: AppStyle.green,
      ),
    );
  }

  Future<void> verifyCode() async {
    if (_isLoading) return;

    final value = _code.text.trim();

    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      showMessage(
        tr(
          'أدخلي رمزًا مكونًا من 6 أرقام',
          'Enter a valid 6-digit code',
          'درست 6 ہندسوں کا کوڈ درج کریں',
        ),
      );
      return;
    }

    // واجهة التحقق عبر SMS فقط.
    // لم يتم ربط إرسال أو فحص رموز SMS بعد.
    if (isPhoneVerification ||
        widget.type != VerificationType.forgotPassword) {
      showMessage(
        tr(
          'التحقق برسائل الجوال غير مفعل حاليًا.',
          'SMS verification is not enabled yet.',
          'SMS تصدیق ابھی فعال نہیں ہے۔',
        ),
      );
      return;
    }

    // الحفاظ على التحقق السابق عبر البريد الإلكتروني.
    if (widget.email.trim().isEmpty) {
      showMessage(
        tr(
          'البريد الإلكتروني مطلوب للتحقق.',
          'Email is required for verification.',
          'تصدیق کے لیے ای میل ضروری ہے۔',
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.verifyResetCode(
        email: widget.email,
        code: value,
      );

      if (!mounted) return;

      if (result['ok'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(
              email: widget.email,
            ),
          ),
        );
      } else {
        showMessage(
          tr(
            'الرمز غير صحيح أو انتهت صلاحيته.',
            'Invalid or expired verification code.',
            'کوڈ غلط ہے یا اس کی میعاد ختم ہو گئی ہے۔',
          ),
        );
      }
    } catch (_) {
      showMessage(
        tr(
          'تعذر الاتصال بالخادم. حاولي مرة أخرى.',
          'Could not connect to the server. Try again.',
          'سرور سے رابطہ نہیں ہو سکا۔ دوبارہ کوشش کریں۔',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void resendCode() {
    // زر الواجهة فقط، دون إرسال رسائل حقيقية.
    showMessage(
      tr(
        'إعادة إرسال رمز SMS غير متاحة حاليًا.',
        'Resending SMS codes is not available yet.',
        'SMS کوڈ دوبارہ بھیجنا ابھی دستیاب نہیں ہے۔',
      ),
    );
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, currentLanguage, child) {

        final heading = isPhoneVerification
            ? tr(
          'التحقق من رقم الجوال',
          'Phone Verification',
          'موبائل نمبر کی تصدیق',
        )
            : tr(
          'رمز التحقق',
          'Verification Code',
          'تصدیقی کوڈ',
        );

        final instruction = tr(
          'أدخلي رمز التحقق المكون من 6 أرقام',
          'Enter the 6-digit verification code',
          '6 ہندسوں کا تصدیقی کوڈ درج کریں',
        );

        final verifyLabel = tr(
          'تحقق',
          'Verify',
          'تصدیق کریں',
        );

        final resendLabel = tr(
          'لم يصلك الرمز؟ إعادة الإرسال',
          'No code? Resend',
          'کوڈ نہیں ملا؟ دوبارہ بھیجیں',
        );

        return Directionality(
          textDirection: isRtl
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Scaffold(
            body: Stack(
              children: [

                Positioned.fill(
                  child: Image.asset(
                    'assets/images/backgrund.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    color: Colors.white.withValues(
                      alpha: 0.85,
                    ),
                  ),
                ),

                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(maxWidth: 500),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(30),
                            border: Border.all(
                              color: AppStyle.gold,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              const Icon(
                                Icons.security_rounded,
                                color: AppStyle.gold,
                                size: 80,
                              ),

                              const SizedBox(height: 18),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      heading,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppStyle.green,
                                        fontSize: 25,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  soundButton(heading),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Text(
                                instruction,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppStyle.green,
                                ),
                              ),

                              soundButton(instruction),

                              const SizedBox(height: 10),

                              if (destination.isNotEmpty)
                                Text(
                                  destination,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.ltr,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),

                              const SizedBox(height: 22),

                              TextField(
                                controller: _code,
                                keyboardType: TextInputType.number,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.center,
                                maxLength: 6,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly,
                                ],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 7,
                                ),
                                decoration: InputDecoration(
                                  hintText: '------',
                                  counterText: '',
                                  filled: true,
                                  fillColor:
                                  const Color(0xFFFFFDF8),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                  ),
                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: AppStyle.gold,
                                    ),
                                  ),
                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: AppStyle.green,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : verifyCode,
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor: AppStyle.green,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(25),
                                      side: const BorderSide(
                                        color: AppStyle.gold,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : Text(
                                    verifyLabel,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              soundButton(verifyLabel),

                              if (isPhoneVerification) ...[
                                const SizedBox(height: 10),

                                TextButton(
                                  onPressed: resendCode,
                                  child: Text(
                                    resendLabel,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppStyle.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                soundButton(resendLabel),

                                const SizedBox(height: 6),

                                Text(
                                  tr(
                                    'إرسال رسائل SMS غير مفعل حاليًا',
                                    'SMS sending is not enabled yet',
                                    'SMS بھیجنے کی سہولت ابھی فعال نہیں',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 15),

                              TextButton(
                                onPressed: () {
                                  Navigator.maybePop(context);
                                },
                                child: Text(
                                  tr(
                                    'رجوع',
                                    'Back',
                                    'واپس',
                                  ),
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
