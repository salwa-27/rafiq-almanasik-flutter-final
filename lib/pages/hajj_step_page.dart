
import 'package:flutter/material.dart';
import '../widgets/voice_increment_button.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../services/progress_service.dart';
import '../theme/app_style.dart';

import 'hajj_rulings_section.dart';
import 'jamarat_counter.dart';
import 'dua_book_page.dart';
import 'hajj_finish_page.dart';

/// The eight pieces of information shown for each Hajj step.
/// Every field is translated separately into Arabic, English and Urdu.
class _HajjStage {
  final String actions;
  final String mistakes;
  final String sunnah;
  final String location;
  final String time;
  final String dua;
  final String notes;
  final String meaning;

  const _HajjStage(
      this.actions,
      this.mistakes,
      this.sunnah,
      this.location,
      this.time,
      this.dua,
      this.notes,
      this.meaning,
      );
}

class HajjStepPage extends StatefulWidget {
  final String stepKey;
  final String hajjType;

  const HajjStepPage({
    super.key,
    required this.stepKey,
    this.hajjType = 'tamattu',
  });

  static List<String> routeFor(String type) {
    switch (type) {
      case 'general':
        return [
          'ihram',
          'mina',
          'arafah',
          'muzdalifah',
          'aqabah',
          'haircut',
          'ifadah',
          'tashreeq',
          'farewell',
        ];

      case 'ifrad':
        return [
          'ihram',
          'arrival',
          'sai',
          'mina',
          'arafah',
          'muzdalifah',
          'aqabah',
          'haircut',
          'ifadah',
          'tashreeq',
          'farewell',
        ];

      case 'qiran':
        return [
          'ihram',
          'arrival',
          'sai',
          'mina',
          'arafah',
          'muzdalifah',
          'aqabah',
          'hady',
          'haircut',
          'ifadah',
          'tashreeq',
          'farewell',
        ];

      default:
        return [
          'umrah_ihram',
          'umrah_tawaf',
          'umrah_sai',
          'umrah_haircut',
          'hajj_ihram',
          'mina',
          'arafah',
          'muzdalifah',
          'aqabah',
          'hady',
          'haircut',
          'ifadah',
          'hajj_sai',
          'tashreeq',
          'farewell',
        ];
    }
  }

  static const names = <String, Map<String, String>>{
    'ar': {
      'umrah_ihram': 'الإحرام لعمرة التمتع',
      'umrah_tawaf': 'طواف العمرة',
      'umrah_sai': 'سعي العمرة',
      'umrah_haircut': 'الحلق أو التقصير والتحلل من العمرة',
      'hajj_ihram': 'الإحرام للحج من مكة',
      'ihram': 'الإحرام من الميقات',
      'arrival': 'طواف القدوم',
      'sai': 'سعي الحج',
      'mina': 'يوم التروية في منى',
      'arafah': 'الوقوف بعرفة',
      'muzdalifah': 'المبيت بمزدلفة',
      'aqabah': 'رمي جمرة العقبة',
      'hady': 'ذبح الهدي',
      'haircut': 'الحلق أو التقصير',
      'ifadah': 'طواف الإفاضة',
      'hajj_sai': 'سعي الحج للمتمتع',
      'tashreeq': 'أيام التشريق ورمي الجمرات',
      'farewell': 'طواف الوداع',
    },

    'en': {
      'umrah_ihram': 'Ihram for Tamattu Umrah',
      'umrah_tawaf': 'Tawaf for Umrah',
      'umrah_sai': 'Sa’i for Umrah',
      'umrah_haircut': 'Shaving or Trimming after Umrah',
      'hajj_ihram': 'Ihram for Hajj from Makkah',
      'ihram': 'Ihram at the Miqat',
      'arrival': 'Tawaf al-Qudum (Arrival Tawaf)',
      'sai': 'Sa’i for Hajj',
      'mina': 'Day of Tarwiyah in Mina',
      'arafah': 'Standing at Arafah',
      'muzdalifah': 'Staying at Muzdalifah',
      'aqabah': 'Stoning Jamrat al-Aqabah',
      'hady': 'Hady (Sacrifice)',
      'haircut': 'Shaving or Trimming',
      'ifadah': 'Tawaf al-Ifadah',
      'hajj_sai': 'Sa’i for Tamattu Hajj',
      'tashreeq': 'Days of Tashreeq and Stoning the Jamarat',
      'farewell': 'Farewell Tawaf',
    },

    'ur': {
      'umrah_ihram': 'تمتع کے عمرے کا احرام',
      'umrah_tawaf': 'عمرے کا طواف',
      'umrah_sai': 'عمرے کی سعی',
      'umrah_haircut': 'حلق یا قصر اور عمرے کا تحلل',
      'hajj_ihram': 'مکہ سے حج کا احرام',
      'ihram': 'میقات سے احرام',
      'arrival': 'طواف قدوم',
      'sai': 'حج کی سعی',
      'mina': 'منیٰ میں یوم الترویہ',
      'arafah': 'وقوف عرفہ',
      'muzdalifah': 'مزدلفہ میں قیام',
      'aqabah': 'جمرہ عقبہ کی رمی',
      'hady': 'ہدی کی قربانی',
      'haircut': 'حلق یا قصر',
      'ifadah': 'طواف افاضہ',
      'hajj_sai': 'تمتع کے حج کی سعی',
      'tashreeq': 'ایام تشریق اور جمرات کی رمی',
      'farewell': 'طواف وداع',
    },
  };

  static String nameFor(String key, String language) =>
      names[language]?[key] ?? names['ar']?[key] ?? key;

  @override
  State<HajjStepPage> createState() => _HajjStepPageState();
}

