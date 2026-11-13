
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';

import 'choose_ritual_page.dart';
import 'home_page.dart';

class HajjFinishPage extends StatelessWidget {
  const HajjFinishPage({super.key});

  static const messages = {
    'ar': {
      'title': 'إتمام مناسك الحج',
      'congrats': 'تقبل الله حجك وطاعتك',
      'prayer':
      'نسأل الله لك حجًا مبرورًا وسعيًا مشكورًا وذنبًا مغفورًا.',
      'reminder':
      'تأكدي من إتمام جميع الأركان والواجبات التي تلزمك قبل اعتبار مناسك الحج مكتملة.',
      'question': 'هل تريدين أداء شعيرة أخرى؟',
      'yes': 'نعم، اختيار شعيرة',
      'no': 'لا، العودة للرئيسية',
    },
    'en': {
      'title': 'Hajj Journey Completed',
      'congrats': 'May Allah accept your Hajj',
      'prayer':
      'May Allah grant you an accepted Hajj and reward your efforts.',
      'reminder':
      'Make sure all applicable pillars and obligations have been completed.',
      'question': 'Would you like to explore another ritual?',
      'yes': 'Yes, Choose a Ritual',
      'no': 'No, Go Home',
    },
    'ur': {
      'title': 'حج کے مناسک مکمل',
      'congrats': 'اللہ آپ کا حج قبول فرمائے',
      'prayer':
      'اللہ آپ کو حج مبرور اور مقبول عبادت نصیب فرمائے۔',
      'reminder':
      'یقینی بنائیں کہ تمام لازم ارکان اور واجبات ادا ہو گئے ہیں۔',
      'question': 'کیا آپ کوئی اور عبادت دیکھنا چاہتے ہیں؟',
      'yes': 'ہاں، عبادت منتخب کریں',
      'no': 'نہیں، مرکزی صفحہ',
    },
  };

  Widget sound(String text, String lang) {
    return IconButton(
      tooltip: lang == 'en'
          ? 'Listen'
          : lang == 'ur'
          ? 'سنیں'
          : 'استمع',
      onPressed: () {
        TtsService.speak(text, language: lang);
      },
      icon: const Icon(
        Icons.volume_up_rounded,
        color: AppStyle.green,
      ),
    );
  }

  Widget spokenText(
      String value,
      String lang, {
        double fontSize = 18,
        FontWeight weight = FontWeight.w600,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppStyle.green,
              fontSize: fontSize,
              fontWeight: weight,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(width: 8),
        sound(value, lang),
      ],
    );
  }

  Widget navigationButton({
    required BuildContext context,
    required String text,
    required String lang,
    required VoidCallback onPressed,
    bool filled = true,
  }) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(23),
      side: const BorderSide(
        color: AppStyle.gold,
        width: 1.5,
      ),
    );

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: filled
              ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyle.green,
              foregroundColor: Colors.white,
              shape: shape,
              padding: const EdgeInsets.all(17),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppStyle.green,
              shape: shape,
              padding: const EdgeInsets.all(17),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        sound(text, lang),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, current, _) {
        final lang = messages.containsKey(current)
            ? current
            : 'ar';

        final m = messages[lang]!;

        return Directionality(
          textDirection: lang == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppStyle.cream,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/backgrund.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return Container(
                        color: AppStyle.cream,
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: AppStyle.cream.withOpacity(0.88),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(18),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 650,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 23,
                          vertical: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(29),
                          border: Border.all(
                            color: AppStyle.gold,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, 7),
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

                            spokenText(
                              m['title']!,
                              lang,
                              fontSize: 28,
                              weight: FontWeight.bold,
                            ),

                            const SizedBox(height: 15),

                            spokenText(
                              m['congrats']!,
                              lang,
                              fontSize: 22,
                            ),

                            const SizedBox(height: 14),

                            spokenText(
                              m['prayer']!,
                              lang,
                            ),

                            const SizedBox(height: 20),

                            const Divider(
                              color: AppStyle.gold,
                              thickness: 1.5,
                            ),

                            const SizedBox(height: 18),

                            spokenText(
                              m['reminder']!,
                              lang,
                              fontSize: 15,
                              weight: FontWeight.normal,
                            ),

                            const SizedBox(height: 22),

                            spokenText(
                              m['question']!,
                              lang,
                              fontSize: 20,
                            ),

                            const SizedBox(height: 24),

                            navigationButton(
                              context: context,
                              text: m['yes']!,
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

                            const SizedBox(height: 10),

                            navigationButton(
                              context: context,
                              text: m['no']!,
                              lang: lang,
                              filled: false,
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const ChooseRitualPage(),                                  ),
                                      (route) => false,
                                );
                              },
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
