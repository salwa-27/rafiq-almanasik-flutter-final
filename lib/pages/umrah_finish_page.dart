
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';

import 'choose_ritual_page.dart';
import 'home_page.dart';

class UmrahFinishPage extends StatelessWidget {
  const UmrahFinishPage({super.key});

  static const texts = {
    'ar': {
      'title': 'تم إتمام العمرة',
      'message': 'تقبل الله عمرتك وطاعتك',
      'question': 'هل تريد أداء شعيرة أخرى؟',
      'yes': 'نعم',
      'no': 'لا',
    },
    'en': {
      'title': 'Umrah Completed',
      'message': 'May Allah accept your Umrah',
      'question': 'Would you like to perform another ritual?',
      'yes': 'Yes',
      'no': 'No',
    },
    'ur': {
      'title': 'عمرہ مکمل ہو گیا',
      'message': 'اللہ آپ کا عمرہ قبول فرمائے',
      'question': 'کیا آپ کوئی اور عبادت ادا کرنا چاہتے ہیں؟',
      'yes': 'ہاں',
      'no': 'نہیں',
    },
  };

  Widget audio(String text, String lang) {
    return SizedBox(
      width: 43,
      height: 43,
      child: Material(
        color: Colors.white,
        elevation: 2,
        shape: const CircleBorder(
          side: BorderSide(
            color: AppStyle.gold,
            width: 2,
          ),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.volume_up_rounded,
            color: AppStyle.green,
          ),
          onPressed: () => TtsService.speak(
            text,
            language: lang,
          ),
        ),
      ),
    );
  }

  Widget textWithAudio(
      String text,
      String lang, {
        double size = 22,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppStyle.green,
              fontSize: size,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        audio(text, lang),
      ],
    );
  }

  Widget answerButton({
    required String text,
    required String lang,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyle.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(
                  color: AppStyle.gold,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        audio(text, lang),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, selectedLanguage, _) {
        final lang = texts.containsKey(selectedLanguage)
            ? selectedLanguage
            : 'ar';

        final words = texts[lang]!;

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
                        .withValues(alpha: .88),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 700,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(32),
                          border: Border.all(
                            color: AppStyle.gold,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 25,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppStyle.green,
                              size: 90,
                            ),

                            const SizedBox(height: 20),

                            textWithAudio(
                              words['title']!,
                              lang,
                              size: 29,
                            ),

                            const SizedBox(height: 22),

                            textWithAudio(
                              words['message']!,
                              lang,
                              size: 19,
                            ),

                            const SizedBox(height: 30),

                            const Divider(
                              color: AppStyle.gold,
                              thickness: 1.5,
                            ),

                            const SizedBox(height: 25),

                            textWithAudio(
                              words['question']!,
                              lang,
                              size: 22,
                            ),

                            const SizedBox(height: 35),

                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: answerButton(
                                    text: words['yes']!,
                                    lang: lang,
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const ChooseRitualPage(),
                                        ),
                                            (route) => false,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: answerButton(
                                    text: words['no']!,
                                    lang: lang,
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context, MaterialPageRoute(
                                        builder: (_) =>
                                        const ChooseRitualPage(),
                                      ),
                                            (route) => false,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
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
