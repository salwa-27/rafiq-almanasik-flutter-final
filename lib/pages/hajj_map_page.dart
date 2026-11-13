import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import 'hajj_step_page.dart';
import 'dua_book_page.dart';

// بيانات المواقيت داخل صفحة خريطة الحج، بدون صفحة مواقيت مستقلة.
class _Miqat {
  final String ar;
  final String en;
  final String ur;
  final String detailAr;
  final String detailEn;
  final String detailUr;
  final String mapQuery;
  final String shopsQuery;

  const _Miqat({
    required this.ar,
    required this.en,
    required this.ur,
    required this.detailAr,
    required this.detailEn,
    required this.detailUr,
    required this.mapQuery,
    required this.shopsQuery,
  });

  String name(String lang) =>
      lang == 'en' ? en : (lang == 'ur' ? ur : ar);

  String detail(String lang) => lang == 'en'
      ? detailEn
      : (lang == 'ur' ? detailUr : detailAr);
}

class HajjMapPage extends StatefulWidget {
  // اختياري للحفاظ على التوافق مع الصفحات التي تمرر نوع الحج.
  final String? hajjType;

  const HajjMapPage({super.key, this.hajjType});

  @override
  State<HajjMapPage> createState() => _HajjMapPageState();
}

class _HajjMapPageState extends State<HajjMapPage> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    final start = widget.hajjType;
    _selectedType = const ['tamattu', 'qiran', 'ifrad', 'general'].contains(start)
        ? start!
        : 'tamattu';
  }

  // عند الدخول من (اختيار الشعيرة) نظهر أنواع الحج الثلاثة أولاً.
  // عند اختيار نوع، نفتح نفس الخريطة القديمة بمساره الخاص.
  bool get _showTypeHome => widget.hajjType == null;

  String get lang {
    final selected = AppLanguage.currentLanguage;
    return const ['ar', 'en', 'ur'].contains(selected) ? selected : 'ar';
  }

  String tr(String ar, String en, String ur) {
    return lang == 'en' ? en : (lang == 'ur' ? ur : ar);
  }

  static const List<_Miqat> _miqats = [
    _Miqat(
      ar: 'قرن المنازل (السيل الكبير)',
      en: 'Qarn al-Manazil (Al-Sail Al-Kabir)',
      ur: 'قرن المنازل (السیل الکبیر)',
      detailAr: 'ميقات القادمين من جهة نجد والطائف ومن مرّ بطريقهم.',
      detailEn: 'Miqat for pilgrims arriving from Najd, Taif and this route.',
      detailUr: 'نجد اور طائف کی سمت سے آنے والوں اور اس راستے سے گزرنے والوں کا میقات۔',
      mapQuery: 'مسجد ميقات قرن المنازل السيل الكبير الطائف',
      shopsQuery: 'محلات ملابس الإحرام بالقرب من ميقات السيل الكبير الطائف',
    ),
    _Miqat(
      ar: 'الجحفة (رابغ)',
      en: 'Al-Juhfah (Rabigh)',
      ur: 'الجحفہ (رابغ)',
      detailAr: 'ميقات القادمين من جهة الشام ومصر والمغرب؛ ويُحرم كثير من الناس من رابغ بدل موقع الجحفة القديم.',
      detailEn: 'Miqat for routes from the Levant, Egypt and the Maghreb; Rabigh is commonly used instead of old Al-Juhfah.',
      detailUr: 'شام، مصر اور مغرب کی سمت کا میقات؛ پرانے جحفہ کے بجائے عام طور پر رابغ سے احرام باندھا جاتا ہے۔',
      mapQuery: 'ميقات رابغ الجحفة مسجد الميقات',
      shopsQuery: 'محلات ملابس الإحرام بالقرب من ميقات رابغ الجحفة',
    ),
    _Miqat(
      ar: 'ذو الحليفة (أبيار علي)',
      en: 'Dhu al-Hulayfah (Abyar Ali)',
      ur: 'ذوالحلیفہ (ابیار علی)',
      detailAr: 'ميقات القادمين من المدينة المنورة ومن مرّ بطريقها.',
      detailEn: 'Miqat for pilgrims coming from Madinah and its route.',
      detailUr: 'مدینہ منورہ اور اس راستے سے آنے والے حاجیوں کا میقات۔',
      mapQuery: 'مسجد ميقات ذو الحليفة أبيار علي المدينة المنورة',
      shopsQuery: 'محلات ملابس الإحرام بالقرب من مسجد ميقات أبيار علي المدينة المنورة',
    ),
    _Miqat(
      ar: 'يلملم (السعدية)',
      en: 'Yalamlam (Al-Sadiyah)',
      ur: 'یلملم (السعدیہ)',
      detailAr: 'ميقات القادمين من جهة اليمن وتهامة ومن مرّ بطريقهم.',
      detailEn: 'Miqat for pilgrims arriving from Yemen, Tihamah and this route.',
      detailUr: 'یمن اور تہامہ کی سمت اور اس راستے سے آنے والوں کا میقات۔',
      mapQuery: 'ميقات يلملم السعدية مسجد الميقات',
      shopsQuery: 'محلات ملابس الإحرام بالقرب من ميقات يلملم السعدية',
    ),
    _Miqat(
      ar: 'ذات عرق (الضريبة)',
      en: 'Dhat Irq (Al-Daribah)',
      ur: 'ذات عرق (الضریبہ)',
      detailAr: 'ميقات القادمين من جهة العراق ومن مرّ بطريقهم.',
      detailEn: 'Miqat for pilgrims arriving from Iraq and this route.',
      detailUr: 'عراق کی سمت اور اس راستے سے آنے والوں کا میقات۔',
      mapQuery: 'مسجد ميقات ذات عرق الضريبة',
      shopsQuery: 'محلات ملابس الإحرام بالقرب من ميقات ذات عرق الضريبة',
    ),
  ];

  // مواضع مرقمة من اليسار إلى اليمين، ثم من الأعلى إلى الأسفل.
  // تتكيف الأرقام تلقائياً مع ترتيب خطوات نوع الحج المختار.
  // لا تُكرر الخطوات في قائمة أسفل الخريطة.
  static const List<Offset> _orderedPositions = [
    Offset(0.12, 0.19), Offset(0.31, 0.19), Offset(0.50, 0.19),
    Offset(0.69, 0.19), Offset(0.87, 0.19),
    Offset(0.12, 0.52), Offset(0.31, 0.52), Offset(0.50, 0.52),
    Offset(0.69, 0.52), Offset(0.87, 0.52),
    Offset(0.12, 0.84), Offset(0.31, 0.84), Offset(0.50, 0.84),
    Offset(0.69, 0.84), Offset(0.87, 0.84),
  ];

  static const Map<String, List<String>> _shortLabels = {
    'umrah_ihram': ['إحرام العمرة', 'Umrah Ihram', 'عمرے کا احرام'],
    'umrah_tawaf': ['طواف العمرة', 'Umrah Tawaf', 'عمرے کا طواف'],
    'umrah_sai': ['سعي العمرة', 'Umrah Sai', 'عمرے کی سعی'],
    'umrah_haircut': ['تقصير العمرة', 'Umrah Trimming', 'عمرے کا قصر'],
    'hajj_ihram': ['إحرام الحج', 'Hajj Ihram', 'حج کا احرام'],
    'hajj_sai': ['سعي الحج', 'Hajj Sai', 'حج کی سعی'],
    'tashreeq': ['رمي الجمرات', 'Jamarat', 'جمرات کی رمی'],
    'muzdalifah': ['مزدلفة', 'Muzdalifah', 'مزدلفہ'],
    'haircut': ['الحلق أو التقصير', 'Shaving or Trimming', 'حلق یا قصر'],
  };

  String _stepLabel(String key) {
    final translation = _shortLabels[key];
    if (translation == null) return HajjStepPage.nameFor(key, lang);
    return translation[lang == 'en' ? 1 : (lang == 'ur' ? 2 : 0)];
  }

  void _speak(String text) {
    TtsService.speak(text, language: lang);
  }

  Uri _searchMap(String query) => Uri.https(
    'www.google.com',
    '/maps/search/',
    {'api': '1', 'query': query},
  );

  Uri _directionsMap(String destination) => Uri.https(
    'www.google.com',
    '/maps/dir/',
    {'api': '1', 'destination': destination},
  );

  Future<void> _openMap(BuildContext context, Uri link) async {
    try {
      final opened = await launchUrl(
        link,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(
            'تعذر فتح الخرائط. تأكدي من اتصال الإنترنت.',
            'Unable to open Maps. Check your internet connection.',
            'نقشہ نہیں کھل سکا۔ انٹرنیٹ چیک کریں۔',
          ))),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(
            'تعذر فتح خرائط Google.',
            'Google Maps could not be opened.',
            'گوگل میپس نہیں کھل سکا۔',
          ))),
        );
      }
    }
  }

  Widget _soundButton(String text, {double size = 20}) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: const EdgeInsets.all(4),
      tooltip: tr('استمع', 'Listen', 'سنیں'),
      onPressed: () => _speak(text),
      icon: Icon(Icons.volume_up_rounded, size: size, color: AppStyle.green),
    );
  }

  Widget _mapStepButton(BuildContext context, String step, int stepNumber, double mapWidth, double mapHeight) {
    if (stepNumber < 1 || stepNumber > _orderedPositions.length) {
      return const SizedBox.shrink();
    }
    final position = _orderedPositions[stepNumber - 1];
    final label = _stepLabel(step);

    return Positioned(
      left: mapWidth * position.dx,
      top: mapHeight * position.dy,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Material(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppStyle.gold, width: 1.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HajjStepPage(
                        stepKey: step,
                        hajjType: _selectedType,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: AppStyle.green,
                          child: Text(
                            '$stepNumber',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppStyle.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _soundButton(label, size: 17),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawnMap(BuildContext context) {
    final steps = HajjStepPage.routeFor(_selectedType);

    return LayoutBuilder(
      builder: (context, constraints) {
        const mapWidth = 1050.0;
        const mapHeight = mapWidth * 941 / 1672;
        final phone = constraints.maxWidth < 700;

        // On phones keep the original map at readable size instead of
        // shrinking its 1050px-wide buttons into a 330px screen.
        // The viewport acts as a window that can be dragged and zoomed.
        final viewportHeight = phone
            ? 370.0
            : mapHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (phone)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 9),
                child: Row(
                  children: [
                    const Icon(Icons.swipe_rounded,
                        color: AppStyle.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tr(
                          'اسحبي الخريطة يمينًا ويسارًا وأعلى وأسفل، وكبّريها بإصبعين',
                          'Drag the map in any direction; pinch to zoom',
                          'نقشہ ہر سمت کھینچیں اور دو انگلیوں سے بڑا کریں',
                        ),
                        style: const TextStyle(
                            color: AppStyle.green, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: constraints.maxWidth,
              height: viewportHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  constrained: false,
                  minScale: phone ? 0.8 : 1.0,
                  maxScale: 3.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  boundaryMargin: const EdgeInsets.all(30),
                  child: SizedBox(
                    width: mapWidth,
                    height: mapHeight,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/hajj_map_clean.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        for (var i = 0; i < steps.length; i++)
                          _mapStepButton(
                              context, steps[i], i + 1, mapWidth, mapHeight),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _mapAction(
      BuildContext context, {
        required String label,
        required IconData icon,
        required Uri url,
      }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _openMap(context, url),
              icon: Icon(icon, size: 19),
              label: Text(label, textAlign: TextAlign.center),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppStyle.green,
                side: const BorderSide(color: AppStyle.gold),
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          // مهم: هذا المكبر يقرأ اسم الزر فقط، دون اسم الميقات.
          _soundButton(label),
        ],
      ),
    );
  }

  Widget _miqatCard(BuildContext context, _Miqat miqat) {
    final name = miqat.name(lang);
    final description = miqat.detail(lang);
    final locationLabel = tr('موقع الميقات', 'Miqat Location', 'میقات کا مقام');
    final directionsLabel = tr('الاتجاهات إلى الميقات', 'Directions to Miqat', 'میقات تک راستہ');
    final shopsLabel = tr(
      'المحلات القريبة لمستلزمات الإحرام',
      'Nearby Ihram Supply Shops',
      'احرام کے سامان کی قریبی دکانیں',
    );

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppStyle.gold, width: 1.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mosque_outlined, color: AppStyle.green),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppStyle.green,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // اسم الميقات يُنطق هنا فقط.
                _soundButton(name),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(color: AppStyle.text, height: 1.6),
                  ),
                ),
                _soundButton(description),
              ],
            ),
            const Divider(color: AppStyle.gold, height: 24),
            Wrap(
              spacing: 5,
              runSpacing: 10,
              children: [
                _mapAction(
                  context,
                  label: locationLabel,
                  icon: Icons.place_outlined,
                  url: _searchMap(miqat.mapQuery),
                ),
                _mapAction(
                  context,
                  label: directionsLabel,
                  icon: Icons.directions_outlined,
                  url: _directionsMap(miqat.mapQuery),
                ),
                _mapAction(
                  context,
                  label: shopsLabel,
                  icon: Icons.storefront_outlined,
                  url: _searchMap(miqat.shopsQuery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  String _typeName(String type) {
    switch (type) {
      case 'qiran':
        return tr('القِران', 'Qiran', 'قران');
      case 'ifrad':
        return tr('الإفراد', 'Ifrad', 'افراد');
      case 'general':
        return tr('الدليل العام', 'General Guide', 'عمومی رہنمائی');
      default:
        return tr('التمتع', 'Tamattu', 'تمتع');
    }
  }

  void _openHajjType(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HajjMapPage(hajjType: type),
      ),
    );
  }

  void _openDuaBook(BuildContext context) {
    // دفتر الأدعية الأصلي يعرض جميع الأدعية عند فتحه دون stepKey.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DuaBookPage(stepKey: '')),
    );
  }

  String _typeDescription(String type) {
    switch (type) {
      case 'tamattu':
        return tr(
          'عمرة أولاً، ثم الإحرام للحج في وقته. اتبعي خطوات كل نسك بالترتيب.',
          'Perform Umrah first, then enter Ihram for Hajj. Follow each stage in order.',
          'پہلے عمرہ، پھر حج کا احرام۔ ہر مرحلے کو ترتیب سے دیکھیں۔',
        );
      case 'qiran':
        return tr(
          'الجمع بين الحج والعمرة بإحرام واحد، مع متابعة خطوات القِران.',
          'Hajj and Umrah in one Ihram, following the Qiran steps.',
          'ایک ہی احرام میں حج اور عمرہ، قران کے مراحل کے مطابق۔',
        );
      default:
        return tr(
          'الإحرام بالحج وحده، مع متابعة خطوات الإفراد.',
          'Enter Ihram for Hajj alone and follow the Ifrad steps.',
          'صرف حج کا احرام باندھیں اور افراد کے مراحل دیکھیں۔',
        );
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'tamattu':
        return Icons.alt_route_rounded;
      case 'qiran':
        return Icons.link_rounded;
      default:
        return Icons.person_outline_rounded;
    }
  }

  Widget _typeCard(BuildContext context, String type) {
    final name = _typeName(type);
    final description = _typeDescription(type);
    final numberOfSteps = HajjStepPage.routeFor(type).length;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppStyle.gold, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _openHajjType(context, type),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppStyle.cream,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppStyle.gold),
                        ),
                        child: Icon(_typeIcon(type), size: 36, color: AppStyle.green),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: AppStyle.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: const TextStyle(color: AppStyle.text, height: 1.5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              tr('$numberOfSteps خطوة مرقمة • خريطة وأدعية',
                                  '$numberOfSteps numbered steps • Map & Duas',
                                  '$numberOfSteps نمبر وار مراحل • نقشہ اور دعائیں'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppStyle.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppStyle.gold),
                    ],
                  ),
                ),
              ),
            ),
            _soundButton(name, size: 22),
          ],
        ),
      ),
    );
  }

  // دليل المواقيت والاتجاهات موجود في صفحة اختيار أنواع الحج فقط.
  // لا يظهر داخل خريطة التمتع أو القِران أو الإفراد.
  Widget _guideAndDirections(BuildContext context) {
    final heading = tr(
      'دليلك والاتجاهات',
      'Your Guide and Directions',
      'آپ کی رہنمائی اور راستے',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.explore_outlined, color: AppStyle.green, size: 26),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                heading,
                style: const TextStyle(
                  color: AppStyle.green,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _soundButton(heading),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          tr(
            'مواقع المواقيت والمتاجر القريبة لمستلزمات الإحرام',
            'Miqat locations and nearby Ihram supply shops',
            'میقات کے مقامات اور احرام کے سامان کی قریبی دکانیں',
          ),
          style: const TextStyle(color: AppStyle.text, fontSize: 15),
        ),
        const SizedBox(height: 14),
        for (final miqat in _miqats) _miqatCard(context, miqat),
        Text(
          tr(
            'تُفتح خرائط Google عند الضغط على الأزرار. نتائج المحلات تتغير بحسب بيانات الخرائط وقد لا توجد متاجر بجوار بعض المواقيت؛ تحققي من الموقع ومواعيد العمل قبل الذهاب.',
            'Buttons open live Google Maps searches. Shop listings may change, and shops may not be next to every Miqat. Check location and opening hours before visiting.',
            'بٹن گوگل میپس میں تازہ نتائج کھولتے ہیں۔ دکانیں ہر میقات کے بالکل پاس نہیں بھی ہو سکتیں۔ جانے سے پہلے مقام اور اوقات چیک کریں۔',
          ),
          style: const TextStyle(color: AppStyle.text, fontSize: 12, height: 1.7),
        ),
      ],
    );
  }

  Widget _hajjTypeHome(BuildContext context) {
    final heading = tr('اختاري نوع الحج', 'Choose a Hajj Type', 'حج کی قسم منتخب کریں');
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Icon(Icons.mosque_outlined, size: 72, color: AppStyle.gold),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        heading,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.green,
                        ),
                      ),
                    ),
                    _soundButton(heading),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tr(
                    'اضغطي على الأيقونة لعرض الخريطة والخطوات والأدعية الخاصة بالنسك.',
                    'Tap a type to open its illustrated map, ordered steps and Dua Book.',
                    'قسم منتخب کریں تاکہ اس کا نقشہ، مراحل اور دعائیں دیکھ سکیں۔',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: AppStyle.text, height: 1.6),
                ),
                const SizedBox(height: 16),
                // دفتر الأدعية أمام المستخدم في أعلى الصفحة الرئيسية للحج.
                OutlinedButton.icon(
                  onPressed: () => _openDuaBook(context),
                  icon: const Icon(Icons.menu_book_rounded, size: 27),
                  label: Text(
                    tr('دفتر الأدعية', 'Dua Book', 'دعاؤں کی کتاب'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppStyle.green,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppStyle.gold, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
                const SizedBox(height: 24),
                for (final type in const ['tamattu', 'qiran', 'ifrad'])
                  _typeCard(context, type),
                const SizedBox(height: 20),
                _guideAndDirections(context),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => _openHajjType(context, 'general'),
                  icon: const Icon(Icons.info_outline),
                  label: Text(tr('الدليل العام للتعلّم',
                      'General Educational Guide',
                      'تعلیمی عمومی رہنمائی')),
                  style: TextButton.styleFrom(foregroundColor: AppStyle.green),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chosenTypeHeader(BuildContext context) {
    final name = _typeName(_selectedType);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 5),
      child: Row(
        children: [
          const Icon(Icons.mosque_outlined, color: AppStyle.gold, size: 29),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppStyle.green,
              ),
            ),
          ),
          _soundButton(name),
        ],
      ),
    );
  }

  // أيقونة دفتر الأدعية فوق الرسم، بنفس شكل زر الأدعية في العمرة.
  Widget _duaIconAboveMap(BuildContext context) {
    final name = tr('دفتر الأدعية', 'Dua Book', 'دعاؤں کی کتاب');
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _openDuaBook(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: AppStyle.gold, width: 2),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: AppStyle.green,
                size: 31,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppStyle.green,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          _soundButton(name),
        ],
      ),
    );
  }

  Widget _duaEntry(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ElevatedButton.icon(
        onPressed: () => _openDuaBook(context),
        icon: const Icon(Icons.menu_book_outlined),
        label: Text(tr('الأدعية والأذكار', 'Duas & Remembrance', 'دعائیں اور اذکار')),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, _, __) {
        return Directionality(
          textDirection: lang == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppStyle.cream,
            appBar: AppBar(
              backgroundColor: AppStyle.green,
              foregroundColor: Colors.white,
              centerTitle: true,
              title: Text(_showTypeHome
                  ? tr('الحج', 'Hajj', 'حج')
                  : tr('خريطة مناسك الحج', 'Hajj Ritual Map', 'حج کے مناسک کا نقشہ')),
              actions: [
                if (!_showTypeHome)
                  IconButton(
                    tooltip: tr('دفتر الأدعية', 'Dua Book', 'دعاؤں کی کتاب'),
                    onPressed: () => _openDuaBook(context),
                    icon: const Icon(Icons.menu_book_outlined),
                  ),
              ],
            ),
            body: _showTypeHome
                ? _hajjTypeHome(context)
                : ListView(
              children: [
                _chosenTypeHeader(context),
                const SizedBox(height: 2),
                _duaIconAboveMap(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          tr(
                            'اضغطي على اسم الشعيرة داخل الخريطة لفتح خطواتها',
                            'Select a ritual name on the illustration to open its steps',
                            'تفصیلات کھولنے کے لیے نقشے پر مناسک کے نام کو دبائیں',
                          ),
                          style: const TextStyle(color: AppStyle.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                      _soundButton(tr(
                        'اضغطي على اسم الشعيرة داخل الخريطة لفتح خطواتها',
                        'Select a ritual name on the illustration to open its steps',
                        'تفصیلات کھولنے کے لیے نقشے پر مناسک کے نام کو دبائیں',
                      )),
                    ],
                  ),
                ),
                _drawnMap(context),
                const SizedBox(height: 10),
                const SizedBox(height: 12),
                const SizedBox(height: 18),
                // الرجوع لأنواع الحج دون تكرار دليل المواقيت هنا.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text(tr('رجوع', 'Back', 'واپس')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppStyle.green,
                      side: const BorderSide(color: AppStyle.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        );
      },
    );
  }
}