class _HajjStepPageState extends State<HajjStepPage> {
int counter = 0;
bool completed = false;
int departureChoice = 0;

String get lang {
final current = AppLanguage.currentLanguage;
return const ['ar', 'en', 'ur'].contains(current)
? current
: 'ar';
}

bool get isGeneral => widget.hajjType == 'general';

List<String> get route =>
HajjStepPage.routeFor(widget.hajjType);

int get position => route.indexOf(widget.stepKey);

String get title =>
HajjStepPage.nameFor(widget.stepKey, lang);

String get counterKey =>
'hajj_${widget.hajjType}_${widget.stepKey}_counter';

String get doneKey =>
'hajj_${widget.hajjType}_${widget.stepKey}_done';

String get departureKey =>
'hajj_${widget.hajjType}_departure_choice';

bool get hasCounter => const [
'umrah_tawaf',
'umrah_sai',
'arrival',
'sai',
'aqabah',
'ifadah',
'hajj_sai',
'farewell',
].contains(widget.stepKey);

String tx(String ar, String en, String ur) =>
lang == 'en' ? en : (lang == 'ur' ? ur : ar);


static const ui = <String, Map<String, String>>{
'ar': {
'step': 'المرحلة',
'of': 'من',
'meaning': 'التعريف بالشعيرة ومعناها الإيماني',
'actions': 'الأعمال المطلوبة',
'mistakes': 'أخطاء يجب تجنبها',
'sunnah': 'السنن والأعمال المستحبة',
'place': 'الموقع',
'time': 'الوقت',
'dua': 'الأذكار والأدعية',
'notes': 'أحكام وتنبيهات مهمة',
'ihramRules': 'محظورات الإحرام',
'forbidden': 'المحرمات العامة أثناء الحج',
'safety': 'إرشادات السلامة',
'counter': 'عداد الأشواط أو الحصيات',
'reset': 'تصفير العداد',
'book': 'فتح دفتر الأدعية',
'done': 'أنجزت هذه الخطوة',
'next': 'الخطوة التالية',
'finish': 'إتمام الحج',
'finishGuide': 'إنهاء الدليل العام',
'back': 'رجوع',
'generalWarning':
'دليل الحج العام للتعلم وليس نوعًا رابعًا من الحج. تختلف بعض الأحكام باختلاف النسك.',
'forbiddenText':
'يحرم إيذاء الآخرين والظلم والسب والفسوق؛ وتجنبي التدافع والمشاجرات.',
'safetyText':
'اتبعي تعليمات الجهات المنظمة، وتجنبي التدافع والإجهاد الحراري، واحرصي على الماء والراحة.',
'ihramText':
'من محظورات الإحرام استعمال الطيب بعد الإحرام، وإزالة الشعر أو تقليم الأظافر دون عذر، وعقد النكاح والصيد البري. وتوجد أحكام خاصة بلباس الرجال والنساء.',
'releaseText':
'بعد التحلل الأول تزول معظم محظورات الإحرام، وتبقى أحكام العلاقة الزوجية حتى التحلل الثاني. لا يتحدد التحلل بمجرد الوصول إلى هذه الخطوة.',
'releaseTitle': 'التحلل الأول والتحلل الثاني',
'firstRelease': 'التحلل الأول',
'secondRelease': 'التحلل الثاني',
'releaseImportant': 'تنبيه مهم عن التحلل',
'specialTitle': 'رخص وأحكام الحالات الخاصة',
'women': 'أحكام المرأة',
'accessibility': 'كبار السن والمرضى وذوو الإعاقة',
'hadyTitle': 'الهدي والبديل الشرعي',
'typeTitle': 'ما يختلف حسب نوع الحج',
'departureTitle': 'التعجّل أو التأخّر من منى',
'departureIntro':
'بعد أعمال اليوم الثاني عشر، سجّلي اختيار التعجّل أو التأخّر.',
'early': 'التعجّل في اليوم الثاني عشر',
'late': 'التأخّر إلى اليوم الثالث عشر',
'earlyRules':
'الأصل أن يكون التعجّل بعد رمي الجمرات الثلاث يوم الثاني عشر والخروج من منى قبل الغروب، مع مراعاة الاستثناءات والأعذار.',
'lateRules':
'من تأخّر يبيت ليلة الثالث عشر بمنى ويرمي الجمرات الثلاث في الوقت المشروع يوم الثالث عشر.',
'earlySaved': 'تم حفظ اختيار التعجّل.',
'lateSaved': 'تم حفظ اختيار التأخّر.',
'notSelected': 'اختاري التعجّل أو التأخّر أولًا.',
'notReady':
'العدادات غير مكتملة في التطبيق. راجعي ما أديته بالفعل؛ فالعداد ليس حكمًا على صحة النسك.',
'confirm': 'تأكيد',
'cancel': 'إلغاء',
'confirmEarly':
'هل تريدين تسجيل التعجّل؟ تأكدي من استيفاء شروطه الفعلية.',
'confirmLate':
'هل تريدين تسجيل التأخّر إلى اليوم الثالث عشر؟',
'choiceNote':
'التسجيل والعداد للتذكّر فقط، ولا يثبتان صحة التعجّل أو النسك.',
'listen': 'استمع',
},

'en': {
'step': 'Step',
'of': 'of',
'meaning': 'Meaning and Spiritual Reflection',
'actions': 'What to Do',
'mistakes': 'Mistakes to Avoid',
'sunnah': 'Sunnah and Recommended Acts',
'place': 'Location',
'time': 'Time',
'dua': 'Supplications and Remembrance',
'notes': 'Important Rulings and Notes',
'ihramRules': 'Ihram Prohibitions',
'forbidden': 'General Prohibitions During Hajj',
'safety': 'Safety Guidance',
'counter': 'Circuits or Pebbles Counter',
'reset': 'Reset Counter',
'book': 'Open Supplications Book',
'done': 'I Completed This Step',
'next': 'Next Step',
'finish': 'Finish Hajj',
'finishGuide': 'Finish General Guide',
'back': 'Back',
'generalWarning':
'The general Hajj guide is educational, not a fourth type of Hajj. Some rulings depend on your Hajj type.',
'forbiddenText':
'Harming others, oppression, insults and misconduct are forbidden. Avoid arguments and dangerous crowding.',
'safetyText':
'Follow official crowd-management instructions. Avoid pushing, heat exhaustion and dehydration; rest when needed.',
'ihramText':
'Ihram restrictions include perfume after entering Ihram, removing hair or cutting nails without a valid excuse, contracting marriage, and land hunting. Clothing rules differ for men and women.',
'releaseText':
'Most Ihram restrictions end after the first release, while marital restrictions continue until the second release. Opening a page does not determine release.',
'releaseTitle': 'First and Second Release from Ihram',
'firstRelease': 'First Release',
'secondRelease': 'Second Release',
'releaseImportant': 'Important Note about Release',
'specialTitle': 'Concessions and Special Circumstances',
'women': 'Rulings for Women',
'accessibility':
'Elderly Pilgrims, Pilgrims with Illnesses, and Pilgrims with Disabilities',
'hadyTitle': 'Hady (Sacrifice) and Its Prescribed Alternative',
'typeTitle': 'Differences by Hajj Type',
'departureTitle': 'Early or Later Departure from Mina',
'departureIntro':
'After completing the rites of Day 12, record whether you will depart early or remain until Day 13.',
'early': 'Early Departure on Day 12',
'late': 'Remain Until Day 13',
'earlyRules':
'Early departure generally requires stoning all three Jamarat on Day 12 and leaving Mina before sunset, with applicable exceptions and concessions.',
'lateRules':
'Those who remain spend the night before Day 13 in Mina and stone all three Jamarat at the prescribed time on Day 13.',
'earlySaved': 'Early departure selection saved.',
'lateSaved': 'Later departure selection saved.',
'notSelected': 'Select early or later departure first.',
'notReady':
'The app counters are incomplete. Check what you actually performed; a counter cannot determine religious validity.',
'confirm': 'Confirm',
'cancel': 'Cancel',
'confirmEarly':
'Record early departure? Check that you actually fulfilled its religious conditions.',
'confirmLate': 'Record staying until Day 13?',
'choiceNote':
'Selections and counters are personal records, not certification of religious validity.',
'listen': 'Listen',
},

'ur': {
'step': 'مرحلہ',
'of': 'از',
'meaning': 'عبادت کا تعارف اور روحانی معنی',
'actions': 'کیا کرنا ہے',
'mistakes': 'ان غلطیوں سے بچیں',
'sunnah': 'سنن اور مستحب اعمال',
'place': 'مقام',
'time': 'وقت',
'dua': 'دعائیں اور اذکار',
'notes': 'اہم احکام اور ہدایات',
'ihramRules': 'احرام کی پابندیاں',
'forbidden': 'حج کے دوران عمومی ممنوعات',
'safety': 'حفاظتی ہدایات',
'counter': 'چکروں یا کنکریوں کی گنتی',
'reset': 'گنتی صفر کریں',
'book': 'دعاؤں کی کتاب کھولیں',
'done': 'میں نے یہ مرحلہ مکمل کر لیا',
'next': 'اگلا مرحلہ',
'finish': 'حج مکمل کریں',
'finishGuide': 'عمومی رہنمائی ختم کریں',
'back': 'واپس',
'generalWarning':
'حج کی عمومی رہنمائی تعلیمی ہے، حج کی چوتھی قسم نہیں۔ بعض احکام نسک کی قسم کے مطابق مختلف ہوتے ہیں۔',
'forbiddenText':
'لوگوں کو تکلیف دینا، ظلم، گالی گلوچ اور بدسلوکی منع ہیں۔ جھگڑوں اور دھکم پیل سے بچیں۔',
'safetyText':
'سرکاری انتظامی ہدایات پر عمل کریں۔ دھکم پیل، شدید گرمی اور پانی کی کمی سے بچیں اور آرام کریں۔',
'ihramText':
'احرام کے بعد خوشبو لگانا، بلاعذر بال یا ناخن کاٹنا، نکاح کا عقد اور خشکی کا شکار کرنا ممنوع ہے۔ مردوں اور عورتوں کے لباس کے احکام مختلف ہیں۔',
'releaseText':
'پہلے تحلل کے بعد احرام کی زیادہ تر پابندیاں ختم ہو جاتی ہیں، مگر مکمل تحلل تک ازدواجی پابندیاں باقی رہتی ہیں۔ صرف صفحہ کھولنے سے تحلل نہیں ہوتا۔',
'releaseTitle': 'پہلا اور دوسرا تحلل',
'firstRelease': 'پہلا تحلل',
'secondRelease': 'دوسرا تحلل',
'releaseImportant': 'تحلل کے بارے میں اہم وضاحت',
'specialTitle': 'خاص حالات میں رخصتیں اور احکام',
'women': 'خواتین کے احکام',
'accessibility': 'بزرگ، بیمار اور معذور حاجی',
'hadyTitle': 'ہدی اور شرعی متبادل',
'typeTitle': 'حج کی قسم کے مطابق فرق',
'departureTitle': 'منیٰ سے تعجل یا تاخیر',
'departureIntro':
'بارہ ذوالحجہ کے بعد تعجل یا تیرہ تاریخ تک قیام درج کریں۔',
'early': 'بارہ ذوالحجہ کو تعجل',
'late': 'تیرہ ذوالحجہ تک قیام',
'earlyRules':
'تعجل میں عموماً بارہ تاریخ کو تینوں جمرات کی رمی کے بعد غروب سے پہلے منیٰ سے نکلنا ضروری ہے؛ عذر کی رعایتیں موجود ہیں۔',
'lateRules':
'رکنے والا منیٰ میں تیرہ تاریخ کی رات گزارتا ہے اور تیرہ ذوالحجہ کو مقررہ وقت پر تینوں جمرات کی رمی کرتا ہے۔',
'earlySaved': 'تعجل کا انتخاب محفوظ ہو گیا۔',
'lateSaved': 'تاخیر کا انتخاب محفوظ ہو گیا۔',
'notSelected': 'پہلے تعجل یا تاخیر منتخب کریں۔',
'notReady':
'ایپ میں گنتی نامکمل ہے۔ اپنے حقیقی عمل کی تصدیق کریں؛ گنتی شرعی فیصلہ نہیں ہے۔',
'confirm': 'تصدیق',
'cancel': 'منسوخ',
'confirmEarly':
'تعجل درج کرنا ہے؟ یقین کر لیں کہ اس کی حقیقی شرائط پوری ہو چکی ہیں۔',
'confirmLate': 'تیرہ تاریخ تک قیام درج کرنا ہے؟',
'choiceNote':
'انتخاب اور گنتی صرف یادداشت کے لیے ہیں، شرعی صحت کی تصدیق نہیں۔',
'listen': 'سنیں',
},
};

String t(String key) =>
ui[lang]?[key] ?? ui['ar']?[key] ?? key;


// Full, independent, eight-field translations for every step.
// Position in each _HajjStage: actions, mistakes, sunnah,
// location, time, dua, notes, meaning.
static const stages = <String, Map<String, _HajjStage>>{
'ar': {
'umrah_ihram': _HajjStage(
'الإحرام للعمرة من الميقات بعقد النية والتلبية.',
'تجاوز الميقات دون إحرام عند وجوبه.',
'الاغتسال والتنظف قبل الإحرام والتلبية.',
'الميقات المناسب لطريق القدوم.',
'في أشهر الحج قبل دخول مكة لأداء العمرة.',
'لبيك اللهم عمرة.',
'تبدأ محظورات الإحرام عند الدخول في النسك.',
'الإخلاص لله وبداية العمرة.',
),
'umrah_tawaf': _HajjStage(
'الطواف سبعة أشواط حول الكعبة، من الحجر الأسود إلى الحجر الأسود.',
'المرور من داخل حِجر إسماعيل أو إيذاء الآخرين.',
'الذكر والدعاء دون تخصيص دعاء واجب لكل شوط.',
'المسجد الحرام في مكة.',
'بعد الوصول إلى مكة.',
'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار.',
'يُراعى إتمام سبعة أشواط وشروط الطواف.',
'تعظيم البيت الحرام.',
),
'umrah_sai': _HajjStage(
'السعي سبعة أشواط من الصفا إلى المروة، وينتهي عند المروة.',
'البدء بالمروة أو عدّ الذهاب والعودة شوطًا واحدًا.',
'الذكر والدعاء أثناء السعي.',
'المسعى بين الصفا والمروة.',
'بعد طواف العمرة.',
'إن الصفا والمروة من شعائر الله.',
'المسافة من الصفا إلى المروة شوط واحد.',
'تذكّر صبر هاجر عليها السلام والتوكل على الله.',
),
'umrah_haircut': _HajjStage(
'يحلق الرجل أو يقصر شعره، والمرأة تقصر من أطراف شعرها، ثم تنتهي العمرة.',
'التحلل قبل تمام المناسك.',
'الحلق أفضل للرجال في الجملة، مع مراعاة التمتع وقرب الحج.',
'مكة المكرمة.',
'بعد سعي العمرة.',
'الحمد لله.',
'يتحلل المتمتع من العمرة ثم يحرم للحج في وقته.',
'الامتثال والشكر لله.',
),
'hajj_ihram': _HajjStage(
'ينوي المتمتع الحج ويحرم به من مكة أو محل إقامته فيها.',
'اعتقاد وجوب الرجوع للميقات البعيد لإحرام الحج.',
'الاغتسال والتلبية.',
'مكة المكرمة أو مكان الإقامة فيها.',
'يوم التروية، الثامن من ذي الحجة.',
'لبيك اللهم حجًا.',
'تبدأ محظورات إحرام الحج من جديد.',
'بدء مناسك الحج.',
),
'ihram': _HajjStage(
'الإحرام بالحج من الميقات حسب النسك وجهة القدوم.',
'تجاوز الميقات دون إحرام لمن يلزمه.',
'الاغتسال والتلبية.',
'الميقات الموافق لطريق القدوم.',
'عند المرور بالميقات قبل تجاوزه.',
'لبيك اللهم حجًا، أو لبيك عمرة وحجًا بحسب النسك.',
'الإفراد للحج وحده، والقِران للحج والعمرة معًا.',
'الإخلاص والطاعة.',
),
'arrival': _HajjStage(
'طواف القدوم سبعة أشواط لمن شُرع له.',
'إيذاء الآخرين أو الطواف من داخل حِجر إسماعيل.',
'الذكر والدعاء أثناء الطواف.',
'المسجد الحرام.',
'عند القدوم إلى مكة.',
'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار.',
'طواف القدوم لا يغني عن طواف الإفاضة.',
'تعظيم الكعبة المشرفة.',
),
'sai': _HajjStage(
'سعي الحج سبعة أشواط، ويمكن للمفرد والقارن تقديمه بعد طواف القدوم أو تأخيره إلى ما بعد الإفاضة.',
'تكرار السعي الصحيح ظنًا أنه مطلوب مرتين، أو نسيان السعي إذا أُخّر.',
'الذكر والدعاء عند الصفا والمروة.',
'المسعى بين الصفا والمروة.',
'بعد طواف مناسب، قبل يوم النحر أو بعده وفق النسك.',
'إن الصفا والمروة من شعائر الله.',
'إذا أُخّر سعي الحج فلا يُعد منجزًا حتى يؤدى.',
'التوكل والصبر.',
),
'mina': _HajjStage(
'التوجه إلى منى يوم التروية وفق الأحكام والإرشادات التنظيمية.',
'التدافع ومخالفة تعليمات السلامة.',
'الصلاة والتلبية والذكر.',
'منى.',
'الثامن من ذي الحجة.',
'لبيك اللهم لبيك.',
'مبيت يوم التروية غير مبيت ليالي التشريق.',
'الاستعداد ليوم عرفة.',
),
'arafah': _HajjStage(
'الوقوف داخل حدود عرفات في الوقت الشرعي، وهو ركن الحج الأعظم.',
'الوقوف خارج حدود عرفات.',
'الإكثار من الدعاء والتوبة.',
'عرفات، داخل الحدود المعتمدة.',
'التاسع من ذي الحجة في وقت الوقوف المشروع.',
'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
'توجد أحكام تتعلق بوقت الوقوف والانصراف، ومنها البقاء إلى الغروب لمن وقف نهارًا وفق هذا التصنيف.',
'الرجاء في مغفرة الله ورحمته.',
),
'muzdalifah': _HajjStage(
'الانتقال إلى مزدلفة بعد غروب الشمس والمبيت فيها وفق الأحكام، والجمع بين المغرب والعشاء.',
'التدافع أو ترك المبيت المطلوب بلا عذر.',
'الذكر والدعاء والراحة.',
'مزدلفة.',
'ليلة العاشر من ذي الحجة.',
'الله أكبر، والحمد لله، ولا إله إلا الله.',
'توجد رخص لأصحاب الأعذار في وقت الانصراف والمبيت.',
'التهيؤ ليوم النحر.',
),
'aqabah': _HajjStage(
'رمي جمرة العقبة الكبرى بسبع حصيات متعاقبات.',
'التدافع أو رمي أشياء تؤذي الناس.',
'التكبير مع كل حصاة.',
'جمرة العقبة الكبرى في منى.',
'العاشر من ذي الحجة، وفق الأوقات المشروعة.',
'الله أكبر.',
'لرمي جمرة العقبة أوقات ورخص، وهو من أعمال يوم النحر المتعلقة بالتحلل.',
'الطاعة واتباع السنة.',
),
'hady': _HajjStage(
'أداء الهدي الواجب على المتمتع والقارن إذا تحققت شروطه.',
'اعتقاد وجوبه على المفرد لمجرد الإفراد.',
'استخدام الجهات المعتمدة للذبح.',
'مواقع الذبح المعتمدة.',
'الوقت الشرعي للنحر.',
'بسم الله، والله أكبر.',
'عند عدم القدرة على الهدي الواجب يوجد بدل شرعي بالصيام بشروطه.',
'الإحسان إلى المحتاجين.',
),
'haircut': _HajjStage(
'يحلق الرجل شعر رأسه أو يقصره، والمرأة تقصر من أطراف شعرها.',
'اعتبار مجرد تبديل الملابس تحللًا صحيحًا.',
'الحلق أفضل للرجال في الجملة.',
'مكان مناسب وآمن.',
'من أعمال يوم النحر.',
'الحمد لله.',
'الحلق أو التقصير أحد الأعمال المتعلقة بالتحلل الأول والثاني.',
'الامتثال لله.',
),
'ifadah': _HajjStage(
'طواف الإفاضة سبعة أشواط، وهو ركن من أركان الحج.',
'اعتقاد أن طواف القدوم يغني عن طواف الإفاضة.',
'الدعاء والذكر أثناء الطواف.',
'المسجد الحرام.',
'ابتداءً من يوم النحر وفق الأحكام.',
'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار.',
'من بقي عليه سعي للحج يؤديه وفق أحكام نسكه.',
'تعظيم شعائر الله.',
),
'hajj_sai': _HajjStage(
'سعي الحج للمتمتع سبعة أشواط مستقل عن سعي عمرته.',
'احتساب سعي العمرة بدلًا عن سعي الحج.',
'الذكر والدعاء عند الصفا والمروة.',
'المسعى بين الصفا والمروة.',
'بعد طواف مناسب للحج.',
'إن الصفا والمروة من شعائر الله.',
'للمتمتع سعي للعمرة وسعي آخر للحج، والسعي من أعمال إتمام النسك.',
'الصبر والتوكل.',
),
'tashreeq': _HajjStage(
'المبيت بمنى ورمي الجمرات الثلاث بالترتيب في الأيام المطلوبة، سبع حصيات لكل جمرة.',
'الرمي قبل الوقت المشروع أو التدافع وإيذاء الآخرين.',
'التكبير مع كل حصاة والدعاء في المواضع المشروعة.',
'منى والجمرات.',
'اليومان 11 و12 من ذي الحجة، واليوم 13 لمن تأخر.',
'الله أكبر.',
'يجوز التعجل يوم 12 بشروطه أو التأخر حتى يوم 13، وتوجد رخص للأعذار.',
'أيام ذكر لله وإتمام المناسك.',
),
'farewell': _HajjStage(
'طواف الوداع عند مغادرة مكة لمن يلزمه.',
'تركه لمن وجب عليه دون عذر.',
'الذكر والدعاء وشكر الله.',
'المسجد الحرام.',
'عند مغادرة مكة بعد إتمام أعمال الحج.',
'الحمد لله.',
'الحائض والنفساء لهما استثناء من طواف الوداع، وتوجد أحكام تفصيلية.',
'وداع البيت بعد إتمام المناسك.',
),
},

'en': {
'umrah_ihram': _HajjStage(
'Enter Ihram for Umrah at the appropriate Miqat, make the intention and begin Talbiyah.',
'Crossing the Miqat without Ihram when Ihram is required.',
'Perform ghusl, prepare for Ihram and recite Talbiyah.',
'The Miqat corresponding to your route to Makkah.',
'During the months of Hajj, before crossing the applicable Miqat.',
'Labbayka Allahumma Umratan — Here I am, O Allah, intending to perform Umrah.',
'Ihram restrictions begin when you enter the rite.',
'Beginning Umrah with sincere devotion to Allah.',
),
'umrah_tawaf': _HajjStage(
'Circle the Kaaba seven times, beginning and ending each circuit at the Black Stone.',
'Cutting through Hijr Ismail or harming other pilgrims in the crowd.',
'Remember Allah and make dua; no unique obligatory dua is assigned to each circuit.',
'Masjid al-Haram in Makkah.',
'After arriving in Makkah.',
'Our Lord, grant us good in this world and good in the Hereafter, and protect us from the Fire.',
'Complete all seven circuits and observe the conditions of Tawaf.',
'Showing reverence for the Sacred House.',
),
'umrah_sai': _HajjStage(
'Complete seven lengths between Safa and Marwah, starting at Safa and finishing at Marwah.',
'Starting at Marwah or counting a return journey as part of the same length.',
'Remember Allah and make dua during Sa’i.',
'The Sa’i walkway between Safa and Marwah.',
'After Tawaf for Umrah.',
'Indeed, Safa and Marwah are among the symbols of Allah.',
'Each journey from one hill to the other counts as one length.',
'Remembering Hajar’s patience and reliance on Allah.',
),
'umrah_haircut': _HajjStage(
'Men shave or trim their hair; women trim their hair as prescribed to complete Umrah.',
'Treating Umrah as completed before finishing its required rites.',
'Shaving is generally preferred for men; Tamattu pilgrims should also consider how close Hajj is.',
'Makkah.',
'After Sa’i for Umrah.',
'Alhamdulillah — Praise be to Allah.',
'A Tamattu pilgrim leaves Umrah Ihram and later enters a new Ihram for Hajj.',
'Gratitude for completing Umrah.',
),
'hajj_ihram': _HajjStage(
'The Tamattu pilgrim makes the intention for Hajj and enters Ihram from Makkah or their place of residence there.',
'Assuming that a return to the distant Miqat is required for Hajj Ihram.',
'Perform ghusl and begin Talbiyah.',
'Makkah or the place of residence there.',
'Usually on 8 Dhul-Hijjah, the Day of Tarwiyah.',
'Labbayka Allahumma Hajjan — O Allah, here I am for Hajj.',
'Ihram restrictions apply again after entering Hajj Ihram.',
'The beginning of the Hajj rites.',
),
'ihram': _HajjStage(
'Enter Ihram at the appropriate Miqat according to your route and Hajj type.',
'Passing the Miqat without Ihram when it is required.',
'Perform ghusl and recite Talbiyah.',
'The Miqat corresponding to your arrival route.',
'Before crossing the Miqat.',
'Labbayka Allahumma Hajjan, or Labbayka Umratan wa Hajjan according to your rite.',
'Ifrad is Hajj alone; Qiran combines Hajj and Umrah in one Ihram.',
'Beginning the journey with sincerity and obedience.',
),
'arrival': _HajjStage(
'Perform seven circuits of Tawaf al-Qudum (Arrival Tawaf) when prescribed for your Hajj type.',
'Harming others or going through Hijr Ismail while making Tawaf.',
'Remember Allah and make dua.',
'Masjid al-Haram.',
'Upon arriving in Makkah.',
'Our Lord, grant us good in this world and in the Hereafter, and protect us from the Fire.',
'Tawaf al-Qudum does not replace Tawaf al-Ifadah.',
'Honouring the Kaaba and the Sacred Mosque.',
),
'sai': _HajjStage(
'Perform seven lengths of Sa’i for Hajj. Ifrad and Qiran pilgrims may perform it after Tawaf al-Qudum or postpone it until after Tawaf al-Ifadah.',
'Repeating a valid Sa’i thinking two are required, or forgetting Sa’i if it was postponed.',
'Remember Allah and make dua at Safa and Marwah.',
'Between Safa and Marwah.',
'After an applicable Tawaf, before or after the Day of Sacrifice according to the rite.',
'Indeed, Safa and Marwah are among the symbols of Allah.',
'A postponed Hajj Sa’i remains due until it is actually performed.',
'Practising patience and reliance on Allah.',
),
'mina': _HajjStage(
'Go to Mina on the Day of Tarwiyah while following the relevant rules and official arrangements.',
'Pushing in crowds or ignoring safety instructions.',
'Offer prayers, recite Talbiyah and remember Allah.',
'Mina.',
'8 Dhul-Hijjah.',
'Labbayka Allahumma Labbayk.',
'The stay on Tarwiyah differs in ruling from the nights of Tashreeq.',
'Preparing spiritually and physically for Arafah.',
),
'arafah': _HajjStage(
'Stand within the official boundaries of Arafah during its prescribed time. This is an essential pillar of Hajj.',
'Remaining outside Arafah’s boundaries.',
'Make abundant dua, seek forgiveness and repent.',
'Within the designated area of Arafah.',
'9 Dhul-Hijjah, during the prescribed standing period.',
'There is no deity except Allah alone, without partner. His is the dominion and all praise; He has power over all things.',
'Rules govern the time of standing and departure, including remaining until sunset for those who stand there by day under this classification.',
'Hoping for Allah’s mercy and forgiveness.',
),
'muzdalifah': _HajjStage(
'Travel to Muzdalifah after sunset, combine Maghrib and Isha as prescribed, and stay according to the applicable rulings.',
'Dangerous crowding or missing the required stay without a valid excuse.',
'Remember Allah, make dua and rest.',
'Muzdalifah.',
'The night before 10 Dhul-Hijjah.',
'Allahu Akbar, Alhamdulillah, La ilaha illa Allah.',
'Concessions exist for some pilgrims regarding the stay and departure times.',
'Preparing for the Day of Sacrifice.',
),
'aqabah': _HajjStage(
'Stone Jamrat al-Aqabah with seven separate pebbles.',
'Pushing or throwing dangerous objects that could hurt others.',
'Say Allahu Akbar with each pebble.',
'The large Jamrah at Mina.',
'10 Dhul-Hijjah, at a time permitted by the rulings.',
'Allahu Akbar — Allah is the Greatest.',
'Jamrat al-Aqabah has prescribed times and concessions; it is one of the acts related to release from Ihram.',
'Obedience and following the Prophetic practice.',
),
'hady': _HajjStage(
'Offer the Hady sacrifice if it is obligatory for your Tamattu or Qiran Hajj and its conditions apply.',
'Assuming Ifrad alone makes Hady obligatory.',
'Use authorized Hady services and approved facilities.',
'Authorized sacrificial facilities.',
'During the prescribed time for Hady.',
'Bismillah, Allahu Akbar — In Allah’s name; Allah is the Greatest.',
'Those unable to provide obligatory Hady have a prescribed fasting alternative with specific rules.',
'Giving and caring for those in need.',
),
'haircut': _HajjStage(
'Men shave or trim the hair of their head; women trim their hair as prescribed.',
'Assuming that changing clothes alone constitutes a valid release from Ihram.',
'Shaving is generally preferable for men.',
'A suitable, safe place.',
'Among the rites of 10 Dhul-Hijjah.',
'Alhamdulillah — Praise be to Allah.',
'Shaving or trimming is one of the acts connected with the first and second releases from Ihram.',
'Obedience to Allah.',
),
'ifadah': _HajjStage(
'Complete seven circuits of Tawaf al-Ifadah, an essential pillar of Hajj.',
'Assuming Tawaf al-Qudum is enough to replace Tawaf al-Ifadah.',
'Remember Allah and make dua while performing Tawaf.',
'Masjid al-Haram.',
'From the Day of Sacrifice onward, according to the rulings.',
'Our Lord, grant us good in this world and in the Hereafter, and protect us from the Fire.',
'Anyone who still owes Hajj Sa’i must complete it according to their chosen rite.',
'Honouring the symbols of Allah.',
),
'hajj_sai': _HajjStage(
'Tamattu pilgrims perform seven lengths of Hajj Sa’i separately from their earlier Umrah Sa’i.',
'Counting Umrah Sa’i as if it also fulfilled the separate Hajj Sa’i.',
'Remember Allah and make dua at Safa and Marwah.',
'Between Safa and Marwah.',
'After a suitable Hajj Tawaf.',
'Indeed, Safa and Marwah are among the symbols of Allah.',
'Tamattu has one Sa’i for Umrah and a separate Sa’i for Hajj.',
'Patience and reliance on Allah.',
),
'tashreeq': _HajjStage(
'Stay in Mina as required and stone the three Jamarat in order on the applicable days, with seven pebbles at each Jamrah.',
'Stoning before the permitted time, pushing or endangering other people.',
'Say Allahu Akbar with each pebble and make dua in its prescribed places.',
'Mina and the Jamarat complex.',
'11 and 12 Dhul-Hijjah; also 13 Dhul-Hijjah for those who stay.',
'Allahu Akbar — Allah is the Greatest.',
'You may leave early on Day 12 if the conditions apply, or remain until Day 13. Exemptions may apply.',
'Days for remembering Allah and completing Hajj rites.',
),
'farewell': _HajjStage(
'Perform Farewell Tawaf when departing Makkah if it is required in your circumstances.',
'Omitting an obligatory Farewell Tawaf without a valid excuse.',
'Remember Allah, make dua and give thanks.',
'Masjid al-Haram.',
'Before departing Makkah after finishing Hajj rites.',
'Alhamdulillah — Praise be to Allah.',
'Menstruating and postpartum women are exempt from Farewell Tawaf; further individual rulings may apply.',
'Bidding farewell to the Sacred House with gratitude.',
),
},

'ur': {
'umrah_ihram': _HajjStage(
'اپنے راستے کے مقررہ میقات سے عمرے کا احرام باندھیں، نیت کریں اور تلبیہ شروع کریں۔',
'جہاں احرام ضروری ہو وہاں بغیر احرام میقات پار کرنا غلطی ہے۔',
'احرام سے پہلے غسل، صفائی اور تلبیہ مستحب ہیں۔',
'مکہ آنے کے راستے کا مقررہ میقات۔',
'حج کے مہینوں میں عمرے کے لیے مکہ آنے سے پہلے۔',
'لبیک اللہم عمرۃ — اے اللہ، میں عمرے کے لیے حاضر ہوں۔',
'نیت کے ساتھ نسک میں داخل ہونے پر احرام کی پابندیاں شروع ہوتی ہیں۔',
'اخلاص کے ساتھ اللہ کی عبادت کا آغاز۔',
),
'umrah_tawaf': _HajjStage(
'حجر اسود سے شروع کرکے کعبہ کے گرد سات مکمل چکر لگائیں، ہر چکر وہیں ختم ہو۔',
'حطیم کے اندر سے گزرنا یا بھیڑ میں لوگوں کو تکلیف دینا۔',
'طواف میں ذکر اور دعا کریں؛ ہر چکر کے لیے الگ مقررہ دعا لازم نہیں۔',
'مکہ کی مسجد الحرام۔',
'مکہ پہنچنے کے بعد۔',
'اے ہمارے رب، ہمیں دنیا اور آخرت میں بھلائی عطا فرما اور آگ کے عذاب سے بچا۔',
'ساتوں چکر مکمل کریں اور طواف کی شرائط کا خیال رکھیں۔',
'بیت اللہ کی تعظیم۔',
),
'umrah_sai': _HajjStage(
'صفا سے شروع کرکے مروہ تک سات چکر مکمل کریں؛ آخری چکر مروہ پر ختم ہوگا۔',
'مروہ سے آغاز کرنا یا آنے جانے کو ایک ہی چکر شمار کرنا۔',
'سعی میں ذکر اور دعا کریں۔',
'صفا اور مروہ کے درمیان مسعیٰ۔',
'عمرے کے طواف کے بعد۔',
'بے شک صفا اور مروہ اللہ کی نشانیوں میں سے ہیں۔',
'صفا سے مروہ یا مروہ سے صفا تک جانا ایک چکر ہے۔',
'حضرت ہاجرہ علیہا السلام کے صبر اور اللہ پر توکل کی یاد۔',
),
'umrah_haircut': _HajjStage(
'مرد سر کے بال منڈوائیں یا کتروائیں اور عورتیں مقررہ انداز میں بال کاٹیں، پھر عمرہ مکمل ہوگا۔',
'ضروری مناسک پورے کیے بغیر احرام کی پابندیاں ختم سمجھنا۔',
'عام طور پر مردوں کے لیے حلق افضل ہے؛ حج کے قریب ہونے کی صورت کا بھی خیال رکھیں۔',
'مکہ مکرمہ۔',
'عمرے کی سعی کے بعد۔',
'الحمدللہ — تمام تعریفیں اللہ کے لیے ہیں۔',
'تمتع کرنے والا عمرے سے تحلل کرتا ہے، پھر حج کے وقت نیا احرام باندھتا ہے۔',
'عمرہ مکمل ہونے پر اللہ کا شکر ادا کرنا۔',
),
'hajj_ihram': _HajjStage(
'تمتع کرنے والا مکہ یا اپنی رہائش کی جگہ سے حج کی نیت کرکے احرام باندھے۔',
'یہ سمجھنا کہ حج کا احرام باندھنے کے لیے دور والے میقات واپس جانا ضروری ہے۔',
'غسل اور تلبیہ پڑھنا مستحب ہے۔',
'مکہ یا مکہ میں اپنی رہائش کی جگہ۔',
'عموماً آٹھ ذوالحجہ، یوم الترویہ۔',
'لبیک اللہم حجاً — اے اللہ، میں حج کے لیے حاضر ہوں۔',
'حج کے احرام میں داخل ہونے پر احرام کی پابندیاں دوبارہ شروع ہوتی ہیں۔',
'حج کے مناسک کا آغاز۔',
),
'ihram': _HajjStage(
'حج کی قسم اور آمد کے راستے کے مطابق متعلقہ میقات سے احرام باندھیں۔',
'جہاں احرام واجب ہو وہاں بغیر احرام میقات پار کرنا۔',
'غسل اور تلبیہ پڑھنا۔',
'اپنے راستے کا مقررہ میقات۔',
'میقات پار کرنے سے پہلے۔',
'لبیک اللہم حجاً، یا حج کی قسم کے مطابق لبیک عمرۃ وحجاً۔',
'افراد صرف حج ہے جبکہ قران میں ایک احرام سے حج اور عمرہ دونوں ہوتے ہیں۔',
'اخلاص اور اللہ کی فرمانبرداری۔',
),
'arrival': _HajjStage(
'جس حاجی کے لیے مشروع ہو وہ طواف قدوم کے سات چکر لگائے۔',
'طواف میں دوسروں کو تکلیف دینا یا حطیم کے اندر سے گزرنا۔',
'طواف کے دوران اللہ کا ذکر اور دعا کریں۔',
'مسجد الحرام۔',
'مکہ پہنچنے پر۔',
'اے ہمارے رب، ہمیں دنیا اور آخرت کی بھلائی دے اور آگ کے عذاب سے بچا۔',
'طواف قدوم، طواف افاضہ کی جگہ نہیں لیتا۔',
'کعبہ اور مسجد الحرام کی تعظیم۔',
),
'sai': _HajjStage(
'حج کی سعی کے سات چکر ادا کریں۔ مفرد اور قارن طواف قدوم کے بعد یا طواف افاضہ کے بعد سعی کرسکتے ہیں۔',
'ایک درست سعی دوبارہ لازم سمجھنا یا مؤخر کی ہوئی سعی بھول جانا۔',
'صفا اور مروہ پر ذکر اور دعا کریں۔',
'صفا اور مروہ کے درمیان۔',
'مناسب طواف کے بعد، نسک کے مطابق یوم النحر سے پہلے یا بعد۔',
'بے شک صفا اور مروہ اللہ کی نشانیوں میں سے ہیں۔',
'اگر سعی مؤخر کی ہو تو اسے حقیقت میں ادا کیے بغیر مکمل نہ سمجھیں۔',
'صبر اور اللہ پر توکل۔',
),
'mina': _HajjStage(
'یوم الترویہ کو متعلقہ احکام اور سرکاری انتظامات کے مطابق منیٰ جائیں۔',
'بھیڑ میں دھکم پیل یا حفاظتی ہدایات کی خلاف ورزی۔',
'نماز، تلبیہ اور ذکر کا اہتمام کریں۔',
'منیٰ۔',
'آٹھ ذوالحجہ۔',
'لبیک اللہم لبیک۔',
'یوم الترویہ کی رات کا قیام ایام تشریق کی راتوں سے حکم میں مختلف ہے۔',
'عرفہ کے دن کے لیے روحانی اور جسمانی تیاری۔',
),
'arafah': _HajjStage(
'مقررہ شرعی وقت میں عرفات کی حدود کے اندر وقوف کریں؛ یہ حج کا بنیادی رکن ہے۔',
'عرفات کی متعین حدود سے باہر رہ جانا۔',
'کثرت سے دعا، استغفار اور توبہ کریں۔',
'عرفات کی مقررہ حدود کے اندر۔',
'نو ذوالحجہ، وقوف کے مقررہ وقت میں۔',
'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہت اور تعریف ہے۔',
'وقوف اور روانگی کے اوقات کے احکام ہیں؛ اس تقسیم میں دن کے وقت وقوف کرنے والے کے لیے غروب تک رہنا واجب ہے۔',
'اللہ کی رحمت اور بخشش کی امید۔',
),
'muzdalifah': _HajjStage(
'عرفات سے غروب کے بعد مزدلفہ جائیں، مغرب و عشاء کو احکام کے مطابق جمع کریں اور مقررہ قیام کریں۔',
'دھکم پیل یا بغیر شرعی عذر ضروری قیام چھوڑ دینا۔',
'ذکر، دعا اور آرام کریں۔',
'مزدلفہ۔',
'دس ذوالحجہ سے پہلے کی رات۔',
'اللہ اکبر، الحمدللہ، لا الہ الا اللہ۔',
'بعض حاجیوں کو قیام اور روانگی کے وقت میں شرعی رعایت حاصل ہوتی ہے۔',
'یوم النحر کے لیے تیاری۔',
),
'aqabah': _HajjStage(
'جمرہ عقبہ پر الگ الگ سات کنکریاں ماریں۔',
'دھکم پیل کرنا یا ایسی چیز پھینکنا جس سے لوگ زخمی ہوسکیں۔',
'ہر کنکری کے ساتھ اللہ اکبر کہیں۔',
'منیٰ میں جمرہ عقبہ کبریٰ۔',
'دس ذوالحجہ، مشروع وقت کے مطابق۔',
'اللہ اکبر — اللہ سب سے بڑا ہے۔',
'جمرہ عقبہ کی رمی کے وقت اور رعایت کے احکام ہیں؛ یہ تحلل سے متعلق اعمال میں سے ہے۔',
'اللہ کی اطاعت اور سنت کی پیروی۔',
),
'hady': _HajjStage(
'اگر شرائط پوری ہوں تو تمتع یا قران کی واجب ہدی ادا کریں۔',
'صرف حج افراد اختیار کرنے کی وجہ سے ہدی واجب سمجھنا۔',
'مجاز قربانی خدمات اور مقررہ مقامات استعمال کریں۔',
'مجاز ذبح گاہیں۔',
'ہدی کے مقررہ شرعی وقت میں۔',
'بسم اللہ، اللہ اکبر۔',
'واجب ہدی کی استطاعت نہ ہو تو مخصوص شرائط کے ساتھ روزوں کا شرعی متبادل ہے۔',
'ضرورت مندوں سے احسان اور ہمدردی۔',
),
'haircut': _HajjStage(
'مرد سر منڈوائیں یا بال کتروائیں، اور خواتین مقررہ انداز سے بال کاٹیں۔',
'صرف لباس تبدیل کرنے کو درست تحلل سمجھ لینا۔',
'عام طور پر مردوں کے لیے حلق افضل ہے۔',
'محفوظ اور مناسب مقام۔',
'دس ذوالحجہ کے اعمال میں سے۔',
'الحمدللہ — تمام تعریفیں اللہ کے لیے ہیں۔',
'حلق یا قصر پہلے اور دوسرے تحلل سے متعلق اعمال میں سے ہے۔',
'اللہ کی فرمانبرداری۔',
),
'ifadah': _HajjStage(
'طواف افاضہ کے سات چکر مکمل کریں؛ یہ حج کا بنیادی رکن ہے۔',
'یہ سمجھنا کہ طواف قدوم، طواف افاضہ کی جگہ لے سکتا ہے۔',
'طواف میں ذکر اور دعا کریں۔',
'مسجد الحرام۔',
'یوم النحر سے، متعلقہ شرعی احکام کے مطابق۔',
'اے ہمارے رب، ہمیں دنیا اور آخرت میں بھلائی عطا فرما اور آگ کے عذاب سے بچا۔',
'جس کی حج کی سعی باقی ہو اسے اپنے نسک کے احکام کے مطابق مکمل کرے۔',
'اللہ کی نشانیوں کی تعظیم۔',
),
'hajj_sai': _HajjStage(
'تمتع کرنے والا حج کی سعی کے سات چکر، عمرے کی سعی سے الگ ادا کرے۔',
'عمرے کی سعی کو حج کی الگ سعی کا بدل سمجھ لینا۔',
'صفا اور مروہ پر ذکر اور دعا کریں۔',
'صفا اور مروہ کے درمیان۔',
'حج کے مناسب طواف کے بعد۔',
'بے شک صفا اور مروہ اللہ کی نشانیوں میں سے ہیں۔',
'تمتع میں عمرے کی ایک سعی اور حج کی الگ سعی ہوتی ہے۔',
'صبر اور توکل۔',
),
'tashreeq': _HajjStage(
'منیٰ میں ضروری قیام کریں اور مقررہ دنوں میں تینوں جمرات کی ترتیب سے رمی کریں؛ ہر جمرے پر سات کنکریاں۔',
'مقررہ وقت سے پہلے رمی کرنا یا دھکم پیل سے لوگوں کو تکلیف دینا۔',
'ہر کنکری پر اللہ اکبر کہیں اور مشروع مقامات پر دعا کریں۔',
'منیٰ اور جمرات کا علاقہ۔',
'گیارہ اور بارہ ذوالحجہ، اور تاخیر کرنے والے کے لیے تیرہ ذوالحجہ۔',
'اللہ اکبر — اللہ سب سے بڑا ہے۔',
'شرائط پوری ہوں تو بارہ تاریخ کو تعجل یا تیرہ تاریخ تک قیام جائز ہے؛ عذر کی رعایتیں موجود ہیں۔',
'یہ اللہ کے ذکر اور حج مکمل کرنے کے دن ہیں۔',
),
'farewell': _HajjStage(
'جس حاجی پر لازم ہو وہ مکہ سے روانگی کے وقت طواف وداع کرے۔',
'بغیر شرعی عذر واجب طواف وداع چھوڑ دینا۔',
'ذکر، دعا اور اللہ کا شکر ادا کریں۔',
'مسجد الحرام۔',
'حج کے اعمال مکمل کرنے کے بعد مکہ سے روانگی کے وقت۔',
'الحمدللہ — تمام تعریفیں اللہ کے لیے ہیں۔',
'حیض یا نفاس والی خواتین کو طواف وداع کی رعایت ہے؛ مزید انفرادی احکام بھی ہوسکتے ہیں۔',
'شکر کے ساتھ بیت اللہ کو الوداع کہنا۔',
),
},
};


_HajjStage get stage =>
stages[lang]?[widget.stepKey] ??
stages['ar']?[widget.stepKey] ??
stages['ar']!['ihram']!;

bool get showReleaseSection => const [
'aqabah', 'hady', 'haircut', 'ifadah', 'hajj_sai', 'tashreeq',
].contains(widget.stepKey);

bool get showIhramReleaseNotice => const [
'umrah_haircut', 'haircut', 'ifadah',
'hajj_sai', 'tashreeq', 'farewell',
].contains(widget.stepKey);

String get releaseOneText => tx(
'بحسب تصنيف فقهي معروف، يحصل التحلل الأول بفعل اثنين من ثلاثة: رمي جمرة العقبة، والحلق أو التقصير، وطواف الإفاضة مع السعي لمن بقي عليه سعي. وبعده تحل معظم محظورات الإحرام وتبقى أحكام العلاقة الزوجية إلى التحلل الثاني. وتوجد أقوال أخرى في المسألة.',
'Under a well-known legal view, the first release follows two of three: stoning Jamrat al-Aqabah; shaving or trimming; and Tawaf al-Ifadah with Sa’i if still required. Most Ihram restrictions end, but marital restrictions remain. Scholars differ on details.',
'ایک معروف فقہی قول کے مطابق تین میں سے دو کاموں کے بعد پہلا تحلل ہوتا ہے: جمرہ عقبہ کی رمی، حلق یا قصر، اور طواف افاضہ کے ساتھ باقی ضروری سعی۔ اس کے بعد زیادہ تر پابندیاں ختم ہو جاتی ہیں مگر ازدواجی پابندی باقی رہتی ہے۔ اس میں فقہی اختلاف ہے۔',
);

String get releaseTwoText => tx(
'التحلل الثاني يكون بعد استكمال رمي جمرة العقبة، والحلق أو التقصير، وطواف الإفاضة مع سعي الحج لمن بقي عليه سعي. وتزول بقية محظورات الإحرام وفق الأحكام الشرعية.',
'The second release follows completing Jamrat al-Aqabah, shaving or trimming, and Tawaf al-Ifadah with any remaining Hajj Sa’i. The remaining Ihram restrictions then end under the applicable rulings.',
'دوسرا تحلل جمرہ عقبہ کی رمی، حلق یا قصر، طواف افاضہ اور باقی ضروری سعی کی تکمیل کے بعد ہوتا ہے۔ پھر باقی احرام کی پابندیاں شرعی احکام کے مطابق ختم ہوتی ہیں۔',
);

String get releaseNote => tx(
'الهدي ليس من الأعمال الثلاثة التي يُحسب بها التحلل وفق هذا التصنيف. وقد يتأخر الطواف أو السعي لسبب مشروع، ولا يعني الانتقال في التطبيق حصول التحلل. تُراجع الأحكام التفصيلية مع مرشد شرعي.',
'Hady is not one of the three release acts under this classification. Tawaf or Sa’i may be delayed for a valid reason. Moving to the next app page does not establish release. Ask a qualified religious guide about your circumstances.',
'اس تقسیم میں ہدی تحلل کے تین اعمال میں شامل نہیں۔ طواف یا سعی شرعی وجہ سے مؤخر ہو سکتی ہے۔ ایپ کے اگلے صفحے پر جانے سے تحلل ثابت نہیں ہوتا۔ مستند شرعی رہنمائی حاصل کریں۔',
);

String get womenNote => tx(
'الحائض والنفساء تؤديان ما يجوز لهما من المناسك، ومنها عرفة والذكر والرمي. أما الطواف فله أحكام خاصة عند الحيض والنفاس؛ وتُسأل جهة إفتاء موثوقة في الحالات الفردية. ولهما استثناء من طواف الوداع. المرأة تقصر من شعرها ولا تحلق للنسك.',
'Menstruating and postpartum pilgrims can perform applicable rites such as standing at Arafah, remembrance and stoning. Tawaf has special rulings: consult a qualified religious guide for individual cases. They are exempt from Farewell Tawaf. Women trim, rather than shave, for the rite.',
'حیض اور نفاس والی خواتین عرفات میں وقوف، ذکر اور رمی جیسے جائز مناسک ادا کرسکتی ہیں۔ طواف کے خاص احکام ہیں؛ انفرادی صورت میں مستند عالم سے پوچھیں۔ طواف وداع میں رعایت ہے۔ خواتین بال کترواتی ہیں، منڈواتی نہیں۔',
);

String get accessibilityNote => tx(
'كبار السن والمرضى وذوو الإعاقة لهم رخص شرعية بحسب حالهم، ومنها بعض صور التوكيل في الرمي والرخص المتعلقة بالمبيت والتنقل. تُتبع التعليمات الرسمية ولا يُترك ركن أو واجب بالاعتماد على التطبيق وحده.',
'Elderly pilgrims, pilgrims with illnesses, and pilgrims with disabilities may qualify for concessions, including certain forms of delegation for stoning or allowances involving stays and travel. Follow official guidance and do not omit a pillar or obligation based on the app alone.',
'بزرگ، بیمار اور معذور حاجیوں کے لیے حالات کے مطابق رخصتیں ہوسکتی ہیں، جیسے بعض صورتوں میں رمی کے لیے نائب مقرر کرنا یا قیام اور سفر میں رعایت۔ سرکاری ہدایات پر عمل کریں اور ایپ کی بنیاد پر کوئی رکن یا واجب نہ چھوڑیں۔',
);

String get hadyNote => tx(
'الهدي واجب على المتمتع والقارن عند تحقق شروط الوجوب، ولا يجب على المفرد لمجرد الإفراد. ومن عجز عن الهدي الواجب فله بدل شرعي بالصيام وفق شروطه وتوقيته. ويُستخدم نظام الهدي المعتمد.',
'Hady is obligatory for qualifying Tamattu and Qiran pilgrims, but not solely for choosing Ifrad. Those unable to offer an obligatory Hady have a prescribed fasting alternative with conditions and timing requirements. Use approved services.',
'شرائط پوری ہوں تو تمتع اور قران میں ہدی واجب ہے؛ صرف افراد اختیار کرنے سے واجب نہیں ہوتی۔ واجب ہدی کی استطاعت نہ ہونے پر مقررہ شرائط اور وقت کے مطابق روزوں کا متبادل ہے۔ مجاز خدمات استعمال کریں۔',
);

String get typeNote {
switch (widget.hajjType) {
case 'tamattu':
return tx(
'التمتع: عمرة أولًا ثم تحلل، وبعدها إحرام جديد للحج. للعمرة سعي وللحج سعي مستقل، والهدي واجب بشروطه.',
'Tamattu: perform Umrah and leave Ihram, then enter a new Ihram for Hajj. Umrah and Hajj have separate Sa’i, and Hady applies when required.',
'تمتع میں پہلے عمرہ اور تحلل ہوتا ہے، پھر حج کا نیا احرام۔ عمرے اور حج کی الگ سعی ہے، اور شرائط کے مطابق ہدی واجب ہے۔',
);
case 'qiran':
return tx(
'القِران: الحج والعمرة بإحرام واحد، ويكفي سعي صحيح واحد لهما، والهدي واجب عند تحقق شروطه.',
'Qiran: Hajj and Umrah share one Ihram. One valid Sa’i suffices for both; Hady applies if its conditions are fulfilled.',
'قران میں حج اور عمرہ ایک احرام سے ہوتے ہیں۔ دونوں کے لیے ایک درست سعی کافی ہے؛ شرائط پوری ہوں تو ہدی واجب ہے۔',
);
case 'ifrad':
return tx(
'الإفراد: الإحرام للحج وحده، ويكفي سعي صحيح واحد للحج، ولا يجب الهدي لمجرد الإفراد.',
'Ifrad: enter Ihram for Hajj alone. One valid Hajj Sa’i is sufficient; Hady is not required solely because of Ifrad.',
'افراد میں صرف حج کا احرام ہوتا ہے۔ حج کی ایک درست سعی کافی ہے اور صرف افراد کی وجہ سے ہدی واجب نہیں۔',
);
default:
return tx(
'هذا دليل تعليمي للمشتركات. تختلف أحكام السعي والهدي والتحلل بحسب التمتع والقِران والإفراد.',
'This general guide covers shared rites. Sa’i, Hady and release rulings differ between Tamattu, Qiran and Ifrad.',
'یہ مشترکہ مناسک کی تعلیمی رہنمائی ہے۔ تمتع، قران اور افراد میں سعی، ہدی اور تحلل کے احکام مختلف ہیں۔',
);
}
}

@override
void initState() {
super.initState();
ProgressService.saveLastPage(
'hajj_${widget.hajjType}_${widget.stepKey}',
);
loadProgress();
}

@override
void didUpdateWidget(covariant HajjStepPage oldWidget) {
super.didUpdateWidget(oldWidget);
if (oldWidget.stepKey != widget.stepKey ||
oldWidget.hajjType != widget.hajjType) {
counter = 0;
completed = false;
departureChoice = 0;
loadProgress();
}
}

Future<void> loadProgress() async {
final expectedStep = widget.stepKey;
final expectedType = widget.hajjType;

final savedCounter =
await ProgressService.getCounter(counterKey);
final savedDone =
await ProgressService.getCounter(doneKey);
final savedDeparture =
await ProgressService.getCounter(departureKey);

if (!mounted ||
widget.stepKey != expectedStep ||
widget.hajjType != expectedType) {
return;
}

setState(() {
counter = savedCounter.clamp(0, 7).toInt();
completed = savedDone == 1;
departureChoice = [12, 13].contains(savedDeparture)
? savedDeparture
: 0;
});
}

Future<void> changeCounter(int value) async {
final next = value.clamp(0, 7).toInt();
setState(() => counter = next);
await ProgressService.saveCounter(counterKey, next);
}

Future<void> changeCompleted(bool value) async {
setState(() => completed = value);
await ProgressService.saveCounter(
doneKey,
value ? 1 : 0,
);
}

Future<bool> dayComplete(int day) async {
for (var i = 0; i < 3; i++) {
final count = await ProgressService.getCounter(
'jamarat_${widget.hajjType}_${day}_$i',
);
if (count != 7) return false;
}
return true;
}

void showNotice(String message) {
if (!mounted) return;
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(message),
duration: const Duration(seconds: 5),
),
);
}


