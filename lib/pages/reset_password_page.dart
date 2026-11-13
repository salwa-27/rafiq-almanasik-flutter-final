
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import '../services/api_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordPage> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;

  String get lang {
    final l = AppLanguage.currentLanguage;
    return ['ar', 'en', 'ur'].contains(l) ? l : 'ar';
  }

  String tr(String ar, String en, String ur) =>
      lang == 'en' ? en : (lang == 'ur' ? ur : ar);

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Widget _sound(String text) {
    return IconButton(
      tooltip: tr('استمع', 'Listen', 'سنیں'),
      onPressed: () => TtsService.speak(text, language: lang),
      icon: const Icon(
        Icons.volume_up_rounded,
        color: AppStyle.green,
      ),
    );
  }


  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await ApiService.saveNewPassword(
      password: _password.text,
    );

    if (!mounted) return;

    if (result['ok'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(
            'تم تغيير كلمة المرور بنجاح',
            'Password changed successfully',
            'پاس ورڈ کامیابی سے تبدیل ہو گیا',
          )),
        ),
      );

      // الرجوع إلى صفحة تسجيل الدخول بعد نجاح الحفظ.
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      final error = result['error'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error == 'verification_required'
                ? tr(
              'انتهت جلسة التحقق، أعيدي طلب الرمز',
              'Verification expired. Request a new code',
              'تصدیق کی مدت ختم ہو گئی، نیا کوڈ حاصل کریں',
            )
                : error == 'weak_password'
                ? tr(
              'كلمة المرور ضعيفة، استخدمي 8 أحرف على الأقل ورقمًا ورمزًا',
              'Weak password. Use at least 8 characters, a number and a symbol',
              'کم از کم 8 حروف، ایک نمبر اور علامت استعمال کریں',
            )
                : tr(
              'تعذر حفظ كلمة المرور، حاولي مرة أخرى',
              'Could not save password. Please try again',
              'پاس ورڈ محفوظ نہیں ہو سکا، دوبارہ کوشش کریں',
            ),
          ),
        ),
      );
    }
  }


  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppStyle.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _sound(label),
          ],
        ),
        TextFormField(
          controller: controller,
          obscureText: hidden,
          autocorrect: false,
          enableSuggestions: false,
          validator: validator,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppStyle.green,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                hidden
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppStyle.green,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFFFFDF8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppStyle.gold,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppStyle.green,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, current, _) {
        final pattern = RegExp(
          r'^(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$',
        );

        return Directionality(
          textDirection: lang == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
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
                    color: const Color(0xFFF6EFDF)
                        .withValues(alpha: 0.87),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(maxWidth: 600),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(30),
                            border: Border.all(
                              color: AppStyle.gold,
                              width: 2,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 100,
                                ),
                                const SizedBox(height: 15),
                                const Icon(
                                  Icons.lock_reset_rounded,
                                  size: 65,
                                  color: AppStyle.gold,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        tr(
                                          'تعيين كلمة مرور جديدة',
                                          'Set New Password',
                                          'نیا پاس ورڈ بنائیں',
                                        ),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: AppStyle.green,
                                        ),
                                      ),
                                    ),
                                    _sound(tr(
                                      'تعيين كلمة مرور جديدة',
                                      'Set New Password',
                                      'نیا پاس ورڈ بنائیں',
                                    )),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  tr(
                                    'أدخلي كلمة المرور الجديدة وأكديها.',
                                    'Enter and confirm your new password.',
                                    'نیا پاس ورڈ درج کریں اور تصدیق کریں۔',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  widget.email,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                _passwordField(
                                  label: tr(
                                    'كلمة المرور الجديدة',
                                    'New Password',
                                    'نیا پاس ورڈ',
                                  ),
                                  controller: _password,
                                  hidden: _hidePassword,
                                  onToggle: () {
                                    setState(() {
                                      _hidePassword =
                                      !_hidePassword;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        !pattern.hasMatch(value)) {
                                      return tr(
                                        '8 أحرف على الأقل، ورقم ورمز',
                                        'At least 8 characters, a number and a symbol',
                                        'کم از کم 8 حروف، ایک نمبر اور علامت',
                                      );
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                _passwordField(
                                  label: tr(
                                    'تأكيد كلمة المرور',
                                    'Confirm Password',
                                    'پاس ورڈ کی تصدیق',
                                  ),
                                  controller: _confirm,
                                  hidden: _hideConfirm,
                                  onToggle: () {
                                    setState(() {
                                      _hideConfirm =
                                      !_hideConfirm;
                                    });
                                  },
                                  validator: (value) {
                                    if (value != _password.text) {
                                      return tr(
                                        'كلمتا المرور غير متطابقتين',
                                        'Passwords do not match',
                                        'دونوں پاس ورڈ ایک جیسے نہیں',
                                      );
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _save,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      AppStyle.green,
                                      foregroundColor:
                                      Colors.white,
                                      padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Text(
                                      tr(
                                        'حفظ كلمة المرور',
                                        'Save Password',
                                        'پاس ورڈ محفوظ کریں',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                _sound(tr(
                                  'حفظ كلمة المرور',
                                  'Save Password',
                                  'پاس ورڈ محفوظ کریں',
                                )),
                                TextButton.icon(
                                  onPressed: () =>
                                      Navigator.maybePop(context),
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                  ),
                                  label: Text(tr(
                                    'رجوع',
                                    'Back',
                                    'واپس',
                                  )),
                                ),
                              ],
                            ),
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
