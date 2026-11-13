import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';

class _Dua {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String attribution;
  final List<String> steps;

  const _Dua(
      this.id,
      this.category,
      this.title,
      this.arabic,
      this.attribution,
      this.steps,
      );
}

class DuaBookPage extends StatefulWidget {
  final String stepKey;

  const DuaBookPage({
    super.key,
    this.stepKey = '',
  });

  @override
  State<DuaBookPage> createState() => _DuaBookPageState();
}

class _DuaBookPageState extends State<DuaBookPage> {
  final TextEditingController _search = TextEditingController();

  String _category = 'relevant';

  String get lang {
    final value = AppLanguage.currentLanguage;
    return const ['ar', 'en', 'ur'].contains(value)
        ? value
        : 'ar';
  }

  static const ui = <String, Map<String, String>>{
    'ar': {
      'title': 'دفتر الأدعية',
      'search': 'ابحثي عن دعاء أو موضوع',
      'relevant': 'أدعية هذه المرحلة',
      'all': 'الكل',
      'travel': 'السفر والعودة',
      'ihram': 'الإحرام',
      'haram': 'المسجد الحرام',
      'tawaf': 'الطواف',
      'sai': 'السعي',
      'arafah': 'عرفة',
      'quran': 'أدعية قرآنية',
      'hadith': 'أدعية مأثورة',
      'general': 'أدعية عامة',
      'empty': 'لا توجد نتائج في هذا القسم.',
      'read': 'استمع إلى الدعاء',
      'notice':
      'يجوز لك الدعاء بما شئت من الخير. لا يوجد دعاء مخصوص واجب لكل شوط من الطواف أو السعي. الأدعية العامة ليست بالضرورة أحاديث نبوية ثابتة، وظهور الدعاء في مرحلة لا يعني تخصيصه شرعًا بها.',
    },
    'en': {
      'title': 'Dua Book',
      'search': 'Search prayers or topics',
      'relevant': 'For This Step',
      'all': 'All',
      'travel': 'Travel and Return',
      'ihram': 'Ihram',
      'haram': 'Sacred Mosque',
      'tawaf': 'Tawaf',
      'sai': 'Sai',
      'arafah': 'Arafah',
      'quran': 'Quranic Prayers',
      'hadith': 'Reported Supplications',
      'general': 'General Prayers',
      'empty': 'No prayers found.',
      'read': 'Listen to the prayer',
      'notice':
      'You may make any good supplication. No separate prayer is obligatory for every circuit of Tawaf or Sai. General prayers are not necessarily authenticated prophetic reports. Displaying a prayer for a step does not establish special religious status for it.',
    },
    'ur': {
      'title': 'دعاؤں کی کتاب',
      'search': 'دعائیں تلاش کریں',
      'relevant': 'اس مرحلے کی دعائیں',
      'all': 'سب',
      'travel': 'سفر اور واپسی',
      'ihram': 'احرام',
      'haram': 'مسجد الحرام',
      'tawaf': 'طواف',
      'sai': 'سعی',
      'arafah': 'عرفہ',
      'quran': 'قرآنی دعائیں',
      'hadith': 'ماثور دعائیں',
      'general': 'عام دعائیں',
      'empty': 'کوئی دعا نہیں ملی۔',
      'read': 'دعا سنیں',
      'notice':
      'آپ بھلائی کی کوئی بھی دعا مانگ سکتے ہیں۔ طواف یا سعی کے ہر چکر کے لیے الگ مخصوص دعا لازم نہیں۔ عام دعاؤں کو لازماً حدیث نہ سمجھیں۔ کسی مرحلے میں دعا دکھانے سے وہ اس مرحلے کے لیے مخصوص ثابت نہیں ہوتی۔',
    },
  };

  // الأدعية مرتبة حسب المناسبة.
  // نسبة الأدعية إلى السنة تحتاج مراجعة علمية
  // قبل نشر التطبيق بشكل رسمي.

