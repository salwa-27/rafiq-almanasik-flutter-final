
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/voice_increment_button.dart';
import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../services/progress_service.dart';
import '../services/ocr_service.dart';
import '../theme/app_style.dart';
import 'dua_book_page.dart';
import 'umrah_finish_page.dart';

import 'package:url_launcher/url_launcher.dart';


class UmrahStepPage extends StatefulWidget {
  final String stepKey;

  const UmrahStepPage({
    super.key,
    required this.stepKey,
  });

  @override
  State<UmrahStepPage> createState() => _UmrahStepPageState();
}

class _UmrahStepPageState extends State<UmrahStepPage> {
  int roundCount = 0;

  static const List<String> steps = [
    'ihram',
    'tawaf',
    'sai',
    'haircut',
  ];

  static const names = {
    'ar': {
      'ihram': 'الإحرام',
      'tawaf': 'الطواف',
      'sai': 'السعي',
      'haircut': 'الحلق أو التقصير',
    },
    'en': {
      'ihram': 'Ihram',
      'tawaf': 'Tawaf',
      'sai': "Sa'i",
      'haircut': 'Shaving or Trimming',
    },
    'ur': {
      'ihram': 'احرام',
      'tawaf': 'طواف',
      'sai': 'سعی',
      'haircut': 'حلق یا قصر',
    },
  };

  static const labels = {
    'ar': {
      'must': 'ما يجب فعله',
      'avoid': 'الأخطاء الشائعة والمحظورات',
      'location': 'الموقع',
      'time': 'الوقت',
      'dua': 'دفتر الأدعية',
      'guide': 'دليلك',
      'translator': 'مترجم اللوحات',
      'counter': 'عداد الأشواط',
      'back': 'رجوع',
      'backMap': 'رجوع إلى الخريطة',
      'next': 'الخطوة التالية',
      'finish': 'إتمام العمرة',
      'close': 'إغلاق',
      'camera': 'الكاميرا',
      'gallery': 'معرض الصور',
      'photo': 'اختاري صورة لترجمة نص اللوحة',
      'result': 'النص المستخرج من الصورة',
      'error': 'تعذر قراءة النص من الصورة',
      'mic': 'اضغطي المايك وقولي «واحد» لزيادة شوط واحد',
    },
    'en': {
      'must': 'What to Do',
      'avoid': 'Common Mistakes & Prohibitions',
      'location': 'Location',
      'time': 'Time',
      'dua': 'Dua Book',
      'guide': 'Guide',
      'translator': 'Sign Translator',
      'counter': 'Round Counter',
      'back': 'Back',
      'backMap': 'Back to Map',
      'next': 'Next Step',
      'finish': 'Complete Umrah',
      'close': 'Close',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'photo': 'Select an image to read its text',
      'result': 'Text detected in image',
      'error': 'Unable to read image text',
      'mic': 'Tap the mic and say one to add a round',
    },
    'ur': {
      'must': 'کیا کرنا چاہیے',
      'avoid': 'عام غلطیاں اور ممنوعات',
      'location': 'مقام',
      'time': 'وقت',
      'dua': 'دعاؤں کی کتاب',
      'guide': 'رہنمائی',
      'translator': 'بورڈ مترجم',
      'counter': 'چکروں کی گنتی',
      'back': 'واپس',
      'backMap': 'نقشے پر واپس',
      'next': 'اگلا مرحلہ',
      'finish': 'عمرہ مکمل کریں',
      'close': 'بند کریں',
      'camera': 'کیمرہ',
      'gallery': 'تصاویر',
      'photo': 'تصویر منتخب کریں',
      'result': 'تصویر سے حاصل شدہ متن',
      'error': 'تصویر کا متن پڑھا نہیں جا سکا',
      'mic': 'مائیک دبائیں اور ایک چکر بڑھانے کے لیے ایک کہیں',
    },
  };

