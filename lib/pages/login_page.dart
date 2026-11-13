
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../services/api_service.dart';
import 'home_page.dart';
import 'choose_ritual_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;

  String get lang {
    final l = AppLanguage.currentLanguage;
    return ['ar', 'en', 'ur'].contains(l) ? l : 'ar';
  }

  String tr(String ar, String en, String ur) =>
      lang == 'en' ? en : (lang == 'ur' ? ur : ar);

  @override
   dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget _sound(String text) => IconButton(
    tooltip: tr('استمع', 'Listen', 'سنیں'),
    onPressed: () => TtsService.speak(text, language: lang),
    icon: const Icon(
      Icons.volume_up_rounded,
      color: AppStyle.green,
    ),
  );


  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await ApiService.login(
        emailOrPhone: _email.text.trim(),
        password: _password.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr(
              'تم تسجيل الدخول بنجاح',
              'Login successful',
              'لاگ ان کامیاب ہو گیا',
            )),
          ),
        );
        final prefs = await SharedPreferences.getInstance();
        final saved = await prefs.setBool('isLoggedIn', true);
        debugPrint('LOGIN SAVED: $saved');

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(afterLogin: true),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message']?.toString() ??
                  tr(
                    'فشل تسجيل الدخول',
                    'Login failed',
                    'لاگ ان ناکام ہو گیا',
                  ),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(
            'تعذر الاتصال بالخادم',
            'Could not connect to server',
            'سرور سے رابطہ نہیں ہو سکا',
          )),
        ),
      );
    }
  }


  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
    bool isPassword = false,
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
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.green,
                ),
              ),
            ),
            _sound(label),
          ],
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          obscureText: isPassword && _hidePassword,
          autocorrect: !isPassword,
          enableSuggestions: !isPassword,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon, color: AppStyle.green),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _hidePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppStyle.green,
              ),
              onPressed: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              },
            )
                : null,
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
        final emailRegex =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
        final phoneRegex =
        RegExp(r'^\+?[0-9]{9,15}$');

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
                        .withValues(alpha: 0.85),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 650,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: AppStyle.gold,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                height: 125,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      tr(
                                        'تسجيل الدخول',
                                        'Login',
                                        'لاگ ان',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: AppStyle.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _sound(tr(
                                    'تسجيل الدخول',
                                    'Login',
                                    'لاگ ان',
                                  )),
                                ],
                              ),
                              const SizedBox(height: 30),
                              _field(
                                label: tr(
                                  'البريد الإلكتروني أو رقم الجوال',
                                  'Email or Phone Number',
                                  'ای میل یا موبائل نمبر',
                                ),
                                controller: _email,
                                icon: Icons.email_outlined,
                                validator: (value) {
                                  final v = value?.trim() ?? '';
                                  final phone = v.replaceAll(
                                    RegExp(r'[\s()-]'),
                                    '',
                                  );
                                  if (emailRegex.hasMatch(v) ||
                                      phoneRegex.hasMatch(phone)) {
                                    return null;
                                  }
                                  return tr(
                                    'أدخلي بريدًا أو رقم جوال صحيحًا',
                                    'Enter a valid email or phone',
                                    'درست ای میل یا موبائل نمبر درج کریں',
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              _field(
                                label: tr(
                                  'كلمة المرور',
                                  'Password',
                                  'پاس ورڈ',
                                ),
                                controller: _password,
                                icon: Icons.lock_outline,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return tr(
                                      'هذا الحقل مطلوب',
                                      'This field is required',
                                      'یہ خانہ ضروری ہے',
                                    );
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment:
                                AlignmentDirectional.centerStart,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    tr(
                                      'نسيت كلمة المرور؟',
                                      'Forgot Password?',
                                      'پاس ورڈ بھول گئے؟',
                                    ),
                                    style: const TextStyle(
                                      color: AppStyle.green,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyle.green,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(
                                      vertical: 16,
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
                                  child: Text(
                                    tr(
                                      'تسجيل الدخول',
                                      'Login',
                                      'لاگ ان',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              _sound(tr(
                                'تسجيل الدخول',
                                'Login',
                                'لاگ ان',
                              )),
                              const SizedBox(height: 18),
                              Text(
                                tr(
                                  'ليس لديك حساب؟',
                                  "Don't have an account?",
                                  'کیا آپ کا اکاؤنٹ نہیں ہے؟',
                                ),
                                style: const TextStyle(
                                  color: AppStyle.green,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  tr(
                                    'إنشاء حساب',
                                    'Create Account',
                                    'اکاؤنٹ بنائیں',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppStyle.green,
                                    fontWeight: FontWeight.bold,
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