  static const List<_Dua> prayers = [
    // =========================
    // السفر والعودة
    // =========================

    _Dua(
      'leave',
      'travel',
      'المسافر للمقيم',
      'أستودعكم الله الذي لا تضيع ودائعه.',
      'مأثور',
      ['travel'],
    ),

    _Dua(
      'travel',
      'travel',
      'دعاء السفر',
      'الله أكبر، الله أكبر، الله أكبر. '
          'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، '
          'وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ. '
          'اللهم إنا نسألك في سفرنا هذا البر والتقوى، '
          'ومن العمل ما ترضى، '
          'اللهم هون علينا سفرنا هذا واطو عنا بعده، '
          'اللهم أنت الصاحب في السفر والخليفة في الأهل، '
          'اللهم إني أعوذ بك من وعثاء السفر وكآبة المنظر '
          'وسوء المنقلب في المال والأهل والولد.',
      'مأثور',
      ['travel'],
    ),

    _Dua(
      'return',
      'travel',
      'عند العودة من السفر',
      'آيبون، تائبون، عابدون، لربنا حامدون.',
      'مأثور',
      ['farewell', 'travel'],
    ),

    // =========================
    // الإحرام
    // =========================

    _Dua(
      'talbiyah',
      'ihram',
      'التلبية',
      'لبيك اللهم لبيك، لبيك لا شريك لك لبيك، '
          'إن الحمد والنعمة لك والملك، لا شريك لك.',
      'مأثور',
      ['umrah_ihram', 'hajj_ihram', 'ihram'],
    ),

    // =========================
    // المسجد الحرام
    // =========================

    _Dua(
      'enter_mosque',
      'haram',
      'دخول المسجد الحرام',
      'أعوذ بالله العظيم، وبوجهه الكريم، '
          'وسلطانه القديم من الشيطان الرجيم. '
          'بسم الله، والصلاة والسلام على رسول الله، '
          'اللهم اغفر لي ذنوبي وافتح لي أبواب رحمتك.',
      'أذكار مأثورة لدخول المسجد',
      ['arrival', 'umrah_tawaf', 'umrah_ihram'],
    ),

    _Dua(
      'see_kaaba',
      'haram',
      'دعاء عند رؤية الكعبة',
      'اللهم زد هذا البيت تشريفًا وتعظيمًا وتكريمًا ومهابة، '
          'وزد من شرفه وكرمه ممن حجه أو اعتمره '
          'تشريفًا وتكريمًا وتعظيمًا وبرًا، '
          'اللهم أنت السلام ومنك السلام فحينا ربنا بالسلام.',
      'غير ثابت بخصوص رؤية الكعبة',
      ['arrival', 'umrah_tawaf'],
    ),

    // =========================
    // الطواف
    // =========================

    _Dua(
      'corner',
      'tawaf',
      'بين الركن اليماني والحجر الأسود',
      'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً '
          'وَفِي الْآخِرَةِ حَسَنَةً '
          'وَقِنَا عَذَابَ النَّارِ.',
      'مأثور',
      [
        'tawaf',
        'umrah_tawaf',
        'arrival',
        'ifadah',
        'farewell',
      ],
    ),

    // =========================
    // السعي
    // =========================

    _Dua(
      'safa_verse',
      'sai',
      'الآية عند ابتداء السعي من الصفا',
      'إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ '
          'فَمَنْ حَجَّ الْبَيْتَ أَوِ اعْتَمَرَ '
          'فَلَا جُنَاحَ عَلَيْهِ أَنْ يَطَّوَّفَ بِهِمَا '
          'وَمَنْ تَطَوَّعَ خَيْرًا '
          'فَإِنَّ اللَّهَ شَاكِرٌ عَلِيمٌ. '
          'أبدأ بما بدأ الله به.',
      'مأثور عند البدء من الصفا',
      ['sai', 'umrah_sai', 'hajj_sai'],
    ),

    _Dua(
      'safa_dhikr',
      'sai',
      'الذكر على الصفا والمروة',
      'الله أكبر، الله أكبر، الله أكبر. '
          'لا إله إلا الله وحده لا شريك له، '
          'له الملك وله الحمد وهو على كل شيء قدير. '
          'لا إله إلا الله وحده، '
          'أنجز وعده، ونصر عبده، وهزم الأحزاب وحده.',
      'مأثور',
      ['sai', 'umrah_sai', 'hajj_sai'],
    ),

    // =========================
    // عرفة
    // =========================

    _Dua(
      'arafah',
      'arafah',
      'الذكر في يوم عرفة',
      'لا إله إلا الله وحده لا شريك له، '
          'له الملك وله الحمد وهو على كل شيء قدير.',
      'مأثور',
      ['arafah'],
    ),

    // =========================
    // أدعية من القرآن
    // =========================

    _Dua(
      'q_baqarah',
      'quran',
      'من خواتيم سورة البقرة',
      'رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا، '
          'رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا '
          'كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا، '
          'رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ، '
          'وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا '
          'أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_ghafir',
      'quran',
      'دعاء الملائكة للمؤمنين',
      'رَبَّنَا وَسِعْتَ كُلَّ شَيْءٍ رَحْمَةً وَعِلْمًا '
          'فَاغْفِرْ لِلَّذِينَ تَابُوا وَاتَّبَعُوا سَبِيلَكَ '
          'وَقِهِمْ عَذَابَ الْجَحِيمِ، '
          'رَبَّنَا وَأَدْخِلْهُمْ جَنَّاتِ عَدْنٍ الَّتِي وَعَدْتَهُمْ '
          'وَمَنْ صَلَحَ مِنْ آبَائِهِمْ وَأَزْوَاجِهِمْ وَذُرِّيَّاتِهِمْ '
          'إِنَّكَ أَنْتَ الْعَزِيزُ الْحَكِيمُ، '
          'وَقِهِمُ السَّيِّئَاتِ وَمَنْ تَقِ السَّيِّئَاتِ '
          'يَوْمَئِذٍ فَقَدْ رَحِمْتَهُ '
          'وَذَلِكَ هُوَ الْفَوْزُ الْعَظِيمُ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_imran',
      'quran',
      'دعاء من سورة آل عمران',
      'رَبَّنَا مَا خَلَقْتَ هَذَا بَاطِلًا '
          'سُبْحَانَكَ فَقِنَا عَذَابَ النَّارِ، '
          'رَبَّنَا إِنَّكَ مَنْ تُدْخِلِ النَّارَ '
          'فَقَدْ أَخْزَيْتَهُ وَمَا لِلظَّالِمِينَ مِنْ أَنْصَارٍ. '
          'رَبَّنَا إِنَّنَا سَمِعْنَا مُنَادِيًا يُنَادِي لِلْإِيمَانِ '
          'أَنْ آمِنُوا بِرَبِّكُمْ فَآمَنَّا، '
          'رَبَّنَا فَاغْفِرْ لَنَا ذُنُوبَنَا '
          'وَكَفِّرْ عَنَّا سَيِّئَاتِنَا وَتَوَفَّنَا مَعَ الْأَبْرَارِ، '
          'رَبَّنَا وَآتِنَا مَا وَعَدْتَنَا عَلَى رُسُلِكَ '
          'وَلَا تُخْزِنَا يَوْمَ الْقِيَامَةِ '
          'إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_world',
      'quran',
      'حسنة الدنيا والآخرة',
      'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً '
          'وَفِي الْآخِرَةِ حَسَنَةً '
          'وَقِنَا عَذَابَ النَّارِ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_patience',
      'quran',
      'طلب الصبر',
      'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا '
          'وَتَوَفَّنَا مُسْلِمِينَ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_forgive',
      'quran',
      'المغفرة والثبات',
      'رَبَّنَا اغْفِرْ لَنَا ذُنُوبَنَا '
          'وَإِسْرَافَنَا فِي أَمْرِنَا '
          'وَثَبِّتْ أَقْدَامَنَا '
          'وَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_adam',
      'quran',
      'دعاء آدم وحواء',
      'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا '
          'وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا '
          'لَنَكُونَنَّ مِنَ الْخَاسِرِينَ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_prayer',
      'quran',
      'صلاح الصلاة والذرية',
      'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي '
          'رَبَّنَا وَتَقَبَّلْ دُعَاءِ، '
          'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ '
          'يَوْمَ يَقُومُ الْحِسَابُ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_kahf',
      'quran',
      'الرشد والرحمة',
      'رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً '
          'وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_muminun',
      'quran',
      'المغفرة والرحمة',
      'رَبَّنَا آمَنَّا فَاغْفِرْ لَنَا وَارْحَمْنَا '
          'وَأَنْتَ خَيْرُ الرَّاحِمِينَ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_brothers',
      'quran',
      'الدعاء للمؤمنين',
      'رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا '
          'الَّذِينَ سَبَقُونَا بِالْإِيمَانِ '
          'وَلَا تَجْعَلْ فِي قُلُوبِنَا غِلًّا لِلَّذِينَ آمَنُوا '
          'رَبَّنَا إِنَّكَ رَءُوفٌ رَحِيمٌ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_tawakkul',
      'quran',
      'التوكل والإنابة',
      'رَبَّنَا عَلَيْكَ تَوَكَّلْنَا '
          'وَإِلَيْكَ أَنَبْنَا وَإِلَيْكَ الْمَصِيرُ.',
      'قرآني',
      [],
    ),

    _Dua(
      'q_mumtahana',
      'quran',
      'الاستعاذة من الفتنة',
      'رَبَّنَا لَا تَجْعَلْنَا فِتْنَةً لِلَّذِينَ كَفَرُوا '
          'وَاغْفِرْ لَنَا رَبَّنَا '
          'إِنَّكَ أَنْتَ الْعَزِيزُ الْحَكِيمُ.',
      'قرآني',
      [],
    ),

    // =========================
    // أدعية مأثورة
    // =========================

    _Dua(
      'afiyah',
      'hadith',
      'العفو والعافية',
      'اللهم إني أسألك العفو والعافية في ديني ودنياي وأهلي ومالي، '
          'اللهم استر عوراتي وآمن روعاتي، '
          'اللهم احفظني من بين يدي ومن خلفي '
          'وعن يميني وعن شمالي ومن فوقي، '
          'وأعوذ بعظمتك أن أغتال من تحتي.',
      'مأثور',
      [],
    ),

    _Dua(
      'body',
      'hadith',
      'العافية في البدن والسمع والبصر',
      'اللهم عافني في بدني، اللهم عافني في سمعي، '
          'اللهم عافني في بصري، لا إله إلا أنت.',
      'مأثور',
      [],
    ),

    _Dua(
      'poverty',
      'hadith',
      'الاستعاذة من الفقر والكفر',
      'اللهم إني أعوذ بك من الكفر والفقر، '
          'وأعوذ بك من عذاب القبر، لا إله إلا أنت.',
      'مأثور',
      [],
    ),

    _Dua(
      'istighfar',
      'hadith',
      'سيد الاستغفار',
      'اللهم أنت ربي لا إله إلا أنت خلقتني وأنا عبدك، '
          'وأنا على عهدك ووعدك ما استطعت، '
          'أعوذ بك من شر ما صنعت، '
          'أبوء لك بنعمتك عليّ، '
          'وأبوء بذنبي فاغفر لي، '
          'فإنه لا يغفر الذنوب إلا أنت.',
      'مأثور',
      [],
    ),

    _Dua(
      'worry',
      'hadith',
      'الاستعاذة من الهم والحزن',
      'اللهم إني أعوذ بك من الهم والحزن، '
          'وأعوذ بك من العجز والكسل، '
          'وأعوذ بك من الجبن والبخل، '
          'وأعوذ بك من غلبة الدين وقهر الرجال.',
      'مأثور',
      [],
    ),

    _Dua(
      'soul',
      'hadith',
      'تزكية النفس',
      'اللهم آت نفسي تقواها، '
          'وزكها أنت خير من زكاها، '
          'أنت وليها ومولاها.',
      'مأثور',
      [],
    ),

    _Dua(
      'knowledge',
      'hadith',
      'علم نافع وقلب خاشع',
      'اللهم إني أعوذ بك من علم لا ينفع، '
          'وقلب لا يخشع، ونفس لا تشبع، '
          'ودعوة لا يستجاب لها.',
      'مأثور',
      [],
    ),

    _Dua(
      'blessing',
      'hadith',
      'الاستعاذة من زوال النعمة',
      'اللهم إني أعوذ بك من زوال نعمتك، '
          'وتحول عافيتك، وفجاءة نقمتك، '
          'وجميع سخطك.',
      'مأثور',
      [],
    ),

    _Dua(
      'religion',
      'hadith',
      'صلاح الدين والدنيا والآخرة',
      'اللهم أصلح لي ديني الذي هو عصمة أمري، '
          'وأصلح لي دنياي التي فيها معاشي، '
          'وأصلح لي آخرتي التي إليها معادي، '
          'واجعل الحياة زيادة لي في كل خير، '
          'واجعل الموت راحة لي من كل شر.',
      'مأثور',
      [],
    ),

    _Dua(
      'steadfast',
      'hadith',
      'الثبات وشكر النعمة',
      'اللهم إني أسألك الثبات في الأمر والعزيمة على الرشد، '
          'وأسألك شكر نعمتك وحسن عبادتك، '
          'وأسألك قلبًا سليمًا ولسانًا صادقًا، '
          'وأسألك من خير ما تعلم وأعوذ بك من شر ما تعلم '
          'وأستغفرك مما تعلم وأنت علام الغيوب.',
      'مأثور',
      [],
    ),

    _Dua(
      'righteous',
      'hadith',
      'حب الله وفعل الخيرات',
      'اللهم إني أسألك فعل الخيرات وترك المنكرات '
          'وحب المساكين، وأن تغفر لي وترحمني، '
          'وإذا أردت بعبادك فتنة فتوفني إليك غير مفتون.',
      'مأثور',
      [],
    ),

    _Dua(
      'love',
      'hadith',
      'حب الله وما يقرب إليه',
      'اللهم إني أسألك حبك، وحب من يحبك، '
          'وحب كل عمل يقربني إلى حبك.',
      'مأثور',
      [],
    ),

    _Dua(
      'heart',
      'hadith',
      'تثبيت القلب على الدين',
      'يا مقلب القلوب، ثبت قلبي على دينك.',
      'مأثور',
      [],
    ),

    _Dua(
      'obedience',
      'hadith',
      'تصريف القلوب إلى الطاعة',
      'اللهم مصرف القلوب، صرف قلوبنا على طاعتك.',
      'مأثور',
      [],
    ),

    _Dua(
      'fear',
      'hadith',
      'الخشية والطاعة واليقين',
      'اللهم اقسم لنا من خشيتك ما تحول به بيننا وبين معصيتك، '
          'ومن طاعتك ما تبلغنا به جنتك، '
          'ومن اليقين ما تهون به علينا مصائب الدنيا، '
          'ومتعنا بأسماعنا وأبصارنا وقواتنا ما أحييتنا، '
          'واجعله الوارث منا، '
          'واجعل ثأرنا على من ظلمنا، '
          'وانصرنا على من عادانا، '
          'ولا تجعل الدنيا أكبر همنا ولا مبلغ علمنا، '
          'ولا تجعل مصيبتنا في ديننا، '
          'ولا تسلط علينا بذنوبنا من لا يخافك ولا يرحمنا.',
      'مأثور',
      [],
    ),

    _Dua(
      'calamity',
      'hadith',
      'الاستعاذة من البلاء',
      'اللهم إني أعوذ بك من جهد البلاء '
          'ودرك الشقاء وسوء القضاء وشماتة الأعداء.',
      'مأثور',
      [],
    ),

    _Dua(
      'guidance',
      'hadith',
      'حسن الخلق',
      'اللهم اهدني لأحسن الأعمال والأخلاق '
          'لا يهدي لأحسنها إلا أنت، '
          'واصرف عني سيئها لا يصرف عني سيئها إلا أنت.',
      'مأثور',
      [],
    ),

    _Dua(
      'evil',
      'hadith',
      'الاستعاذة من شر العمل',
      'اللهم إني أعوذ بك من شر ما عملت، '
          'ومن شر ما لم أعمل.',
      'مأثور',
      [],
    ),

    _Dua(
      'help',
      'hadith',
      'رب أعني ولا تعن علي',
      'رب أعني ولا تعن علي، '
          'وانصرني ولا تنصر علي، '
          'واهدني ويسر الهدى لي، '
          'وانصرني على من بغى علي، '
          'رب اجعلني لك شكارًا، لك ذكارًا، '
          'لك رهابًا، لك مطواعًا، لك مخبتًا، '
          'إليك أواهًا منيبًا، '
          'رب تقبل توبتي، واغسل حوبتي، '
          'وأجب دعوتي، وثبت حجتي، '
          'وسدد لساني، واهد قلبي، '
          'واسلل سخيمة صدري.',
      'مأثور',
      [],
    ),

    // =========================
    // أدعية عامة
    // =========================

    _Dua(
      'day',
      'general',
      'صلاح أول اليوم وآخره',
      'اللهم اجعل أول هذا اليوم صلاحًا، '
          'وأوسطه فلاحًا، وآخره نجاحًا، '
          'وأسألك خيري الدنيا والآخرة يا أرحم الراحمين.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'pleasure',
      'general',
      'الرضا والشوق',
      'اللهم إني أسألك الرضا بعد القضاء، '
          'وبرد العيش بعد الموت، '
          'ولذة النظر إلى وجهك الكريم، '
          'والشوق إلى لقائك في غير ضراء مضرة '
          'ولا فتنة مضلة.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'house',
      'general',
      'صلاح الدين والرزق',
      'اللهم أصلح لي ديني، ووسع لي في داري، '
          'وبارك لي في رزقي.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'morals',
      'general',
      'الاستعاذة من القسوة والغفلة',
      'اللهم إني أعوذ بك من القسوة والغفلة '
          'والذلة والمسكنة، '
          'وأعوذ بك من الكفر والفسوق والشقاق '
          'والسمعة والرياء.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'badtraits',
      'general',
      'الاستعاذة من سوء الأخلاق',
      'اللهم إني أعوذ بك من منكرات الأخلاق '
          'والأعمال والأهواء والأدواء، '
          'وأعوذ بك من غلبة الدين وقهر العدو '
          'وشماتة الأعداء.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'forgiveness',
      'general',
      'الرحمة والمغفرة',
      'اللهم إني أسألك موجبات رحمتك '
          'وعزائم مغفرتك، '
          'والغنيمة من كل بر والسلامة من كل شر، '
          'والفوز بالجنة والنجاة من النار.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'needs',
      'general',
      'قضاء الحاجات',
      'اللهم لا تدع لنا ذنبًا إلا غفرته، '
          'ولا عيبًا إلا سترته، '
          'ولا همًا إلا فرجته، '
          'ولا دينًا إلا قضيته، '
          'ولا حاجة من حوائج الدنيا والآخرة '
          'هي لك رضًا ولنا صلاح إلا قضيتها '
          'يا أرحم الراحمين.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'mercy',
      'general',
      'رحمة من عند الله',
      'اللهم إني أسألك رحمة من عندك '
          'تهدي بها قلبي، وتجمع بها أمري، '
          'وتلم بها شعثي، وتحفظ بها غائبي، '
          'وترفع بها شاهدي، وتبيض بها وجهي، '
          'وتزكي بها عملي، وتلهمني بها رشدي، '
          'وترد بها الفتن عني، '
          'وتعصمني بها من كل سوء.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'faith',
      'general',
      'الصحة والإيمان',
      'اللهم إني أسألك صحة في إيمان، '
          'وإيمانًا في حسن خلق، '
          'ونجاحًا يتبعه فلاح، '
          'ورحمة منك، وعافية منك، '
          'ومغفرة منك ورضوانًا.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'chastity',
      'general',
      'الصحة والعفة',
      'اللهم إني أسألك الصحة والعفة '
          'وحسن الخلق والرضا بالقدر، '
          'اللهم إني أعوذ بك من شر نفسي '
          'ومن شر كل دابة أنت آخذ بناصيتها، '
          'إن ربي على صراط مستقيم.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'consequence',
      'general',
      'حسن العاقبة',
      'اللهم أحسن عاقبتنا في الأمور كلها '
          'وأجرنا من خزي الدنيا وعذاب الآخرة.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'children',
      'general',
      'الدعاء للأولاد',
      'اللهم إنا نسألك لأولادنا الصلاح والعافية، '
          'وحفظهم كتابك الكريم والعمل به '
          'وسنة نبيك الأمين، '
          'اللهم إنا نسألك لهم الرفقة الصالحة '
          'التي تذكرهم إذا نسوا '
          'وتنبههم إذا غفلوا '
          'وتعلمهم إذا جهلوا '
          'وتهديهم إذا ضلوا.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'love_more',
      'general',
      'محبة الله',
      'اللهم اجعل حبك أحب إلي من نفسي '
          'وأهلي ومالي وولدي '
          'ومن الماء البارد على الظمأ، '
          'اللهم حببني إليك وإلى ملائكتك '
          'وأنبيائك وجميع خلقك.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'ease',
      'general',
      'تفريج الهم',
      'اللهم فارج الهم كاشف الغم '
          'مجيب دعوة المضطرين، '
          'رحمان الدنيا والآخرة ورحيمهما '
          'ارحمني رحمة تغنيني بها '
          'عن رحمة من سواك.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'reliance',
      'general',
      'الافتقار إلى الله',
      'اللهم لا تكلنا إلى أنفسنا فنعجز '
          'ولا إلى الناس فنضيع.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'beauty',
      'general',
      'البركة والعافية',
      'اللهم جمل أمري ما أحييتني، '
          'وعافني ما أبقيتني، '
          'وبارك لي فيما خولتني، '
          'واحفظ علي ما أوليتني.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'piety',
      'general',
      'التقوى والرضا',
      'اللهم اجعلني أخشاك حتى كأني أراك، '
          'وأسعدني بتقواك، '
          'ولا تجعلني بمعصيتك مطرودًا، '
          'ورضني بقضائك، وبارك لي في قدرك.',
      'دعاء عام',
      [],
    ),

    _Dua(
      'wellness',
      'general',
      'العافية والمغفرة',
      'اللهم ألبسني العافية حتى تهنيني بالمعيشة، '
          'واختم لي بالمغفرة حتى لا تضرني الذنوب، '
          'واكفني كل هول دون الجنة '
          'حتى تبلغنيها برحمتك يا أرحم الراحمين.',
      'دعاء عام',
      [],
    ),

    // أدعية إضافية محفوظة منفصلة عن القائمة الأصلية.
    _Dua('q_musa', 'quran', 'شرح الصدر وتيسير الأمر',
        'رَبِّ اشْرَحْ لِي صَدْرِي، وَيَسِّرْ لِي أَمْرِي.',
        'قرآني - طه: 25-26', []),
    _Dua('q_ilm', 'quran', 'طلب زيادة العلم',
        'رَبِّ زِدْنِي عِلْمًا.',
        'قرآني - طه: 114', []),
    _Dua('q_yunus', 'quran', 'دعاء يونس عليه السلام',
        'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ.',
        'قرآني - الأنبياء: 87', []),
    _Dua('q_ayub', 'quran', 'دعاء أيوب عليه السلام',
        'أَنِّي مَسَّنِيَ الضُّرُّ وَأَنْتَ أَرْحَمُ الرَّاحِمِينَ.',
        'قرآني - الأنبياء: 83', []),
    _Dua('q_nuh', 'quran', 'دعاء نوح لوالديه والمؤمنين',
        'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِمَنْ دَخَلَ بَيْتِيَ مُؤْمِنًا وَلِلْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ.',
        'قرآني - نوح: 28، جزء من الآية', []),
    _Dua('q_family', 'quran', 'صلاح الأسرة والذرية',
        'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا.',
        'قرآني - الفرقان: 74', []),
    _Dua('q_mercy', 'quran', 'الرحمة والهداية',
        'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ.',
        'قرآني - آل عمران: 8', []),
    _Dua('q_accept', 'quran', 'قبول العمل',
        'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ الْعَلِيمُ.',
        'قرآني - البقرة: 127', []),
    _Dua('dhikr_takbir', 'hadith', 'التكبير عند رمي الجمرات',
        'اللَّهُ أَكْبَرُ.',
        'ذكر مأثور عند الرمي', ['aqabah', 'tashreeq']),
    _Dua('dua_mina', 'general', 'دعاء عام في منى',
        'اللهم أعنّا على ذكرك وشكرك وحسن عبادتك، وتقبّل منا حجنا، واغفر لنا ولوالدينا وللمؤمنين.',
        'دعاء عام غير مخصص بمنى', ['mina', 'tashreeq']),
    _Dua('dua_muzdalifah', 'general', 'دعاء عام في مزدلفة',
        'اللهم اهدنا ويسّر لنا مناسكنا، وأعنّا على ذكرك وشكرك وحسن عبادتك.',
        'دعاء عام غير مخصص بمزدلفة', ['muzdalifah']),
    _Dua('dua_arafah_general', 'general', 'دعاء عام يوم عرفة',
        'اللهم اغفر لنا وارحمنا وتب علينا، وأعتق رقابنا من النار، وتقبّل توبتنا ودعاءنا.',
        'دعاء عام غير مخصص بلفظ ثابت ليوم عرفة', ['arafah']),
  ];

