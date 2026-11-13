import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';

import 'umrah_map_page.dart';
import 'hajj_map_page.dart';

class ChooseRitualPage extends StatefulWidget {
  const ChooseRitualPage({super.key});

  @override
  State<ChooseRitualPage> createState() => _ChooseRitualPageState();
}

class _ChooseRitualPageState extends State<ChooseRitualPage> {
  static const Map<String, Map<String, String>> texts = {
    'ar': {
      'title': 'اختيار الشعيرة',
      'umrah': 'عمرة',
      'hajj': 'حج',
      'back': 'رجوع',
    },
    'en': {
      'title': 'Choose Ritual',
      'umrah': 'Umrah',
      'hajj': 'Hajj',
      'back': 'Back',
    },
    'ur': {
      'title': 'عبادت منتخب کریں',
      'umrah': 'عمرہ',
      'hajj': 'حج',
      'back': 'واپس',
    },
  };

  String get lang {
    final current = AppLanguage.currentLanguage;
    return texts.containsKey(current) ? current : 'ar';
  }

  String tr(String key) => texts[lang]?[key] ?? texts['ar']![key]!;

  void speak(String key) {
    TtsService.speak(tr(key), language: lang);
  }

  void openUmrah() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UmrahMapPage()),
    );
  }

  void openHajj() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HajjMapPage()),
    );
  }

  Widget soundButton(String key, {double size = 43}) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.white,
        elevation: 2,
        shape: const CircleBorder(
          side: BorderSide(color: AppStyle.gold, width: 2),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          tooltip: lang == 'en'
              ? 'Listen'
              : lang == 'ur'
              ? 'سنیں'
              : 'استمع',
          onPressed: () => speak(key),
          icon: Icon(
            Icons.volume_up_rounded,
            size: size * 0.52,
            color: AppStyle.green,
          ),
        ),
      ),
    );
  }

  Widget titleWidget(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            tr('title'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppStyle.green,
              fontSize: width < 400 ? 26 : 33,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(color: Colors.white, blurRadius: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        soundButton('title'),
      ],
    );
  }

  Widget ritualLabel({
    required String key,
    required VoidCallback onTap,
    required double fontSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                tr(key),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppStyle.green,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(color: Colors.white, blurRadius: 7),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        soundButton(key),
      ],
    );
  }

  Widget ritualArea({
    required VoidCallback onTap,
    required String semanticLabel,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppStyle.gold.withValues(alpha: .15),
          highlightColor: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(25),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  // تخطيط مخصص للجوال: بطاقتان واضحتان بلا قص أو تمرير أفقي.
  Widget mobileLayout(double width, bool isRtl) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/choose2.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        Positioned.fill(
          child: ColoredBox(color: const Color(0xFFF8F3E8).withValues(alpha: .87)),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Row(
                  children: [
                    Material(
                      color: Colors.white,
                      elevation: 2,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: tr('back'),
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          isRtl ? Icons.arrow_forward : Icons.arrow_back,
                          color: AppStyle.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: titleWidget(width)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  children: [
                    mobileRitualCard(
                      keyName: 'umrah',
                      icon: Icons.mosque_outlined,
                      onTap: openUmrah,
                    ),
                    const SizedBox(height: 20),
                    mobileRitualCard(
                      keyName: 'hajj',
                      icon: Icons.route_outlined,
                      onTap: openHajj,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileRitualCard({
    required String keyName,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppStyle.gold, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
            child: SizedBox(
              height: 175,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 83, color: AppStyle.green),
                  const SizedBox(height: 10),
                  Text(
                    tr(keyName),
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppStyle.gold),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(tr(keyName)),
                    style: TextButton.styleFrom(foregroundColor: AppStyle.green),
                  ),
                ),
                soundButton(keyName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // تخطيط الشاشة الكبيرة الأصلي يبقى كما هو.
  Widget wideLayout(double width, double height, bool isRtl) {
    final labelSize = width < 600 ? 24.0 : 32.0;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/choose2.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        Positioned(
          left: width * .04,
          top: height * .27,
          width: width * .45,
          height: height * .49,
          child: ritualArea(onTap: openUmrah, semanticLabel: tr('umrah')),
        ),
        Positioned(
          right: width * .04,
          top: height * .27,
          width: width * .45,
          height: height * .49,
          child: ritualArea(onTap: openHajj, semanticLabel: tr('hajj')),
        ),
        Positioned(
          top: 23,
          left: 10,
          right: 10,
          child: titleWidget(width),
        ),
        Positioned(
          left: width * .02,
          top: height * .60,
          width: width * .48,
          child: ritualLabel(key: 'umrah', onTap: openUmrah, fontSize: labelSize),
        ),
        Positioned(
          right: width * .02,
          top: height * .60,
          width: width * .48,
          child: ritualLabel(key: 'hajj', onTap: openHajj, fontSize: labelSize),
        ),
        PositionedDirectional(
          top: 12,
          start: 12,
          child: Material(
            color: Colors.white.withValues(alpha: .94),
            shape: const CircleBorder(),
            elevation: 3,
            child: IconButton(
              tooltip: tr('back'),
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                isRtl ? Icons.arrow_forward : Icons.arrow_back,
                color: AppStyle.green,
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
      builder: (context, selectedLanguage, _) {
        final isRtl = selectedLanguage != 'en';
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8F3E8),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;
                  return width < 600
                      ? mobileLayout(width, isRtl)
                      : wideLayout(width, height, isRtl);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