  static const guidance = {
    'ihram': {
      'ar': {
        'must':
        '1. الاغتسال والتنظف.\n'
            '2. ارتداء ملابس الإحرام المناسبة.\n'
            '3. عقد نية الدخول في النسك.\n'
            '4. البدء بالتلبية.',
        'avoid':
        'من محظورات الإحرام: إزالة الشعر وتقليم الأظافر '
            'والتطيب بعد الإحرام والصيد البري. '
            'وللرجال محظورات خاصة بلباس الإحرام وتغطية الرأس، '
            'وللنساء النهي عن النقاب والقفازين أثناء الإحرام.',
        'location': 'الميقات المحدد بحسب جهة القدوم.',
        'time': 'قبل تجاوز الميقات.',
      },
      'en': {
        'must':
        '1. Perform ghusl and prepare for Ihram.\n'
            '2. Wear appropriate Ihram clothing.\n'
            '3. Make the intention.\n'
            '4. Begin the Talbiyah.',
        'avoid':
        'Avoid cutting hair or nails, applying perfume '
            'after entering Ihram, and hunting land game. '
            'Additional restrictions apply to men and women.',
        'location': 'The designated Miqat.',
        'time': 'Before crossing the Miqat.',
      },
      'ur': {
        'must':
        '1. غسل اور صفائی۔\n'
            '2. احرام کے مناسب کپڑے۔\n'
            '3. نیت کرنا۔\n'
            '4. تلبیہ پڑھنا۔',
        'avoid':
        'احرام میں بال یا ناخن کاٹنے، خوشبو لگانے '
            'اور خشکی کے شکار سے پرہیز کریں۔ '
            'لباس کے متعلق مخصوص احکام بھی ہیں۔',
        'location': 'مقررہ میقات پر۔',
        'time': 'میقات سے گزرنے سے پہلے۔',
      },
    },
    'tawaf': {
      'ar': {
        'must':
        '1. الطواف سبعة أشواط حول الكعبة، تبدأ وتنتهي '
            'عند محاذاة الحجر الأسود.\n'
            '2. مراعاة الطهارة أثناء الطواف.\n'
            '3. صلاة ركعتين بعد الطواف في مكان مناسب إن تيسر.',
        'avoid':
        'تجنب التدافع عند الحجر الأسود، والطواف من داخل '
            'حِجر إسماعيل، وإيذاء الآخرين بسبب الزحام.',
        'location': 'المطاف حول الكعبة في المسجد الحرام.',
        'time': 'بعد الوصول إلى المسجد الحرام.',
      },
      'en': {
        'must':
        '1. Perform seven circuits around the Kaaba, '
            'starting and ending at the Black Stone.\n'
            '2. Maintain purity.\n'
            '3. Pray two rakahs after Tawaf when possible.',
        'avoid':
        'Avoid pushing at the Black Stone, passing '
            'through Hijr Ismail during a circuit, '
            'and harming others in crowded areas.',
        'location': 'Around the Kaaba in Masjid al-Haram.',
        'time': 'Upon reaching Masjid al-Haram.',
      },
      'ur': {
        'must':
        '1. کعبہ کے گرد حجر اسود سے شروع اور ختم '
            'ہونے والے سات چکر۔\n'
            '2. طہارت کا خیال رکھیں۔\n'
            '3. طواف کے بعد دو رکعت نماز پڑھیں۔',
        'avoid':
        'حجر اسود پر دھکم پیل سے بچیں، '
            'حطیم کے اندر سے طواف نہ کریں '
            'اور دوسروں کو تکلیف نہ دیں۔',
        'location': 'مسجد الحرام میں کعبہ کے گرد۔',
        'time': 'مسجد الحرام پہنچنے کے بعد۔',
      },
    },
    'sai': {
      'ar': {
        'must':
        '1. السعي سبعة أشواط، يبدأ من الصفا وينتهي بالمروة.\n'
            '2. الإكثار من الذكر والدعاء.\n'
            '3. يُسن للرجال الإسراع بين العلمين الأخضرين عند القدرة.',
        'avoid':
        'تجنب البدء من المروة، أو اعتبار الذهاب والعودة '
            'شوطًا واحدًا، أو الهرولة طوال المسعى.',
        'location': 'المسعى بين الصفا والمروة.',
        'time': 'بعد الطواف.',
      },
      'en': {
        'must':
        '1. Perform seven lengths beginning at Safa '
            'and ending at Marwah.\n'
            '2. Remember Allah and make supplications.\n'
            '3. Men may move faster between the green markers.',
        'avoid':
        'Do not begin at Marwah, count a return trip '
            'as one length, or run throughout the entire route.',
        'location': 'Between Safa and Marwah.',
        'time': 'After Tawaf.',
      },
      'ur': {
        'must':
        '1. صفا سے شروع اور مروہ پر ختم ہونے والے سات چکر۔\n'
            '2. دعا اور ذکر کریں۔\n'
            '3. مرد سبز نشانات کے درمیان تیز چلیں۔',
        'avoid':
        'مروہ سے شروع نہ کریں، آنے جانے کو ایک چکر '
            'نہ سمجھیں، اور پورے راستے میں نہ دوڑیں۔',
        'location': 'صفا اور مروہ کے درمیان مسعی۔',
        'time': 'طواف کے بعد۔',
      },
    },
    'haircut': {
      'ar': {
        'must':
        '1. يحلق الرجال شعر الرأس أو يقصرونه.\n'
            '2. تقصر المرأة من أطراف شعرها القدر المشروع.\n'
            '3. يكتمل النسك ويتحلل المعتمر بعد ذلك.',
        'avoid':
        'تجنب اعتبار العمرة مكتملة قبل أداء الحلق أو التقصير.',
        'location': 'مكان مناسب بعد السعي.',
        'time': 'بعد إتمام السعي.',
      },
      'en': {
        'must':
        '1. Men shave or trim the hair on their heads.\n'
            '2. Women trim the prescribed amount '
            'from the ends of their hair.\n'
            '3. Umrah is completed afterward.',
        'avoid':
        'Do not treat Umrah as complete '
            'before shaving or trimming.',
        'location': 'A suitable place after Sa’i.',
        'time': 'After completing Sa’i.',
      },
      'ur': {
        'must':
        '1. مرد سر کے بال منڈوائیں یا چھوٹے کریں۔\n'
            '2. عورتیں بالوں کے کناروں سے مقررہ مقدار کاٹیں۔\n'
            '3. اس کے بعد عمرہ مکمل ہوتا ہے۔',
        'avoid':
        'حلق یا قصر سے پہلے عمرہ مکمل نہ سمجھیں۔',
        'location': 'سعی کے بعد مناسب جگہ۔',
        'time': 'سعی مکمل ہونے کے بعد۔',
      },
    },
  };