  String tr(String key) {
    return ui[lang]?[key] ?? ui['ar']![key]!;
  }

  String categoryName(_Dua dua) {
    return tr(dua.category);
  }

  String attributionName(_Dua dua) {
    if (lang == 'ar') {
      return dua.attribution;
    }

    if (dua.attribution.startsWith('قرآني')) {
      return lang == 'en'
          ? 'Quranic'
          : 'قرآنی';
    }

    if (dua.attribution.startsWith('غير ثابت')) {
      return lang == 'en'
          ? 'Not established specifically for this occasion'
          : 'اس موقع کے لیے مخصوص طور پر ثابت نہیں';
    }

    if (dua.attribution.startsWith('مأثور') ||
        dua.attribution.startsWith('أذكار مأثورة')) {
      return lang == 'en'
          ? 'Reported supplication'
          : 'ماثور دعا';
    }

    return lang == 'en'
        ? 'General supplication'
        : 'عام دعا';
  }

  bool isRelevant(_Dua dua) {
    final key = widget.stepKey;

    if (dua.steps.contains(key)) {
      return true;
    }

    if (key == 'umrah_tawaf' &&
        dua.steps.contains('tawaf')) {
      return true;
    }

    if (key == 'umrah_sai' &&
        dua.steps.contains('sai')) {
      return true;
    }

    // الأدعية القرآنية والمأثورة العامة متاحة في كل مرحلة.
    // لا يعني ذلك تخصيصها لهذه الشعيرة شرعًا.
    if (dua.category == 'quran' || dua.category == 'hadith') {
      return true;
    }

    // الأدعية العامة ليست أذكارًا ثابتة مخصوصة بالشعيرة.
    if (dua.category == 'general') {
      return true;
    }

    return false;
  }