Future<void> chooseDeparture(int choice) async {
if (choice == 12) {
final counted = await dayComplete(12);
if (!mounted) return;
if (!counted) showNotice(t('notReady'));
}
if (!mounted) return;

final accepted = await showDialog<bool>(
context: context,
builder: (dialogContext) => AlertDialog(
title: Text(t('confirm')),
content: Text(choice == 12 ? t('confirmEarly') : t('confirmLate')),
actions: [
TextButton(
onPressed: () => Navigator.pop(dialogContext, false),
child: Text(t('cancel')),
),
ElevatedButton(
onPressed: () => Navigator.pop(dialogContext, true),
child: Text(t('confirm')),
),
],
),
);

if (accepted != true || !mounted) return;
setState(() => departureChoice = choice);
await ProgressService.saveCounter(departureKey, choice);
showNotice(choice == 12 ? t('earlySaved') : t('lateSaved'));
}

Widget sound(String text) => IconButton(
tooltip: t('listen'),
onPressed: () => TtsService.speak(text, language: lang),
icon: const Icon(Icons.volume_up_rounded, color: AppStyle.green),
);

Widget info(String heading, String content, IconData symbol) {
return Card(
color: Colors.white,
margin: const EdgeInsets.only(bottom: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(17),
side: const BorderSide(color: AppStyle.gold, width: 1.3),
),
child: Padding(
padding: const EdgeInsets.all(14),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Row(children: [
Icon(symbol, color: AppStyle.green),
const SizedBox(width: 8),
Expanded(child: Text(
heading,
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: AppStyle.green,
),
)),
sound(heading),
]),
const Divider(color: AppStyle.gold),
Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Expanded(child: Text(
content,
style: const TextStyle(
fontSize: 16,
height: 1.7,
color: AppStyle.text,
),
)),
sound(content),
],
),
],
),
),
);
}

