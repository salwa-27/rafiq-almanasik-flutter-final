
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import '../services/api_service.dart';

import 'verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  String get lang {
    final language = AppLanguage.currentLanguage;
    return ['ar', 'en', 'ur'].contains(language)
        ? language
        : 'ar';
  }

  String tr(String ar, String en, String ur) {
    if (lang == 'en') return en;
    if (lang == 'ur') return ur;
    return ar;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget _sound(String text) {
    return IconButton(
      tooltip: tr('استمع', 'Listen', 'سنیں'),
      icon: const Icon(
        Icons.volume_up_rounded,
        color: AppStyle.green,
      ),
      onPressed: () {
        TtsService.speak(text, language: lang);
      },
    );
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  Future<void> _send() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // إرسال طلب استعادة كلمة المرور
      // إلى PHP API عبر البريد الإلكتروني.

      final result =
      await ApiService.requestPasswordReset(
        email: email,
      );

      if (!mounted) return;

      if (result['ok'] == true) {

        // الانتقال إلى التحقق عبر البريد فقط.

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationPage(
              type: VerificationType.forgotPassword,
              email: email,
            ),
          ),
        );

      } else {
        _message(
          tr(
            'تعذر إرسال الطلب، حاولي لاحقًا',
            'Could not send the request. Try again later.',
            'درخواست نہیں بھیجی جا سکی۔ بعد میں کوشش کریں۔',
          ),
        );
      }

    } catch (_) {
      _message(
        tr(
          'تعذر الاتصال بالخادم',
          'Could not connect to the server',
          'سرور سے رابطہ نہیں ہو سکا',
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

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, current, _) {

        final title = tr(
          'استعادة كلمة المرور',
          'Reset Password',
          'پاس ورڈ دوبارہ بنائیں',
        );

        final emailLabel = tr(
          'البريد الإلكتروني',
          'Email Address',
          'ای میل',
        );

        final instruction = tr(
          'أدخلي بريدك الإلكتروني لإرسال رمز التحقق',
          'Enter your email to receive a verification code',
          'تصدیقی کوڈ حاصل کرنے کے لیے اپنا ای میل درج کریں',
        );

        final buttonLabel = tr(
          'إرسال رمز التحقق',
          'Send Verification Code',
          'تصدیقی کوڈ بھیجیں',
        );

        return Directionality(
          textDirection: current == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,

          child: Scaffold(
            backgroundColor: AppStyle.cream,

            appBar: AppBar(
              backgroundColor: AppStyle.green,
              foregroundColor: Colors.white,
              title: Text(
                tr(
                  'نسيت كلمة المرور',
                  'Forgot Password',
                  'پاس ورڈ بھول گئے',
                ),
              ),
            ),

            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: ConstrainedBox(
                    constraints:
                    const BoxConstraints(maxWidth: 550),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          const Icon(
                            Icons.lock_reset_rounded,
                            size: 80,
                            color: AppStyle.gold,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _sound(title),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            instruction,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppStyle.green,
                              fontSize: 16,
                            ),
                          ),

                          _sound(instruction),

                          const SizedBox(height: 25),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  emailLabel,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              _sound(emailLabel),
                            ],
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _emailController,
                            textDirection: TextDirection.ltr,
                            keyboardType:
                            TextInputType.emailAddress,
                            autofillHints: const [
                              AutofillHints.email,
                            ],

                            decoration: InputDecoration(
                              hintText: 'example@email.com',

                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: AppStyle.green,
                              ),

                              filled: true,
                              fillColor: Colors.white,

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

                            validator: (value) {
                              final email =
                                  value?.trim() ?? '';

                              if (!RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(email)) {
                                return tr(
                                  'أدخلي بريدًا إلكترونيًا صحيحًا',
                                  'Enter a valid email address',
                                  'درست ای میل درج کریں',
                                );
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              onPressed:
                              _isLoading ? null : _send,

                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppStyle.green,
                                foregroundColor: Colors.white,
                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),

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
                                height: 24,
                                width: 24,
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                buttonLabel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          _sound(buttonLabel),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
