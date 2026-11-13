
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import 'umrah_step_page.dart';
import 'dua_book_page.dart';

class UmrahMapPage extends StatelessWidget {
  const UmrahMapPage({super.key});

  static const texts = <String, Map<String, String>>{
    'ar': {
      'title': 'خريطة العمرة',
      'mapTitle': 'خطوات العمرة',
      'ihram': 'الإحرام',
      'tawaf': 'الطواف',
      'sai': 'السعي',
      'haircut': 'الحلق أو التقصير',
      'back': 'رجوع',
      'duaBook': 'دفتر الأدعية',
      'listen': 'استمع',
    },
    'en': {
      'title': 'Umrah Map',
      'mapTitle': 'Umrah Steps',
      'ihram': 'Ihram',
      'tawaf': 'Tawaf',
      'sai': 'Sa’i',
      'haircut': 'Shaving or Trimming',
      'back': 'Back',
      'duaBook': 'Dua Book',
      'listen': 'Listen',
    },
    'ur': {
      'title': 'عمرہ کا نقشہ',
      'mapTitle': 'عمرے کے مراحل',
      'ihram': 'احرام',
      'tawaf': 'طواف',
      'sai': 'سعی',
      'haircut': 'حلق یا قصر',
      'back': 'واپس',
      'duaBook': 'دعاؤں کی کتاب',
      'listen': 'سنیں',
    },
  };

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<String>(
        valueListenable: AppLanguage.languageNotifier,
        builder: (context, value, _) {
          final lang = texts.containsKey(value) ? value : 'ar';
          final words = texts[lang]!;

          Widget audio(String message) => IconButton(
            constraints: const BoxConstraints(
              minWidth: 35,
              minHeight: 35,
            ),
            padding: EdgeInsets.zero,
            tooltip: words['listen']!,
            onPressed: () =>
                TtsService.speak(message, language: lang),
            icon: const Icon(
              Icons.volume_up_rounded,
              color: AppStyle.green,
              size: 21,
            ),
          );

          Widget step(
              String key,
              int num,
              double x,
              double y,
              double width,
              double height,
              ) =>
              Positioned(
                left: x * width,
                top: y * height,
                child: Container(
                  constraints:
                  const BoxConstraints(maxWidth: 178),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .94),
                    border: Border.all(
                      color: AppStyle.gold,
                      width: 1.6,
                    ),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                UmrahStepPage(stepKey: key),
                          ),
                        ),
                        borderRadius:
                        BorderRadius.circular(27),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: AppStyle.green,
                                child: Text(
                                  '$num',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              ConstrainedBox(
                                constraints:
                                const BoxConstraints(
                                  maxWidth: 88,
                                ),
                                child: Text(
                                  words[key]!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppStyle.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      audio(words[key]!),
                    ],
                  ),
                ),
              );

          void openDuaBook() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const DuaBookPage(stepKey: ''),
              ),
            );
          }

          return Directionality(
            textDirection: lang == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6EFDF),

              // الشريط الأخضر مثل خريطة الحج
              appBar: AppBar(
                backgroundColor: AppStyle.green,
                foregroundColor: Colors.white,
                centerTitle: true,
                title: Text(words['title']!),
                actions: [
                  IconButton(
                    tooltip: words['duaBook']!,
                    onPressed: openDuaBook,
                    icon: const Icon(
                      Icons.menu_book_outlined,
                    ),
                  ),
                ],
              ),

              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, bounds) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),

                        // مكبر العنوان الموجود فوق الخريطة
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            audio(words['title']!),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Expanded(
                          child: InteractiveViewer(
                            minScale: 1,
                            maxScale: 3.5,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 0.76,
                                child: LayoutBuilder(
                                  builder: (context, c) {
                                    return Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.asset(
                                            'assets/images/umrah-map-clean .png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),

                                        // عنوان اللوحة الذهبية
                                        Positioned(
                                          left:
                                          c.maxWidth * .285,
                                          top:
                                          c.maxHeight * .062,
                                          width:
                                          c.maxWidth * .43,
                                          height:
                                          c.maxHeight * .080,
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                words['mapTitle']!,
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                                style:
                                                const TextStyle(
                                                  color:
                                                  AppStyle.green,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        step(
                                          'ihram',
                                          1,
                                          .45,
                                          .17,
                                          c.maxWidth,
                                          c.maxHeight,
                                        ),
                                        step(
                                          'tawaf',
                                          2,
                                          .04,
                                          .33,
                                          c.maxWidth,
                                          c.maxHeight,
                                        ),
                                        step(
                                          'sai',
                                          3,
                                          .42,
                                          .49,
                                          c.maxWidth,
                                          c.maxHeight,
                                        ),
                                        step(
                                          'haircut',
                                          4,
                                          .06,
                                          .68,
                                          c.maxWidth,
                                          c.maxHeight,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () =>
                                    Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                ),
                                label: Text(words['back']!),
                                style:
                                OutlinedButton.styleFrom(
                                  foregroundColor:
                                  AppStyle.green,
                                  side: const BorderSide(
                                    color: AppStyle.gold,
                                  ),
                                ),
                              ),
                              audio(words['back']!),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
}
