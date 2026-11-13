import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';

import 'login_page.dart';
import '../services/api_service.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _birth = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  String? _gender;
  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _isSubmitting = false;

  String get lang {
    final value = AppLanguage.currentLanguage;
    return ['ar', 'en', 'ur'].contains(value) ? value : 'ar';
  }

  String tr(String ar, String en, String ur) {
    return lang == 'en' ? en : (lang == 'ur' ? ur : ar);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _birth.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
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

  Future<void> _selectDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year - 18),
      firstDate: DateTime(1920),
      lastDate: today,
    );

    if (picked == null || !mounted) return;

    _birth.text =
    '${picked.year}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }


  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    if (_gender == null) {
      _message(tr(
        'اختاري الجنس',
        'Select a gender',
        'جنس منتخب کریں',
      ));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await ApiService.register(
        fullName: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        // Account created by the existing API, but phone is NOT verified.
        // SMS verification here is only a UI placeholder.

        _message(tr(
          'تم إنشاء الحساب بنجاح',
          'Account created successfully',
          'اکاؤنٹ کامیابی سے بن گیا',
        ));


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );

      } else {
        _message(result['message']?.toString() ??
            tr(
              'فشل إنشاء الحساب',
              'Registration failed',
              'اکاؤنٹ بنانے میں ناکامی',
            ));
      }
    } catch (_) {
      if (!mounted) return;
      _message(tr(
        'تعذر الاتصال بالخادم',
        'Could not connect to server',
        'سرور سے رابطہ نہیں ہو سکا',
      ));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }


  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboard,
    bool password = false,
    bool hidden = true,
    VoidCallback? onToggle,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppStyle.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _sound(label),
            ],
          ),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboard,
            obscureText: password && hidden,
            autocorrect: !password,
            enableSuggestions: !password,
            validator: validator ??
                    (value) {
                  if (value == null || value.trim().isEmpty) {
                    return tr(
                      'هذا الحقل مطلوب',
                      'This field is required',
                      'یہ خانہ ضروری ہے',
                    );
                  }
                  return null;
                },
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(icon, color: AppStyle.green),
              suffixIcon: password
                  ? IconButton(
                onPressed: onToggle,
                icon: Icon(
                  hidden
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppStyle.green,
                ),
              )
                  : null,
              filled: true,
              fillColor: const Color(0xFFFFFDF8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppStyle.gold,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppStyle.green,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, current, _) {
        final emailPattern =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
        final phonePattern =
        RegExp(r'^\+?[0-9]{9,15}$');
        final passwordPattern =
        RegExp(r'^(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$');

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
                    color: Colors.white.withValues(alpha: 0.85),
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
                            borderRadius: BorderRadius.circular(30),
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
                                  height: 110,
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        tr(
                                          'إنشاء حساب',
                                          'Create Account',
                                          'اکاؤنٹ بنائیں',
                                        ),
                                        style: const TextStyle(
                                          color: AppStyle.green,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _sound(tr(
                                      'إنشاء حساب',
                                      'Create Account',
                                      'اکاؤنٹ بنائیں',
                                    )),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                _field(
                                  label: tr(
                                    'اسم المستخدم',
                                    'Username',
                                    'صارف کا نام',
                                  ),
                                  controller: _name,
                                  icon: Icons.person_outline,
                                ),
                                _field(
                                  label: tr(
                                    'البريد الإلكتروني',
                                    'Email Address',
                                    'ای میل',
                                  ),
                                  controller: _email,
                                  icon: Icons.email_outlined,
                                  keyboard:
                                  TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null ||
                                        !emailPattern.hasMatch(
                                            value.trim())) {
                                      return tr(
                                        'أدخلي بريدًا إلكترونيًا صحيحًا',
                                        'Enter a valid email',
                                        'درست ای میل درج کریں',
                                      );
                                    }
                                    return null;
                                  },
                                ),
                                _field(
                                  label: tr(
                                    'رقم الجوال',
                                    'Phone Number',
                                    'موبائل نمبر',
                                  ),
                                  controller: _phone,
                                  icon: Icons.phone_outlined,
                                  keyboard: TextInputType.phone,
                                  validator: (value) {
                                    final phone = (value ?? '')
                                        .replaceAll(
                                      RegExp(r'[\s()-]'),
                                      '',
                                    );
                                    if (!phonePattern.hasMatch(phone)) {
                                      return tr(
                                        'أدخلي رقم جوال صحيحًا',
                                        'Enter a valid phone number',
                                        'درست موبائل نمبر درج کریں',
                                      );
                                    }
                                    return null;
                                  },
                                ),
                                _field(
                                  label: tr(
                                    'تاريخ الميلاد',
                                    'Date of Birth',
                                    'تاریخ پیدائش',
                                  ),
                                  controller: _birth,
                                  icon:
                                  Icons.calendar_today_outlined,
                                  readOnly: true,
                                  onTap: _selectDate,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      tr('الجنس', 'Gender', 'جنس'),
                                      style: const TextStyle(
                                        color: AppStyle.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    _sound(tr(
                                      'الجنس',
                                      'Gender',
                                      'جنس',
                                    )),
                                  ],
                                ),
                                Wrap(
                                  spacing: 12,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: 'male',
                                          groupValue: _gender,
                                          activeColor: AppStyle.green,
                                          onChanged: (value) {
                                            setState(
                                                  () => _gender = value,
                                            );
                                          },
                                        ),
                                        Text(tr(
                                          'ذكر', 'Male', 'مرد',
                                        )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: 'female',
                                          groupValue: _gender,
                                          activeColor: AppStyle.green,
                                          onChanged: (value) {
                                            setState(
                                                  () => _gender = value,
                                            );
                                          },
                                        ),
                                        Text(tr(
                                          'أنثى', 'Female', 'عورت',
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _field(
                                  label: tr(
                                    'كلمة المرور',
                                    'Password',
                                    'پاس ورڈ',
                                  ),
                                  controller: _password,
                                  icon: Icons.lock_outline,
                                  password: true,
                                  hidden: _hidePassword,
                                  onToggle: () => setState(
                                        () => _hidePassword =
                                    !_hidePassword,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        !passwordPattern.hasMatch(value)) {
                                      return tr(
                                        '8 أحرف على الأقل، ورقم ورمز',
                                        'At least 8 characters, a number and a symbol',
                                        'کم از کم 8 حروف، ایک نمبر اور علامت',
                                      );
                                    }
                                    return null;
                                  },
                                ),
                                _field(
                                  label: tr(
                                    'تأكيد كلمة المرور',
                                    'Confirm Password',
                                    'پاس ورڈ کی تصدیق',
                                  ),
                                  controller: _confirm,
                                  icon: Icons.lock_outline,
                                  password: true,
                                  hidden: _hideConfirm,
                                  onToggle: () => setState(
                                        () => _hideConfirm =
                                    !_hideConfirm,
                                  ),
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
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isSubmitting ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppStyle.green,
                                      foregroundColor: Colors.white,
                                      padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(22),
                                        side: const BorderSide(
                                          color: AppStyle.gold,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      tr(
                                        'إنشاء حساب',
                                        'Create Account',
                                        'اکاؤنٹ بنائیں',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                _sound(tr(
                                  'إنشاء حساب',
                                  'Create Account',
                                  'اکاؤنٹ بنائیں',
                                )),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const LoginPage(),
                                        ),
                                      ),
                                  child: Text(
                                    tr(
                                      'لديك حساب بالفعل؟ تسجيل الدخول',
                                      'Already have an account? Login',
                                      'پہلے سے اکاؤنٹ ہے؟ لاگ ان کریں',
                                    ),
                                    style: const TextStyle(
                                      color: AppStyle.green,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