  String get lang {
    final value = AppLanguage.currentLanguage;
    return labels.containsKey(value) ? value : 'ar';
  }

  String tr(String key) => labels[lang]?[key] ?? key;

  String get title =>
      names[lang]?[widget.stepKey] ??
          names[lang]!['ihram']!;

  String info(String key) =>
      guidance[widget.stepKey]?[lang]?[key] ?? '';

  bool get hasCounter =>
      widget.stepKey == 'tawaf' ||
          widget.stepKey == 'sai';

  String get counterKey =>
      'umrah_${widget.stepKey}_counter';

  int get stepIndex => steps.indexOf(widget.stepKey);

  bool get hasNext =>
      stepIndex >= 0 && stepIndex < steps.length - 1;

  bool get hasPrevious => stepIndex > 0;

  @override
  void initState() {
    super.initState();
    ProgressService.saveLastPage(
      'umrah_${widget.stepKey}',
    );
    loadCounter();
  }

  Future<void> loadCounter() async {
    if (!hasCounter) return;

    final value = await ProgressService.getCounter(counterKey);

    if (!mounted) return;

    setState(() {
      roundCount = value.clamp(0, 7).toInt();
    });
  }

  Future<void> setCounter(int value) async {
    final count = value.clamp(0, 7).toInt();

    setState(() {
      roundCount = count;
    });

    await ProgressService.saveCounter(
      counterKey,
      count,
    );
  }