Widget sectionHeading(String heading) => Padding(
padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
child: Row(children: [
Expanded(child: Text(
heading,
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: AppStyle.green,
),
)),
sound(heading),
]),
);

Widget releaseSection() => Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
sectionHeading(t('releaseTitle')),
info(t('firstRelease'), releaseOneText, Icons.lock_open_outlined),
info(t('secondRelease'), releaseTwoText, Icons.verified_outlined),
info(t('releaseImportant'), releaseNote, Icons.info_outline),
],
);

Widget specialCasesSection() => Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
sectionHeading(t('specialTitle')),
info(t('women'), womenNote, Icons.person_outline),
info(
t('accessibility'),
accessibilityNote,
Icons.accessible_forward_outlined,
),
info(t('hadyTitle'), hadyNote, Icons.info_outline),
info(t('typeTitle'), typeNote, Icons.alt_route),
],
);

String get counterTitle {
if (widget.stepKey == 'aqabah') {
return tx('عداد الحصيات', 'Pebble Counter', 'کنکریوں کی گنتی');
}
if (const ['umrah_sai', 'sai', 'hajj_sai']
.contains(widget.stepKey)) {
return tx(
'عداد أشواط السعي',
'Sa’i Counter',
'سعی کے چکروں کی گنتی',
);
}
return tx(
'عداد أشواط الطواف',
'Tawaf Counter',
'طواف کے چکروں کی گنتی',
);
}

