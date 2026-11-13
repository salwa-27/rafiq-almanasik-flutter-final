
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';

import 'verification_page.dart';

class PhoneVerificationPage extends StatefulWidget {
  final VerificationType type;

  const PhoneVerificationPage({
    super.key,
    this.type = VerificationType.register,
  });

  @override
  State<PhoneVerificationPage> createState() =>
      _PhoneVerificationPageState();
}

class _PhoneVerificationPageState
    extends State<PhoneVerificationPage> {

  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String get lang => AppLanguage.currentLanguage;

  String tr(String ar, String en, String ur) {
    if (lang == 'en') return en;
    if (lang == 'ur') return ur;
    return ar;
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim()
        .replaceAll(RegExp(r'[\s()-]'), '');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerificationPage(
          type: widget.type,
          phone: phone,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, language, _) {

        final title = tr(
          'التحقق برقم الجوال',
          'Phone Verification',
          'موبائل نمبر کی تصدیق',
        );

        final instruction = tr(
          'أدخلي رقم الجوال للانتقال إلى صفحة رمز التحقق',
          'Enter your phone number to open the code page',
          'تصدیقی کوڈ کے صفحے پر جانے کے لیے نمبر درج کریں',
        );

        return Directionality(
          textDirection: language == 'en'
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

                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.phone_android,
                                  color: AppStyle.gold,
                                  size: 80,
                                ),

                                const SizedBox(height: 20),

                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () =>
                                      TtsService.speak(
                                        title,
                                        language: language,
                                      ),
                                  icon: const Icon(
                                    Icons.volume_up_rounded,
                                    color: AppStyle.green,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                Text(
                                  instruction,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppStyle.green,
                                    fontSize: 16,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () =>
                                      TtsService.speak(
                                        instruction,
                                        language: language,
                                      ),
                                  icon: const Icon(
                                    Icons.volume_up_rounded,
                                    color: AppStyle.green,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                    hintText: '+9665XXXXXXXX',
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: AppStyle.green,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator: (value) {
                                    final phone = (value ?? '')
                                        .replaceAll(
                                      RegExp(r'[\s()-]'),
                                      '',
                                    );

                                    if (!RegExp(
                                      r'^\+?[0-9]{9,15}$',
                                    ).hasMatch(phone)) {
                                      return tr(
                                        'أدخلي رقم جوال صحيحًا',
                                        'Enter a valid phone number',
                                        'درست موبائل نمبر درج کریں',
                                      );
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 25),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _next,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppStyle.green,
                                      foregroundColor: Colors.white,
                                      padding:
                                      const EdgeInsets.all(16),
                                    ),
                                    child: Text(
                                      tr(
                                        'التالي',
                                        'Next',
                                        'اگلا',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child: Text(
                                    tr(
                                      'رجوع',
                                      'Back',
                                      'واپس',
                                    ),
                                    style: const TextStyle(
                                      color: AppStyle.green,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