  void goToStep(String key) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => UmrahStepPage(stepKey: key),
      ),
    );
  }

  void goNext() {
    if (!hasNext) return;
    goToStep(steps[stepIndex + 1]);
  }

  void goBack() {
    if (hasPrevious) {
      goToStep(steps[stepIndex - 1]);
    } else {
      Navigator.pop(context);
    }
  }

  void finishUmrah() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UmrahFinishPage(),
      ),
    );
  }

  Widget audio(String text, {double size = 40}) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: lang == 'en'
            ? 'Listen'
            : lang == 'ur'
            ? 'سنیں'
            : 'استمع',
        icon: const Icon(
          Icons.volume_up_rounded,
          color: AppStyle.green,
        ),
        onPressed: () => TtsService.speak(
          text,
          language: lang,
        ),
      ),
    );
  }

  Widget heading(String text, {double size = 28}) {
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
            ),
          ),
        ),
        audio(text),
      ],
    );
  }

  Widget infoCard(
      String label,
      String content,
      IconData icon,
      ) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(
          color: AppStyle.gold,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: AppStyle.green),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppStyle.green,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                audio(label),
              ],
            ),
            const Divider(color: AppStyle.gold),
            Row(
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: AppStyle.text,
                    ),
                  ),
                ),
                audio(content),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tool(
      IconData icon,
      String title,
      VoidCallback action,
      ) {
    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: action,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: AppStyle.gold,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: AppStyle.green,
                size: 31,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppStyle.green,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          audio(title, size: 34),
        ],
      ),
    );
  }

  Widget counter() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(
          color: AppStyle.gold,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            heading(tr('counter'), size: 22),
            const SizedBox(height: 15),
            Text(
              '$roundCount / 7',
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppStyle.green,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: roundCount == 0
                      ? null
                      : () => setCounter(roundCount - 1),
                  style: IconButton.styleFrom(
                    backgroundColor: AppStyle.green,
                  ),
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 25),
                VoiceIncrementButton(
                  language: lang,
                  value: roundCount,
                  maximum: 7,
                  onIncrement: () =>
                      setCounter(roundCount + 1),
                ),
                const SizedBox(width: 25),
                IconButton.filled(
                  onPressed: roundCount == 7
                      ? null
                      : () => setCounter(roundCount + 1),
                  style: IconButton.styleFrom(
                    backgroundColor: AppStyle.green,
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              tr('mic'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppStyle.text,
              ),
            ),
            audio(tr('mic')),
          ],
        ),
      ),
    );
  }

  Widget stepProgress() {
    final currentStep = stepIndex < 0 ? 1 : stepIndex + 1;
    final totalSteps = steps.length;
    final stageLabel = lang == 'en'
        ? 'Stage $currentStep of $totalSteps'
        : lang == 'ur'
        ? 'مرحلہ $currentStep از $totalSteps'
        : 'المرحلة $currentStep من $totalSteps';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
          child: Text(
            stageLabel,
            style: const TextStyle(
              fontSize: 13,
              color: AppStyle.green,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            minHeight: 6,
            backgroundColor: const Color(0xFFE6E6E6),
            valueColor: const AlwaysStoppedAnimation<Color>(AppStyle.green),
          ),
        ),
      ],
    );
  }

  Widget navigationButtons() {
    return Column(
      children: [
        if (hasNext)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: goNext,
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                ),
                label: Text(tr('next')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
              audio(tr('next')),
            ],
          ),
        if (widget.stepKey == 'haircut')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: finishUmrah,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 15,
                  ),
                ),
                child: Text(tr('finish')),
              ),
              audio(tr('finish')),
            ],
          ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: goBack,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppStyle.green,
              ),
              label: Text(
                hasPrevious ? tr('back') : tr('backMap'),
                style: const TextStyle(
                  color: AppStyle.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            audio(
              hasPrevious ? tr('back') : tr('backMap'),
            ),
          ],
        ),
      ],
    );
  }

  void openDua() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DuaBookPage(
          stepKey: widget.stepKey,
        ),
      ),
    );
  }

  void openGuide() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF6EFDF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) => Directionality(
        textDirection: lang == 'en'
            ? ui.TextDirection.ltr
            : ui.TextDirection.rtl,
        child: SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18, 6, 18, 24,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  heading(tr('guide'), size: 24),
                  const SizedBox(height: 10),
                  heading(title, size: 21),
                  const SizedBox(height: 18),
                  infoCard(
                    tr('must'),
                    info('must'),
                    Icons.check_circle_outline,
                  ),
                  infoCard(
                    tr('location'),
                    info('location'),
                    Icons.location_on_outlined,
                  ),
                  infoCard(
                    tr('time'),
                    info('time'),
                    Icons.schedule_outlined,
                  ),
                  infoCard(
                    tr('avoid'),
                    info('avoid'),
                    Icons.info_outline,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      openDua();
                    },
                    icon: const Icon(
                      Icons.menu_book_rounded,
                    ),
                    label: Text(tr('dua')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppStyle.green,
                      side: const BorderSide(
                        color: AppStyle.gold,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(sheetContext),
                    child: Text(tr('close')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> readImage(ImageSource source) async {
    final photo = await ImagePicker().pickImage(
      source: source,
    );

    if (photo == null) return;

    try {
      final extracted = await OcrService.extractText(
        photo.path,
      );

      if (!mounted) return;

      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr('result')),
          content: SingleChildScrollView(
            child: SelectableText(
              extracted.toString(),
              style: const TextStyle(height: 1.6),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(tr('close')),
            ),
            audio(extracted.toString()),
          ],
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('error')),
        ),
      );
    }
  }


  Future<void> openTranslator() async {
    final url = Uri.parse(
      'https://translate.google.com/',
    );

    try {
      final opened = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر فتح ترجمة Google'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح ترجمة Google'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, current, _) {
        final selected = labels.containsKey(current)
            ? current
            : 'ar';

        return Directionality(
          textDirection: selected == 'en'
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
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
                    color: Colors.white.withValues(
                      alpha: .88,
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 950,
                        ),
                        child: Column(
                          children: [
                            heading(title, size: 30),
                            const SizedBox(height: 14),
                            stepProgress(),
                            const SizedBox(height: 22),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                tool(
                                  Icons.menu_book_rounded,
                                  tr('dua'),
                                  openDua,
                                ),
                                tool(
                                  Icons.explore_outlined,
                                  tr('guide'),
                                  openGuide,
                                ),
                                tool(
                                  Icons.camera_alt_outlined,
                                  tr('translator'),
                                  openTranslator,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            infoCard(
                              tr('must'),
                              info('must'),
                              Icons.check_circle_outline,
                            ),
                            infoCard(
                              tr('avoid'),
                              info('avoid'),
                              Icons.report_outlined,
                            ),
                            infoCard(
                              tr('location'),
                              info('location'),
                              Icons.location_on_outlined,
                            ),
                            infoCard(
                              tr('time'),
                              info('time'),
                              Icons.schedule,
                            ),

                            // عداد الأشواط يظهر أولًا
                            if (hasCounter) counter(),

                            // أزرار التنقل تحت العداد
                            const SizedBox(height: 18),
                            navigationButtons(),

                            const SizedBox(height: 18),
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