Widget counterCard() => Card(
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
side: const BorderSide(color: AppStyle.gold),
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(children: [
Row(children: [
Expanded(child: Text(
counterTitle,
style: const TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
color: AppStyle.green,
),
)),
sound(counterTitle),
]),
const SizedBox(height: 10),
Text(
'$counter / 7',
style: const TextStyle(
fontSize: 38,
fontWeight: FontWeight.bold,
color: AppStyle.green,
),
),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
IconButton.filled(
onPressed: counter > 0
? () => changeCounter(counter - 1)
: null,
icon: const Icon(Icons.remove),
style: IconButton.styleFrom(
backgroundColor: AppStyle.green,
foregroundColor: Colors.white,
),
),
const SizedBox(width: 14),
VoiceIncrementButton(
language: lang,
value: counter,
maximum: 7,
onIncrement: () => changeCounter(counter + 1),
),
const SizedBox(width: 14),
IconButton.filled(
onPressed: counter < 7
? () => changeCounter(counter + 1)
: null,
icon: const Icon(Icons.add),
style: IconButton.styleFrom(
backgroundColor: AppStyle.green,
foregroundColor: Colors.white,
),
),
],
),
TextButton(
onPressed: () => changeCounter(0),
child: Text(t('reset')),
),
]),
),
);