  List<_Dua> get visiblePrayers {
    final query = _search.text.trim().toLowerCase();

    return prayers.where((dua) {
      final selected = _category == 'all' ||
          (_category == 'relevant'
              ? isRelevant(dua)
              : dua.category == _category);

      if (!selected) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      return dua.title.toLowerCase().contains(query) ||
          dua.arabic.toLowerCase().contains(query) ||
          (duaTranslations[dua.id]?[lang]?.toLowerCase().contains(query) ?? false) ||
          categoryName(dua).toLowerCase().contains(query) ||
          dua.attribution.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    if (widget.stepKey.isEmpty) {
      _category = 'all';
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // Meanings in English and Urdu. Keep original Arabic supplications unchanged.
  static const Map<String, Map<String, String>> duaTranslations = {
    'leave': {
      'en': 'I entrust you to Allah, whose trusts are never lost.',
      'ur': 'میں تمہیں اللہ کے سپرد کرتا ہوں، جس کے سپرد کی ہوئی چیزیں کبھی ضائع نہیں ہوتیں۔',
    },
    'travel': {
      'en': 'Allah is the Greatest, Allah is the Greatest, Allah is the Greatest. Glory be to the One who made this transport subject to us, for we could not have controlled it ourselves, and to our Lord we will return. O Allah, we ask You on this journey for righteousness, mindfulness of You and deeds that please You. Make this journey easy for us and shorten its distance. You are our Companion on the journey and the Guardian of our family. I seek refuge in You from the hardships of travel, distressing sights and an unhappy return concerning our wealth, family and children.',
      'ur': 'اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے۔ پاک ہے وہ ذات جس نے اس سواری کو ہمارے تابع کر دیا، ورنہ ہم اسے قابو میں نہ لا سکتے تھے، اور ہمیں اپنے رب ہی کی طرف لوٹنا ہے۔ اے اللہ! اس سفر میں ہم تجھ سے نیکی، تقویٰ اور پسندیدہ اعمال مانگتے ہیں۔ ہمارا سفر آسان اور اس کی مسافت مختصر فرما۔ سفر میں تو ہمارا ساتھی اور گھر والوں کا نگہبان ہے۔ سفر کی مشقت، رنجیدہ منظر اور مال، اہل و عیال کے متعلق بری واپسی سے تیری پناہ مانگتے ہیں۔',
    },
    'return': {
      'en': 'We return, repent, worship, and praise our Lord.',
      'ur': 'ہم لوٹنے والے، توبہ کرنے والے، عبادت کرنے والے اور اپنے رب کی حمد کرنے والے ہیں۔',
    },
    'talbiyah': {
      'en': 'Here I am, O Allah, here I am. You have no partner. All praise, blessings, and sovereignty belong to You. You have no partner.',
      'ur': 'حاضر ہوں اے اللہ، حاضر ہوں۔ تیرا کوئی شریک نہیں۔ سب تعریف، نعمت اور بادشاہی تیرے ہی لیے ہے، تیرا کوئی شریک نہیں۔',
    },
    'enter_mosque': {
      'en': 'I seek refuge in Allah the Magnificent, in His noble Face and His eternal authority, from Satan the accursed. In the name of Allah; blessings and peace be upon the Messenger of Allah. O Allah, forgive my sins and open for me the gates of Your mercy.',
      'ur': 'میں عظمت والے اللہ، اس کے بزرگی والے چہرے اور اس کے قدیم اقتدار کی پناہ مانگتا ہوں شیطان مردود سے۔ اللہ کے نام سے؛ رسول اللہ پر درود و سلام ہو۔ اے اللہ! میرے گناہ بخش دے اور میرے لیے اپنی رحمت کے دروازے کھول دے۔',
    },
    'see_kaaba': {
      'en': 'O Allah, increase this House in honor, greatness, dignity and awe. Increase the honor, dignity, greatness and goodness of those who honor it through Hajj or Umrah. O Allah, You are Peace and from You comes peace, so grant us life in peace.',
      'ur': 'اے اللہ! اس گھر کی عزت، عظمت، تکریم اور ہیبت میں اضافہ فرما۔ حج یا عمرہ کرنے والوں کی عزت، تکریم، عظمت اور نیکی میں اضافہ فرما۔ اے اللہ! تو سلامتی والا ہے اور سلامتی تجھی سے ہے، پس ہمیں سلامتی کی زندگی عطا فرما۔',
    },
    'corner': {
      'en': 'Our Lord, grant us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
      'ur': 'اے ہمارے رب! ہمیں دنیا میں بھلائی عطا فرما، آخرت میں بھلائی عطا فرما، اور آگ کے عذاب سے بچا۔',
    },
    'safa_verse': {
      'en': 'Indeed, Safa and Marwah are among the symbols of Allah. Whoever makes Hajj to the House or performs Umrah incurs no blame in going between them. Whoever willingly does good, Allah is Appreciative and Knowing. I begin with what Allah began with.',
      'ur': 'بے شک صفا اور مروہ اللہ کی نشانیوں میں سے ہیں۔ جو شخص بیت اللہ کا حج یا عمرہ کرے، اس پر ان دونوں کے درمیان سعی کرنے میں کوئی گناہ نہیں۔ جو اپنی خوشی سے نیکی کرے تو اللہ قدر دان اور علم والا ہے۔ میں اسی سے آغاز کرتا ہوں جس سے اللہ نے آغاز کیا۔',
    },
    'safa_dhikr': {
      'en': 'Allah is the Greatest, Allah is the Greatest, Allah is the Greatest. None is worthy of worship but Allah alone, without partner. His is the dominion and praise, and He has power over all things. None is worthy of worship but Allah alone. He fulfilled His promise, helped His servant and defeated the opposing groups by Himself.',
      'ur': 'اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے۔ اللہ کے سوا کوئی معبود برحق نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ بادشاہی اور تعریف اسی کی ہے اور وہ ہر چیز پر قادر ہے۔ اللہ کے سوا کوئی معبود برحق نہیں۔ اس نے اپنا وعدہ پورا کیا، اپنے بندے کی مدد کی اور مخالف گروہوں کو اکیلے شکست دی۔',
    },
    'arafah': {
      'en': 'There is no god worthy of worship except Allah alone, without partner. His is the dominion and His is all praise, and He has power over all things.',
      'ur': 'اللہ کے سوا کوئی معبود برحق نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ بادشاہی اور تعریف اسی کی ہے، اور وہ ہر چیز پر قادر ہے۔',
    },
    'q_baqarah': {
      'en': 'Our Lord, do not hold us accountable if we forget or make a mistake. Our Lord, do not place on us a burden like the one You placed on those before us. Our Lord, do not burden us with what we cannot bear. Pardon us, forgive us and have mercy on us. You are our Protector, so grant us victory over those who reject faith.',
      'ur': 'اے ہمارے رب! اگر ہم بھول جائیں یا غلطی کریں تو ہمارا مؤاخذہ نہ فرما۔ ہم پر وہ بوجھ نہ ڈال جو تو نے ہم سے پہلے لوگوں پر ڈالا تھا۔ ہمیں ہماری طاقت سے زیادہ ذمہ داری نہ دے۔ ہمیں معاف فرما، بخش دے اور رحم فرما۔ تو ہمارا کارساز ہے، پس منکروں کے مقابلے میں ہماری مدد فرما۔',
    },
    'q_ghafir': {
      'en': 'Our Lord, You encompass all things in mercy and knowledge. Forgive those who repent and follow Your way, and protect them from the punishment of the Fire. Admit them to the everlasting gardens You promised them, along with their righteous parents, spouses and descendants. You are the Almighty, the Wise. Protect them from evil deeds; whoever You protect from evil on that Day has received Your mercy, and that is the great success.',
      'ur': 'اے ہمارے رب! تیری رحمت اور علم ہر چیز کو گھیرے ہوئے ہیں۔ جو توبہ کریں اور تیرے راستے پر چلیں انہیں بخش دے اور دوزخ کے عذاب سے بچا۔ انہیں ہمیشہ رہنے والی جنتوں میں داخل کر جن کا تو نے وعدہ کیا ہے، اور ان کے نیک والدین، شریکِ حیات اور اولاد کو بھی۔ بے شک تو غالب اور حکمت والا ہے۔ انہیں برائیوں سے محفوظ رکھ؛ جسے تو اس دن برائی سے بچائے گا اس پر رحم فرمائے گا، اور یہی بڑی کامیابی ہے۔',
    },
    'q_imran': {
      'en': 'Our Lord, You did not create all this without purpose. Glory be to You; protect us from the Fire. Our Lord, whoever You admit to the Fire You have disgraced, and wrongdoers have no helpers. We heard a caller calling us to faith, “Believe in your Lord,” and we believed. Forgive our sins, remove our misdeeds and let us die among the righteous. Grant us what You promised through Your messengers and do not disgrace us on the Day of Resurrection. You never break Your promise.',
      'ur': 'اے ہمارے رب! تو نے یہ سب بے مقصد پیدا نہیں کیا۔ تو پاک ہے، ہمیں آگ کے عذاب سے بچا۔ جسے تو آگ میں ڈالے وہ رسوا ہوا اور ظالموں کا کوئی مددگار نہیں۔ ہم نے ایمان کی دعوت دینے والے کو سنا اور ایمان لے آئے۔ ہمارے گناہ بخش دے، برائیاں مٹا دے اور ہمیں نیک لوگوں کے ساتھ وفات دے۔ اپنے رسولوں کے ذریعے کیا ہوا وعدہ ہمیں عطا فرما اور قیامت کے دن رسوا نہ کرنا۔ بے شک تو وعدہ خلافی نہیں کرتا۔',
    },
    'q_world': {
      'en': 'Our Lord, grant us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
      'ur': 'اے ہمارے رب! ہمیں دنیا اور آخرت میں بھلائی عطا فرما اور آگ کے عذاب سے بچا۔',
    },
    'q_patience': {
      'en': 'Our Lord, pour patience upon us, make our feet firm, and grant us victory.',
      'ur': 'اے ہمارے رب! ہم پر صبر نازل فرما، ہمارے قدم ثابت رکھ اور ہمیں فتح عطا فرما۔',
    },
    'q_forgive': {
      'en': 'Our Lord, forgive our sins and our excesses in our affairs, make our feet firm and grant us victory over those who reject faith.',
      'ur': 'اے ہمارے رب! ہمارے گناہ اور ہمارے کاموں میں زیادتیاں معاف فرما، ہمارے قدم جما دے اور منکروں کے مقابلے میں ہماری مدد فرما۔',
    },
    'q_adam': {
      'en': 'Our Lord, we have wronged ourselves. If You do not forgive us and have mercy on us, we will surely be among the losers.',
      'ur': 'اے ہمارے رب! ہم نے اپنی جانوں پر ظلم کیا۔ اگر تو ہمیں معاف نہ کرے اور رحم نہ فرمائے تو ہم خسارہ پانے والوں میں سے ہوں گے۔',
    },
    'q_prayer': {
      'en': 'My Lord, make me one who establishes prayer, and also from my descendants. Our Lord, accept my supplication. Our Lord, forgive me, my parents and the believers on the Day of Reckoning.',
      'ur': 'اے میرے رب! مجھے نماز قائم کرنے والا بنا اور میری اولاد میں سے بھی۔ اے ہمارے رب! میری دعا قبول فرما۔ حساب کے دن مجھے، میرے والدین اور ایمان والوں کو بخش دے۔',
    },
    'q_kahf': {
      'en': 'Our Lord, grant us mercy from Yourself and guide us rightly in our affair.',
      'ur': 'اے ہمارے رب! ہمیں اپنے پاس سے رحمت عطا فرما اور ہمارے معاملے میں درست رہنمائی عطا فرما۔',
    },
    'q_muminun': {
      'en': 'Our Lord, we have believed, so forgive us and have mercy on us. You are the best of those who show mercy.',
      'ur': 'اے ہمارے رب! ہم ایمان لے آئے، ہمیں بخش دے اور رحم فرما، اور تو سب رحم کرنے والوں سے بہتر ہے۔',
    },
    'q_brothers': {
      'en': 'Our Lord, forgive us and our brothers and sisters who preceded us in faith. Do not put resentment in our hearts toward those who believe. Our Lord, You are Compassionate and Merciful.',
      'ur': 'اے ہمارے رب! ہمیں اور ہمارے ان بھائیوں کو بخش دے جو ایمان میں ہم سے پہلے گزرے، اور ایمان والوں کے لیے ہمارے دلوں میں کوئی کینہ نہ رکھ۔ بے شک تو نہایت شفقت کرنے والا، مہربان ہے۔',
    },
    'q_tawakkul': {
      'en': 'Our Lord, in You we place our trust, to You we turn in repentance, and to You is the final return.',
      'ur': 'اے ہمارے رب! ہم نے تجھ ہی پر بھروسا کیا، تیری ہی طرف رجوع کیا اور تیری ہی طرف لوٹنا ہے۔',
    },
    'q_mumtahana': {
      'en': 'Our Lord, do not make us a trial for those who disbelieve, and forgive us. Our Lord, You are the Almighty, the Wise.',
      'ur': 'اے ہمارے رب! ہمیں منکروں کے لیے آزمائش نہ بنا اور ہمیں بخش دے۔ بے شک تو غالب اور حکمت والا ہے۔',
    },
    'afiyah': {
      'en': 'O Allah, I ask You for pardon and well-being in my religion, worldly life, family and wealth. Conceal my faults and calm my fears. Protect me from in front, behind, my right, my left and above. I seek refuge in Your greatness from being harmed from below.',
      'ur': 'اے اللہ! میں اپنے دین، دنیا، اہل و عیال اور مال میں معافی اور عافیت مانگتا ہوں۔ میری پردہ پوشی فرما اور میرے خوف کو امن میں بدل دے۔ آگے، پیچھے، دائیں، بائیں اور اوپر سے حفاظت فرما۔ اور نیچے سے اچانک ہلاک کیے جانے سے تیری عظمت کی پناہ مانگتا ہوں۔',
    },
    'body': {
      'en': 'O Allah, grant health to my body, my hearing and my sight. There is no deity worthy of worship but You.',
      'ur': 'اے اللہ! میرے جسم، سماعت اور بینائی کو عافیت عطا فرما۔ تیرے سوا کوئی معبود برحق نہیں۔',
    },
    'poverty': {
      'en': 'O Allah, I seek refuge in You from disbelief and poverty, and from the punishment of the grave. There is no deity worthy of worship but You.',
      'ur': 'اے اللہ! میں کفر اور محتاجی سے، اور قبر کے عذاب سے تیری پناہ مانگتا ہوں۔ تیرے سوا کوئی معبود برحق نہیں۔',
    },
    'istighfar': {
      'en': 'O Allah, You are my Lord; none is worthy of worship but You. You created me and I am Your servant. I remain faithful to Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favors upon me and confess my sins, so forgive me, for none forgives sins but You.',
      'ur': 'اے اللہ! تو میرا رب ہے، تیرے سوا کوئی معبود برحق نہیں۔ تو نے مجھے پیدا کیا اور میں تیرا بندہ ہوں۔ اپنی استطاعت کے مطابق تیرے عہد اور وعدے پر قائم ہوں۔ اپنے اعمال کی برائی سے تیری پناہ مانگتا ہوں۔ مجھ پر تیری نعمتوں اور اپنے گناہوں کا اقرار کرتا ہوں، پس مجھے بخش دے، کیونکہ تیرے سوا کوئی گناہ معاف نہیں کر سکتا۔',
    },
    'worry': {
      'en': 'O Allah, I seek refuge in You from worry and grief, inability and laziness, cowardice and miserliness, overwhelming debt and being overpowered by people.',
      'ur': 'اے اللہ! میں فکر اور غم، بے بسی اور سستی، بزدلی اور کنجوسی، قرض کے غلبے اور لوگوں کے دباؤ سے تیری پناہ مانگتا ہوں۔',
    },
    'soul': {
      'en': 'O Allah, grant my soul its mindfulness of You and purify it. You are the best to purify it; You are its Guardian and Master.',
      'ur': 'اے اللہ! میرے نفس کو تقویٰ عطا فرما اور اسے پاک کر، تو ہی اسے سب سے بہتر پاک کرنے والا ہے۔ تو اس کا سرپرست اور مالک ہے۔',
    },
    'knowledge': {
      'en': 'O Allah, I seek refuge in You from knowledge that does not benefit, a heart that is not humble, a soul that is never satisfied, and supplication that is not answered.',
      'ur': 'اے اللہ! میں بے فائدہ علم، نہ جھکنے والے دل، کبھی نہ بھرنے والے نفس اور قبول نہ ہونے والی دعا سے تیری پناہ مانگتا ہوں۔',
    },
    'blessing': {
      'en': 'O Allah, I seek refuge in You from the loss of Your blessings, a change in the well-being You grant, the sudden coming of Your punishment and all that incurs Your displeasure.',
      'ur': 'اے اللہ! تیری نعمت کے زوال، عطا کی ہوئی عافیت کے بدل جانے، اچانک سزا آنے اور تیری ہر ناراضی سے تیری پناہ مانگتا ہوں۔',
    },
    'religion': {
      'en': 'O Allah, set right my religion, which safeguards my affairs; set right my worldly life, in which I live; and set right my Hereafter, to which I return. Make life an increase in every good for me and death a rest from every evil.',
      'ur': 'اے اللہ! میرے دین کو درست فرما جو میرے معاملات کی حفاظت ہے، میری دنیا درست فرما جس میں میری زندگی ہے، اور میری آخرت درست فرما جس کی طرف مجھے لوٹنا ہے۔ زندگی کو میرے لیے ہر بھلائی میں اضافے کا ذریعہ اور موت کو ہر برائی سے راحت بنا۔',
    },
    'steadfast': {
      'en': 'O Allah, I ask You for steadfastness in my affairs and determination upon right guidance. Help me thank You for Your blessings and worship You well. Grant me a sound heart and a truthful tongue. I ask for the good known to You, seek refuge from the evil known to You and ask forgiveness for what You know. You know all that is unseen.',
      'ur': 'اے اللہ! میں معاملات میں ثابت قدمی اور ہدایت پر پختہ ارادہ مانگتا ہوں۔ تیری نعمتوں کا شکر اور اچھی عبادت کی توفیق دے۔ پاک دل اور سچی زبان عطا فرما۔ جو بھلائی تیرے علم میں ہے وہ مانگتا ہوں، جو برائی تیرے علم میں ہے اس سے پناہ چاہتا ہوں، اور جو کچھ تو جانتا ہے اس کی معافی مانگتا ہوں۔ تو غیب کا خوب جاننے والا ہے۔',
    },
    'righteous': {
      'en': 'O Allah, I ask You to enable me to do good deeds, avoid wrongdoing and love the poor; forgive me and have mercy on me. If You decree a trial for Your servants, take me to Yourself without being led astray by it.',
      'ur': 'اے اللہ! مجھے نیک کام کرنے، برائی چھوڑنے اور مسکینوں سے محبت کی توفیق دے، مجھے بخش دے اور رحم فرما۔ اگر تو اپنے بندوں پر آزمائش لائے تو مجھے اس میں گمراہ ہونے سے محفوظ رکھ۔',
    },
    'love': {
      'en': 'O Allah, I ask You for Your love, the love of those who love You, and the love of every deed that brings me closer to Your love.',
      'ur': 'اے اللہ! میں تیری محبت، تجھ سے محبت کرنے والوں کی محبت اور ہر اس عمل کی محبت مانگتا ہوں جو مجھے تیری محبت کے قریب کرے۔',
    },
    'heart': {
      'en': 'O Turner of hearts, keep my heart firm upon Your religion.',
      'ur': 'اے دلوں کو پھیرنے والے! میرے دل کو اپنے دین پر ثابت رکھ۔',
    },
    'obedience': {
      'en': 'O Allah, Controller of hearts, turn our hearts toward obedience to You.',
      'ur': 'اے دلوں کو پھیرنے والے اللہ! ہمارے دلوں کو اپنی اطاعت کی طرف پھیر دے۔',
    },
    'fear': {
      'en': 'O Allah, grant us such fear of You that it keeps us from disobeying You, such obedience that brings us to Your Paradise, and such certainty that makes worldly troubles easier. Let us benefit from our hearing, sight and strength throughout our lives and preserve them for us. Let us stand against those who wrong us and grant victory over those who oppose us. Do not make worldly life our greatest concern or the limit of our knowledge, nor make our religious life the source of our calamity. Do not put over us, because of our sins, anyone who does not fear You or show us mercy.',
      'ur': 'اے اللہ! ہمیں اپنا ایسا خوف عطا فرما جو نافرمانی سے روکے، ایسی اطاعت جو جنت تک پہنچائے، اور ایسا یقین جو دنیا کی مصیبتوں کو آسان کرے۔ ہماری زندگی بھر سماعت، بصارت اور قوت سے ہمیں فائدہ دے اور یہ نعمتیں باقی رکھ۔ جو ہم پر ظلم کرے اس کے مقابلے میں انصاف عطا فرما اور دشمنوں پر مدد فرما۔ دنیا کو ہمارا سب سے بڑا غم یا علم کی حد نہ بنا، اور دین میں مصیبت نہ دے۔ ہمارے گناہوں کے سبب ہم پر ایسے لوگوں کو مسلط نہ کر جو تجھ سے نہ ڈریں اور ہم پر رحم نہ کریں۔',
    },
    'calamity': {
      'en': 'O Allah, I seek refuge in You from severe trials, being overtaken by misery, an evil decree and the gloating of enemies.',
      'ur': 'اے اللہ! میں سخت آزمائش، بدبختی، بری تقدیر کے اثرات اور دشمنوں کی خوشی سے تیری پناہ مانگتا ہوں۔',
    },
    'guidance': {
      'en': 'O Allah, guide me to the best deeds and character, for none guides to the best of them but You. Keep bad deeds and character away from me, for none can keep them away but You.',
      'ur': 'اے اللہ! مجھے بہترین اعمال اور اخلاق کی ہدایت دے، تیرے سوا کوئی ان کی ہدایت نہیں دے سکتا؛ اور برے اعمال اور اخلاق مجھ سے دور کر، تیرے سوا کوئی انہیں دور نہیں کر سکتا۔',
    },
    'evil': {
      'en': 'O Allah, I seek refuge in You from the evil of what I have done and the evil of what I have not done.',
      'ur': 'اے اللہ! میں اپنے کیے ہوئے اور نہ کیے ہوئے اعمال کی برائی سے تیری پناہ مانگتا ہوں۔',
    },
    'help': {
      'en': 'My Lord, help me and do not aid anyone against me. Grant me victory and do not grant victory over me. Guide me and make guidance easy for me; help me against whoever wrongs me. Make me grateful to You, mindful of You, reverent toward You, obedient, humble and constantly returning to You. Accept my repentance, cleanse my sins, answer my supplication, strengthen my proof, guide my speech and heart, and remove resentment from my chest.',
      'ur': 'اے میرے رب! میری مدد فرما اور میرے خلاف کسی کی مدد نہ کر۔ مجھے کامیابی دے اور کسی کو مجھ پر غالب نہ کر۔ مجھے ہدایت دے اور ہدایت آسان کر، جو ظلم کرے اس کے مقابلے میں مدد فرما۔ مجھے اپنا شکر کرنے والا، ذکر کرنے والا، خوف رکھنے والا، فرمانبردار، عاجز اور تیری طرف رجوع کرنے والا بنا۔ میری توبہ قبول فرما، گناہ دھو دے، دعا قبول فرما، دلیل مضبوط کر، زبان اور دل کو سیدھا کر اور سینے سے کینہ نکال دے۔',
    },
    'day': {
      'en': 'O Allah, make the beginning of this day good, its middle successful and its end prosperous. I ask You for the good of this world and the Hereafter, O Most Merciful.',
      'ur': 'اے اللہ! اس دن کی ابتدا نیکی، درمیان کامیابی اور اختتام بھلائی والا بنا۔ اے سب سے زیادہ رحم کرنے والے! میں تجھ سے دنیا اور آخرت کی بھلائی مانگتا ہوں۔',
    },
    'pleasure': {
      'en': 'O Allah, I ask You for contentment after Your decree, a pleasant life after death, the delight of gazing upon Your noble Face and longing to meet You without harmful adversity or a misleading trial.',
      'ur': 'اے اللہ! میں تیرے فیصلے کے بعد رضا، موت کے بعد راحت، تیرے کریم چہرے کے دیدار کی لذت اور تجھ سے ملاقات کا شوق مانگتا ہوں، بغیر نقصان دہ مصیبت یا گمراہ کن آزمائش کے۔',
    },
    'house': {
      'en': 'O Allah, set right my religion, make my home spacious for me and bless my livelihood.',
      'ur': 'اے اللہ! میرا دین درست فرما، میرے گھر میں کشادگی دے اور میری روزی میں برکت عطا فرما۔',
    },
    'morals': {
      'en': 'O Allah, I seek refuge in You from hardness of heart, heedlessness, humiliation and destitution; and from disbelief, disobedience, discord, seeking fame and showing off.',
      'ur': 'اے اللہ! میں دل کی سختی، غفلت، ذلت اور محتاجی، اور کفر، نافرمانی، جھگڑے، نام و نمود اور دکھاوے سے تیری پناہ مانگتا ہوں۔',
    },
    'badtraits': {
      'en': 'O Allah, I seek refuge in You from bad character, actions, desires and illnesses; and from overwhelming debt, enemies gaining power over me and the gloating of enemies.',
      'ur': 'اے اللہ! میں برے اخلاق، اعمال، خواہشات اور بیماریوں، قرض کے غلبے، دشمن کے قابو پانے اور دشمنوں کی خوشی سے تیری پناہ مانگتا ہوں۔',
    },
    'forgiveness': {
      'en': 'O Allah, I ask You for all that brings Your mercy and firm forgiveness, success in every good, safety from every evil, entry into Paradise and rescue from the Fire.',
      'ur': 'اے اللہ! میں تیری رحمت اور مغفرت کے اسباب، ہر بھلائی کا حصہ، ہر برائی سے سلامتی، جنت میں کامیابی اور آگ سے نجات مانگتا ہوں۔',
    },
    'needs': {
      'en': 'O Allah, leave none of our sins unforgiven, none of our faults uncovered, none of our worries unrelieved, none of our debts unpaid, and none of our needs in this world or the next that please You and benefit us unmet, O Most Merciful.',
      'ur': 'اے اللہ! ہمارا کوئی گناہ بغیر بخشے، کوئی عیب بغیر چھپائے، کوئی غم بغیر دور کیے، کوئی قرض بغیر ادا کیے اور دنیا و آخرت کی کوئی ایسی حاجت جو تجھے پسند ہو اور ہمارے لیے بہتر ہو، بغیر پوری کیے نہ چھوڑ، اے سب سے زیادہ رحم کرنے والے۔',
    },
    'mercy': {
      'en': 'O Allah, I ask You for mercy from Yourself to guide my heart, put my affairs in order, restore what is scattered, safeguard those absent from me, raise my standing, brighten my face, purify my deeds, inspire me with right guidance, turn trials away from me and protect me from every evil.',
      'ur': 'اے اللہ! میں تجھ سے ایسی رحمت مانگتا ہوں جو میرے دل کو ہدایت دے، معاملات درست کرے، بکھرے کام سنوارے، غائب عزیزوں کی حفاظت کرے، مقام بلند کرے، چہرہ روشن کرے، اعمال پاک کرے، درست رہنمائی دے، فتنوں کو دور کرے اور ہر برائی سے بچائے۔',
    },
    'faith': {
      'en': 'O Allah, I ask You for health with faith, faith with good character, success followed by lasting prosperity, and Your mercy, well-being, forgiveness and pleasure.',
      'ur': 'اے اللہ! میں ایمان کے ساتھ صحت، اچھے اخلاق کے ساتھ ایمان، کامیابی کے بعد بھلائی، اور تیری رحمت، عافیت، مغفرت اور رضا مانگتا ہوں۔',
    },
    'chastity': {
      'en': 'O Allah, I ask You for health, chastity, good character and contentment with Your decree. I seek refuge in You from the evil of my own soul and every creature under Your control. Truly, my Lord is on a straight path.',
      'ur': 'اے اللہ! میں صحت، پاک دامنی، اچھے اخلاق اور تیری تقدیر پر رضا مانگتا ہوں۔ اپنے نفس اور ہر اس مخلوق کی برائی سے پناہ مانگتا ہوں جو تیرے اختیار میں ہے۔ بے شک میرا رب سیدھے راستے پر ہے۔',
    },
    'consequence': {
      'en': 'O Allah, grant us a good outcome in every matter and protect us from disgrace in this world and punishment in the Hereafter.',
      'ur': 'اے اللہ! ہمارے ہر معاملے کا انجام اچھا فرما اور دنیا کی رسوائی اور آخرت کے عذاب سے بچا۔',
    },
    'children': {
      'en': 'O Allah, we ask You to make our children righteous and healthy, to help them memorize Your noble Book and act upon it and the Sunnah of Your trustworthy Prophet. Grant them good companions who remind them when they forget, alert them when they are heedless, teach them when they do not know and guide them when they stray.',
      'ur': 'اے اللہ! ہماری اولاد کو نیک اور تندرست بنا۔ انہیں تیری کتاب یاد کرنے، اس پر اور تیرے نبی کی سنت پر عمل کرنے کی توفیق دے۔ انہیں ایسے نیک ساتھی عطا فرما جو بھولنے پر یاد دلائیں، غفلت میں متنبہ کریں، لاعلمی میں سکھائیں اور بھٹکنے پر رہنمائی کریں۔',
    },
    'love_more': {
      'en': 'O Allah, make Your love dearer to me than myself, my family, wealth and children, and than cool water to a thirsty person. Make me beloved to You, Your angels, Your prophets and all Your creation.',
      'ur': 'اے اللہ! اپنی محبت مجھے اپنی جان، خاندان، مال، اولاد اور پیاس میں ٹھنڈے پانی سے بھی زیادہ محبوب بنا۔ مجھے اپنا، اپنے فرشتوں، نبیوں اور تمام مخلوق کا محبوب بنا دے۔',
    },
    'ease': {
      'en': 'O Allah, Reliever of anxiety, Remover of sorrow and Answerer of those in distress, Most Merciful in this world and the next, have mercy on me with a mercy that makes me independent of anyone else’s mercy.',
      'ur': 'اے اللہ! فکر دور کرنے والے، غم مٹانے والے، بے قرار کی دعا قبول کرنے والے، دنیا و آخرت کے نہایت رحم کرنے والے! مجھ پر ایسی رحمت فرما کہ میں دوسروں کی رحمت سے بے نیاز ہو جاؤں۔',
    },
    'reliance': {
      'en': 'O Allah, do not leave us to ourselves, lest we become helpless, or to other people, lest we be lost.',
      'ur': 'اے اللہ! ہمیں ہمارے نفس کے حوالے نہ کر کہ ہم بے بس ہو جائیں، نہ لوگوں کے حوالے کر کہ ہم بھٹک جائیں۔',
    },
    'beauty': {
      'en': 'O Allah, make my affairs beautiful for as long as I live, grant me well-being as long as You sustain me, bless what You have entrusted to me and preserve the favors You have given me.',
      'ur': 'اے اللہ! جب تک مجھے زندگی دے میرے معاملات سنوار، جب تک زندہ رکھ عافیت دے، جو کچھ عطا کیا اس میں برکت دے اور اپنی دی ہوئی نعمتوں کی حفاظت فرما۔',
    },
    'piety': {
      'en': 'O Allah, make me fear You as if I see You, make me happy through mindfulness of You, do not cast me away because of disobedience, make me content with Your decree and bless what You have destined for me.',
      'ur': 'اے اللہ! مجھے اپنا ایسا خوف عطا فرما گویا میں تجھے دیکھ رہا ہوں، اپنے تقویٰ سے خوش رکھ، نافرمانی کی وجہ سے دور نہ کر، اپنے فیصلے پر راضی کر اور میری تقدیر میں برکت دے۔',
    },
    'wellness': {
      'en': 'O Allah, clothe me in well-being so that life is pleasant, grant me forgiveness at the end so that my sins do not harm me, and protect me from every terror before Paradise until You admit me by Your mercy, O Most Merciful.',
      'ur': 'اے اللہ! مجھے ایسی عافیت عطا فرما کہ زندگی خوشگوار ہو، آخر میں مغفرت دے تاکہ گناہ مجھے نقصان نہ پہنچائیں، اور جنت تک پہنچنے سے پہلے ہر خوف سے بچا، اے سب سے زیادہ رحم کرنے والے۔',
    },
    'q_musa': {
      'en': 'My Lord, expand my chest and make my task easy for me.',
      'ur': 'اے میرے رب! میرا سینہ کھول دے اور میرا کام آسان فرما۔',
    },
    'q_ilm': {
      'en': 'My Lord, increase me in knowledge.',
      'ur': 'اے میرے رب! میرے علم میں اضافہ فرما۔',
    },
    'q_yunus': {
      'en': 'There is no god worthy of worship but You. Glory be to You! Indeed, I was among the wrongdoers.',
      'ur': 'تیرے سوا کوئی معبود برحق نہیں، تو پاک ہے! بے شک میں ظالموں میں سے تھا۔',
    },
    'q_ayub': {
      'en': 'Harm has touched me, and You are the Most Merciful of the merciful.',
      'ur': 'مجھے تکلیف پہنچی ہے اور تو سب رحم کرنے والوں سے بڑھ کر رحم کرنے والا ہے۔',
    },
    'q_nuh': {
      'en': 'My Lord, forgive me, my parents, whoever enters my home as a believer, and all believing men and women.',
      'ur': 'اے میرے رب! مجھے، میرے والدین، میرے گھر میں ایمان کے ساتھ داخل ہونے والوں اور تمام مومن مردوں اور عورتوں کو بخش دے۔',
    },
    'q_family': {
      'en': 'Our Lord, grant us comfort to our eyes in our spouses and descendants, and make us examples for the mindful.',
      'ur': 'اے ہمارے رب! ہماری بیویوں اور اولاد کو ہماری آنکھوں کی ٹھنڈک بنا اور ہمیں پرہیزگاروں کا پیشوا بنا۔',
    },
    'q_mercy': {
      'en': 'Our Lord, do not let our hearts deviate after You have guided us, and grant us mercy from Yourself. Truly You are the Ever-Giving.',
      'ur': 'اے ہمارے رب! ہدایت دینے کے بعد ہمارے دل ٹیڑھے نہ ہونے دے، اور اپنے پاس سے ہمیں رحمت عطا فرما۔ بے شک تو بہت عطا کرنے والا ہے۔',
    },
    'q_accept': {
      'en': 'Our Lord, accept from us. Surely You are the All-Hearing, the All-Knowing.',
      'ur': 'اے ہمارے رب! ہماری طرف سے قبول فرما۔ بے شک تو خوب سننے والا، خوب جاننے والا ہے۔',
    },
    'dhikr_takbir': {
      'en': 'Allah is the Greatest.',
      'ur': 'اللہ سب سے بڑا ہے۔',
    },
    'dua_mina': {
      'en': 'O Allah, help us remember You, thank You and worship You well. Accept our Hajj and forgive us, our parents and all believers.',
      'ur': 'اے اللہ! اپنے ذکر، شکر اور اچھی عبادت میں ہماری مدد فرما۔ ہمارا حج قبول کر اور ہمیں، ہمارے والدین اور تمام مومنوں کو بخش دے۔',
    },
    'dua_muzdalifah': {
      'en': 'O Allah, guide us and make our rites easy for us; help us remember You, thank You and worship You well.',
      'ur': 'اے اللہ! ہمیں ہدایت دے، ہمارے مناسک آسان فرما، اور اپنے ذکر، شکر اور اچھی عبادت میں مدد فرما۔',
    },
    'dua_arafah_general': {
      'en': 'O Allah, forgive us, have mercy on us, accept our repentance, free us from the Fire, and accept our repentance and supplications.',
      'ur': 'اے اللہ! ہمیں بخش دے، ہم پر رحم فرما، ہماری توبہ قبول فرما، ہمیں آگ سے نجات دے، اور ہماری توبہ اور دعا قبول فرما۔',
    },
  };

  Widget soundButton(String text, {String language = 'ar'}) {
    return IconButton(
      tooltip: tr('read'),
      onPressed: () {
        TtsService.speak(
          text,
          language: language,
        );
      },
      icon: const Icon(
        Icons.volume_up_rounded,
        color: AppStyle.green,
      ),
    );
  }

  Widget prayerCard(_Dua dua) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: AppStyle.gold,
          width: 1.3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  color: AppStyle.green,
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    dua.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.green,
                    ),
                  ),
                ),

                soundButton(dua.arabic),
              ],
            ),

            const SizedBox(height: 7),

            Text(
              '${categoryName(dua)} • '
                  '${attributionName(dua)}',
              style: const TextStyle(
                color: AppStyle.green,
                fontSize: 12,
              ),
            ),

            const Divider(
              color: AppStyle.gold,
            ),

            Directionality(
              textDirection: TextDirection.rtl,
              child: SelectableText(
                dua.arabic,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 19,
                  height: 2,
                  color: AppStyle.text,
                ),
              ),
            ),
            if (lang != 'ar' &&
                duaTranslations[dua.id]?[lang] != null) ...[
              const SizedBox(height: 12),
              const Divider(color: AppStyle.gold),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lang == 'ur' ? 'اردو ترجمہ' : 'English translation',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppStyle.green,
                      ),
                    ),
                  ),
                  soundButton(
                    duaTranslations[dua.id]![lang]!,
                    language: lang,
                  ),
                ],
              ),
              Directionality(
                textDirection: lang == 'ur'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: SelectableText(
                  duaTranslations[dua.id]![lang]!,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: AppStyle.text,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageNotifier,
      builder: (context, current, _) {
        final filtered = visiblePrayers;

        final categories = <String>[
          if (widget.stepKey.isNotEmpty) 'relevant',
          'all',
          'travel',
          'ihram',
          'haram',
          'tawaf',
          'sai',
          'arafah',
          'quran',
          'hadith',
          'general',
        ];

        return Directionality(
          textDirection: lang == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppStyle.cream,
            appBar: AppBar(
              title: Text(tr('title')),
              centerTitle: true,
              backgroundColor: AppStyle.green,
              foregroundColor: Colors.white,
            ),

            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 850,
                ),

                child: Column(
                  children: [
                    // البحث
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        14,
                        12,
                        14,
                        6,
                      ),
                      child: TextField(
                        controller: _search,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: tr('search'),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppStyle.green,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    // أقسام الأدعية
                    SizedBox(
                      height: 54,
                      child: ListView(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        children: categories.map((category) {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            child: ChoiceChip(
                              label: Text(tr(category)),
                              selected:
                              _category == category,
                              selectedColor:
                              AppStyle.gold,
                              onSelected: (_) {
                                setState(() {
                                  _category = category;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // عرض الأدعية
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          14,
                          7,
                          14,
                          24,
                        ),
                        children: [
                          Container(
                            padding:
                            const EdgeInsets.all(12),
                            margin:
                            const EdgeInsets.only(
                              bottom: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(12),
                              border: Border.all(
                                color: AppStyle.gold,
                              ),
                            ),
                            child: Text(
                              tr('notice'),
                              style: const TextStyle(
                                color: AppStyle.green,
                                height: 1.6,
                              ),
                            ),
                          ),

                          if (filtered.isEmpty)
                            Padding(
                              padding:
                              const EdgeInsets.all(24),
                              child: Center(
                                child: Text(
                                  tr('empty'),
                                ),
                              ),
                            ),

                          ...filtered.map(prayerCard),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