Widget departureButton(int choice) {
final selected = departureChoice == choice;
return OutlinedButton.icon(
onPressed: () => chooseDeparture(choice),
icon: Icon(
selected ? Icons.check_circle : Icons.circle_outlined,
),
label: Text(choice == 12 ? t('early') : t('late')),
style: OutlinedButton.styleFrom(
backgroundColor: selected ? AppStyle.green : Colors.white,
foregroundColor: selected ? Colors.white : AppStyle.green,
padding: const EdgeInsets.all(15),
side: const BorderSide(color: AppStyle.gold),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
),
);
}

Widget departureCard() => Card(
color: Colors.white,
margin: const EdgeInsets.only(top: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
side: const BorderSide(
color: AppStyle.gold,
width: 1.5,
),
),
child: Padding(
padding: const EdgeInsets.all(15),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
sectionHeading(t('departureTitle')),
Text(
t('departureIntro'),
style: const TextStyle(
color: AppStyle.text,
height: 1.6,
),
),
const SizedBox(height: 12),
info(
t('early'),
t('earlyRules'),
Icons.directions_walk,
),
info(
t('late'),
t('lateRules'),
Icons.nights_stay_outlined,
),
departureButton(12),
const SizedBox(height: 10),
departureButton(13),
const SizedBox(height: 12),
Text(
departureChoice == 12
? t('earlySaved')
: departureChoice == 13
? t('lateSaved')
: t('notSelected'),
style: const TextStyle(color: AppStyle.green),
),
const SizedBox(height: 9),
Text(
t('choiceNote'),
style: const TextStyle(
fontSize: 13,
color: AppStyle.text,
),
),
],
),
),
);

Future<void> goNext() async {
if (widget.stepKey == 'tashreeq') {
if (departureChoice == 0) {
showNotice(t('notSelected'));
return;
}

final day = departureChoice == 12 ? 12 : 13;
final counted = await dayComplete(day);
if (!mounted) return;
if (!counted) showNotice(t('notReady'));
}

if (!mounted) return;

if (position < 0) {
showNotice(tx(
'المرحلة غير معروفة.',
'Unknown step.',
'یہ مرحلہ موجود نہیں۔',
));
return;
}

final next = position + 1;

if (next >= route.length) {
if (isGeneral) {
Navigator.popUntil(
context,
(screen) => screen.isFirst,
);
} else {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const HajjFinishPage(),
),
);
}
return;
}

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => HajjStepPage(
stepKey: route[next],
hajjType: widget.hajjType,
),
),
);
}

void goPrevious() {
if (position > 0) {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => HajjStepPage(
stepKey: route[position - 1],
hajjType: widget.hajjType,
),
),
);
} else {
Navigator.pop(context);
}
}

@override


Widget build(BuildContext context) {
  return ValueListenableBuilder<String>(
    valueListenable: AppLanguage.languageNotifier,
    builder: (context, current, _) {
      final data = stage;

      return Directionality(
        textDirection: lang == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppStyle.cream,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppStyle.green,
            foregroundColor: Colors.white,
            title: Text(title),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: AppStyle.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          sound(title),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // دفتر الأدعية
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              color: AppStyle.cream,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(
                                  color: AppStyle.gold,
                                  width: 1.5,
                                ),
                              ),
                              child: IconButton(
                                tooltip: tx(
                                  'دفتر الأدعية',
                                  'Dua Book',
                                  'دعاؤں کی کتاب',
                                ),
                                iconSize: 32,
                                padding: const EdgeInsets.all(13),
                                color: AppStyle.green,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DuaBookPage(
                                      stepKey: widget.stepKey,
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.menu_book),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              tx(
                                'دفتر الأدعية',
                                'Dua Book',
                                'دعاؤں کی کتاب',
                              ),
                              style: const TextStyle(
                                color: AppStyle.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              tooltip: t('listen'),
                              onPressed: () => TtsService.speak(
                                tx(
                                  'دفتر الأدعية',
                                  'Dua Book',
                                  'دعاؤں کی کتاب',
                                ),
                                language: lang,
                              ),
                              icon: const Icon(
                                Icons.volume_up_rounded,
                                color: AppStyle.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${t('step')} ${position + 1} ${t('of')} ${route.length}",
                        style: const TextStyle(
                          color: AppStyle.green,
                        ),
                      ),
                      const SizedBox(height: 12),

                      LinearProgressIndicator(
                        value: position >= 0
                            ? (position + 1) / route.length
                            : 0,
                        minHeight: 8,
                        backgroundColor: Colors.white,
                        color: AppStyle.green,
                      ),

                      const SizedBox(height: 18),

                      if (isGeneral)
                        info(
                          t('notes'),
                          t('generalWarning'),
                          Icons.info_outline,
                        ),

                      info(
                        t('meaning'),
                        data.meaning,
                        Icons.auto_stories_outlined,
                      ),

                      info(
                        t('actions'),
                        data.actions,
                        Icons.check_circle_outline,
                      ),

                      // الأحكام الموجودة في ملفها المستقل
                      HajjRulingsSection(
                        stepKey: widget.stepKey,
                        hajjType: widget.hajjType,
                      ),

                      const SizedBox(height: 12),

                      if (showReleaseSection) releaseSection(),

                      info(
                        t('ihramRules'),
                        showIhramReleaseNotice
                            ? t('releaseText')
                            : t('ihramText'),
                        Icons.block_outlined,
                      ),

                      info(
                        t('forbidden'),
                        t('forbiddenText'),
                        Icons.gpp_bad_outlined,
                      ),

                      info(
                        t('mistakes'),
                        data.mistakes,
                        Icons.warning_amber_outlined,
                      ),

                      info(
                        t('sunnah'),
                        data.sunnah,
                        Icons.favorite_outline,
                      ),

                      info(
                        t('place'),
                        data.location,
                        Icons.location_on_outlined,
                      ),

                      info(
                        t('time'),
                        data.time,
                        Icons.schedule_outlined,
                      ),

                      info(
                        t('dua'),
                        data.dua,
                        Icons.menu_book_outlined,
                      ),

                      info(
                        t('notes'),
                        data.notes,
                        Icons.info_outline,
                      ),

                      info(
                        t('safety'),
                        t('safetyText'),
                        Icons.health_and_safety_outlined,
                      ),

                      specialCasesSection(),

                      // عدادات الجمرات والأشواط
                      if (widget.stepKey == 'tashreeq') ...[
                        const SizedBox(height: 12),
                        JamaratCounter(
                          hajjType: widget.hajjType,
                        ),
                        const SizedBox(height: 12),
                        departureCard(),
                      ] else if (hasCounter)
                        counterCard(),

                      const SizedBox(height: 14),

                      OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DuaBookPage(
                              stepKey: widget.stepKey,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.menu_book),
                        label: Text(t('book')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppStyle.green,
                          side: const BorderSide(
                            color: AppStyle.gold,
                          ),
                          padding: const EdgeInsets.all(15),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Card(
                        color: Colors.white,
                        child: CheckboxListTile(
                          value: completed,
                          activeColor: AppStyle.green,
                          title: Text(t('done')),
                          secondary: sound(t('done')),
                          onChanged: (value) =>
                              changeCompleted(value ?? false),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        onPressed: goNext,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(
                          position == route.length - 1
                              ? (isGeneral
                              ? t('finishGuide')
                              : t('finish'))
                              : t('next'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(17),
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton.icon(
                        onPressed: goPrevious,
                        icon: const Icon(Icons.arrow_back),
                        label: Text(t('back')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppStyle.green,
                          side: const BorderSide(
                            color: AppStyle.gold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
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
