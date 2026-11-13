
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';

class HajjRulingsSection extends StatelessWidget {
  final String stepKey;
  final String hajjType;

  const HajjRulingsSection({
    super.key,
    required this.stepKey,
    required this.hajjType,
  });

  String get lang {
    final current = AppLanguage.currentLanguage;
    return ['ar', 'en', 'ur'].contains(current)
        ? current
        : 'ar';
  }

  String translate(
      String arabic,
      String english,
      String urdu,
      ) {
    if (lang == 'en') return english;
    if (lang == 'ur') return urdu;
    return arabic;
  }

  bool get isTamattu => hajjType == 'tamattu';
  bool get isQiran => hajjType == 'qiran';
  bool get isIfrad => hajjType == 'ifrad';
  bool get isGeneral => hajjType == 'general';

  String get pillarTitle => translate(
    'الأركان',
    'Pillars',
    'ارکان',
  );

  String get obligatoryTitle => translate(
    'الواجبات',
    'Obligations',
    'واجبات',
  );

  String get sunnahTitle => translate(
    'السنن والمستحبات',
    'Sunnah and Recommended Acts',
    'سنن اور مستحبات',
  );

  String get differencesTitle => translate(
    'اختلاف الأحكام بحسب نوع الحج',
    'Differences by Hajj Type',
    'حج کی قسم کے مطابق فرق',
  );

  String get noPillar => translate(
    'لا يوجد ركن مستقل في هذه الخطوة.',
    'There is no separate pillar in this step.',
    'اس مرحلے میں الگ رکن نہیں ہے۔',
  );

  String get noObligation => translate(
    'لا يوجد واجب مستقل في هذه الخطوة ضمن هذا التصنيف.',
    'There is no separate obligation listed for this step.',
    'اس مرحلے میں الگ واجب درج نہیں ہے۔',
  );

  String get generalNote => translate(
    'هذا تصنيف تعليمي وفق قول فقهي مشهور، وتوجد تفاصيل وخلافات ورخص للأعذار. ترك الركن يختلف حكمه عن ترك الواجب أو السنة، فلا يُحكم على صحة الحج من علامة الإنجاز داخل التطبيق.',
    'This is an educational classification based on a widely followed legal view. Details, scholarly differences and concessions exist. The app cannot determine Hajj validity from completion markers.',
    'یہ ایک معروف فقہی قول کے مطابق تعلیمی تقسیم ہے۔ بعض مسائل میں اختلاف اور عذر کی رعایتیں ہیں۔ ایپ کی گنتی حج کی صحت کی تصدیق نہیں کرتی۔',
  );

  String get pillar {
    switch (stepKey) {
      case 'umrah_ihram':
        return translate(
          'نية الدخول في العمرة ركن من أركان العمرة.',
          'Intention to enter Umrah is a pillar of Umrah.',
          'عمرے کی نیت عمرے کا رکن ہے۔',
        );

      case 'umrah_tawaf':
        return translate(
          'طواف العمرة ركن من أركان العمرة، وهو سبعة أشواط.',
          'Umrah Tawaf, seven circuits, is a pillar of Umrah.',
          'عمرے کے سات چکروں کا طواف عمرے کا رکن ہے۔',
        );

      case 'umrah_sai':
        return translate(
          'السعي بين الصفا والمروة ركن من أركان العمرة.',
          'Sai between Safa and Marwah is a pillar of Umrah.',
          'صفا و مروہ کی سعی عمرے کا رکن ہے۔',
        );

      case 'hajj_ihram':
      case 'ihram':
        return translate(
          'نية الدخول في الحج ركن من أركان الحج. ويختلف عن واجب الإحرام من الميقات.',
          'Intention to enter Hajj is a pillar. It is distinct from the obligation to enter Ihram at Miqat.',
          'حج کی نیت رکن ہے، جبکہ میقات سے احرام باندھنا الگ واجب ہے۔',
        );

      case 'arafah':
        return translate(
          'الوقوف داخل حدود عرفة في وقته الشرعي ركن من أركان الحج.',
          'Standing within Arafah during its prescribed time is a pillar of Hajj.',
          'مقررہ وقت میں عرفات کے اندر وقوف حج کا رکن ہے۔',
        );

      case 'ifadah':
        return translate(
          'طواف الإفاضة ركن من أركان الحج، ولا يغني عنه طواف القدوم.',
          'Tawaf Ifadah is a pillar of Hajj. Arrival Tawaf does not replace it.',
          'طواف افاضہ حج کا رکن ہے۔ طواف قدوم اس کا بدل نہیں۔',
        );

      case 'sai':
      case 'hajj_sai':
        return translate(
          'سعي الحج ركن وفق هذا التصنيف. للمتمتع سعي للحج غير سعي العمرة، أما المفرد والقارن فيكفيهما سعي واحد للحج إذا أدياه صحيحًا.',
          'Hajj Sai is a pillar under this classification. Tamattu requires a separate Hajj Sai; Ifrad and Qiran require one valid Hajj Sai.',
          'حج کی سعی اس تقسیم کے مطابق رکن ہے۔ تمتع میں حج کی الگ سعی ہوتی ہے؛ افراد اور قران میں ایک درست سعی کافی ہے۔',
        );

      default:
        return noPillar;
    }
  }

  String get obligation {
    switch (stepKey) {
      case 'umrah_ihram':
        return translate(
          'الإحرام للعمرة من الميقات المعتبر لمن يأتي من خارجه واجب.',
          'Entering Umrah Ihram at the applicable Miqat is obligatory for those approaching from outside.',
          'باہر سے آنے والوں کے لیے مقررہ میقات سے عمرے کا احرام واجب ہے۔',
        );

      case 'umrah_haircut':
        return translate(
          'الحلق أو التقصير من واجبات العمرة وفق هذا التصنيف.',
          'Shaving or trimming is an obligation of Umrah under this classification.',
          'اس تقسیم کے مطابق حلق یا قصر عمرے کا واجب ہے۔',
        );

      case 'ihram':
        return translate(
          'الإحرام من الميقات المعتبر واجب لمن يلزمه ذلك.',
          'Entering Ihram at the applicable Miqat is obligatory.',
          'مقررہ میقات سے احرام باندھنا واجب ہے۔',
        );

      case 'arafah':
        return translate(
          'البقاء بعرفة إلى غروب الشمس واجب على من وقف بها نهارًا وفق هذا التصنيف.',
          'For pilgrims who stand at Arafah by day, remaining until sunset is obligatory under this classification.',
          'دن میں عرفات پہنچنے والے کے لیے غروب تک قیام اس تقسیم کے مطابق واجب ہے۔',
        );

      case 'muzdalifah':
        return translate(
          'المبيت بمزدلفة واجب وفق هذا التصنيف، وتوجد رخص وشروط تتعلق بالوقت والأعذار.',
          'Staying in Muzdalifah is obligatory under this classification, with timing rules and concessions.',
          'مزدلفہ میں قیام واجب ہے، مگر وقت اور عذر کی رعایتیں موجود ہیں۔',
        );

      case 'aqabah':
        return translate(
          'رمي جمرة العقبة يوم النحر بسبع حصيات من واجبات الحج.',
          'Stoning Jamrat Aqabah with seven pebbles on the Day of Sacrifice is obligatory.',
          'یوم النحر کو جمرہ عقبہ پر سات کنکریاں مارنا واجب ہے۔',
        );

      case 'hady':
        if (isIfrad) {
          return translate(
            'لا يجب الهدي على المفرد لمجرد اختياره الإفراد، إلا إذا وُجد سبب آخر يوجبه.',
            'Ifrad alone does not require Hady unless another reason makes it obligatory.',
            'صرف حج افراد کی وجہ سے قربانی واجب نہیں، الا یہ کہ کوئی دوسری وجہ ہو۔',
          );
        }
        return translate(
          'الهدي واجب على المتمتع والقارن عند تحقق شروط الوجوب، ولمن لم يجده بدل شرعي بالصيام.',
          'Hady is required for eligible Tamattu and Qiran pilgrims. A prescribed fasting alternative exists when unable.',
          'شرائط پوری ہوں تو تمتع اور قران میں قربانی واجب ہے؛ عدم استطاعت پر شرعی روزوں کا بدل ہے۔',
        );

      case 'haircut':
        return translate(
          'الحلق أو التقصير من واجبات الحج وفق هذا التصنيف.',
          'Shaving or trimming is an obligation of Hajj under this classification.',
          'حلق یا قصر اس تقسیم کے مطابق حج کا واجب ہے۔',
        );

      case 'tashreeq':
        return translate(
          'رمي الجمرات الثلاث بالترتيب في الأيام المطلوبة، والمبيت بمنى ليالي التشريق، من الواجبات مع مراعاة الرخص والأعذار.',
          'Stoning the three Jamarat in order on the required days and staying in Mina during Tashreeq nights are obligations, subject to concessions.',
          'مقررہ دنوں میں ترتیب سے تینوں جمرات کی رمی اور منیٰ میں رات گزارنا واجبات میں شامل ہیں؛ عذر کی رعایتیں ہیں۔',
        );

      case 'farewell':
        return translate(
          'طواف الوداع واجب على من يلزمه عند مغادرة مكة، مع وجود استثناءات، ومنها الحائض والنفساء.',
          'Farewell Tawaf is obligatory when applicable, with exemptions including menstruating and postpartum women.',
          'مکہ سے روانگی پر طواف وداع واجب ہے جہاں لازم ہو؛ حائضہ اور نفاس والی خواتین کو استثنا ہے۔',
        );

      default:
        return noObligation;
    }
  }

  String get sunnah {
    switch (stepKey) {
      case 'umrah_ihram':
      case 'hajj_ihram':
      case 'ihram':
        return translate(
          'الاغتسال والتنظف قبل الإحرام والتلبية والإكثار من الذكر.',
          'Washing before Ihram, reciting Talbiyah and remembering Allah.',
          'احرام سے پہلے غسل، تلبیہ اور ذکر۔',
        );

      case 'umrah_tawaf':
      case 'arrival':
      case 'ifadah':
      case 'farewell':
        return translate(
          'الإكثار من الدعاء والذكر، ومن السنن الرمل والاضطباع في المواضع التي شُرعا فيها لمن شُرعا لهما، دون إيذاء الآخرين.',
          'Dua and remembrance. Raml and Idtiba are recommended where applicable, without harming others.',
          'ذکر اور دعا، اور جہاں مشروع ہو وہاں رمل اور اضطباع، دوسروں کو تکلیف دیے بغیر۔',
        );

      case 'umrah_sai':
      case 'sai':
      case 'hajj_sai':
        return translate(
          'الذكر والدعاء عند الصفا والمروة، والإسراع للرجال بين العلامتين حيث يُشرع ويتيسر.',
          'Dua and remembrance at Safa and Marwah; brisk walking for men between the markers when applicable.',
          'صفا و مروہ پر ذکر و دعا اور مردوں کے لیے مقررہ نشانوں کے درمیان تیز چلنا جہاں مناسب ہو۔',
        );

      case 'mina':
        return translate(
          'التوجه إلى منى يوم التروية والمبيت بها ليلة عرفة من السنن وفق هذا التصنيف، مع التلبية والذكر والصلاة.',
          'Traveling to Mina on Tarwiyah and staying before Arafah are recommended under this classification, along with prayer and Talbiyah.',
          'یوم الترویہ کو منیٰ جانا اور عرفہ سے پہلے قیام کرنا اس تقسیم کے مطابق سنت ہے۔',
        );

      case 'arafah':
        return translate(
          'الإكثار من الدعاء والذكر والتوبة مع الخشوع والرفق بالناس.',
          'Abundant dua, remembrance, repentance, humility and kindness.',
          'کثرت سے دعا، ذکر، توبہ اور عاجزی۔',
        );

      case 'muzdalifah':
        return translate(
          'الذكر والدعاء والسكينة، والمحافظة على السلامة واتباع التنظيم.',
          'Remembrance, dua, calmness and adherence to safety guidance.',
          'ذکر، دعا، سکون اور حفاظتی ہدایات پر عمل۔',
        );

      case 'aqabah':
      case 'tashreeq':
        return translate(
          'التكبير مع كل حصاة، والدعاء بعد الجمرة الصغرى والوسطى في مواضعه المشروعة.',
          'Takbir with each pebble and dua after the small and middle Jamarat where prescribed.',
          'ہر کنکری پر تکبیر، اور مقررہ مقامات پر چھوٹے اور درمیانی جمرے کے بعد دعا۔',
        );

      case 'haircut':
      case 'umrah_haircut':
        return translate(
          'الحلق أفضل للرجال من التقصير في الجملة، أما المرأة فتقصر ولا تحلق للنسك.',
          'Shaving is generally preferred for men; women trim rather than shave for the rite.',
          'مردوں کے لیے عموماً حلق افضل ہے، عورتیں قصر کرتی ہیں۔',
        );

      case 'hady':
        return translate(
          'الإحسان إلى المحتاجين والالتزام بالجهات المعتمدة للذبح.',
          'Kindness to those in need and use of authorized Hady services.',
          'ضرورت مندوں کے ساتھ احسان اور مجاز قربانی خدمات کا استعمال۔',
        );

      default:
        return translate(
          'الإكثار من الذكر والدعاء وشكر الله ومساعدة الآخرين.',
          'Remember Allah, make dua, give thanks and help others.',
          'ذکر، دعا، شکر اور دوسروں کی مدد۔',
        );
    }
  }

  String get difference {
    if (isGeneral) {
      return translate(
        'هذا دليل تعليمي. في التمتع تكون عمرة ثم حج بإحرامين، وفي القِران يجتمع الحج والعمرة في إحرام واحد، وفي الإفراد يكون الحج وحده. تختلف بعض أحكام السعي والهدي والتحلل بحسب النسك.',
        'General guide: Tamattu includes Umrah then Hajj with separate Ihram; Qiran combines both in one Ihram; Ifrad is Hajj alone. Sai, Hady and release rulings vary.',
        'عمومی رہنمائی: تمتع میں پہلے عمرہ پھر حج، قران میں ایک احرام سے دونوں، اور افراد میں صرف حج ہوتا ہے۔',
      );
    }

    if (isTamattu) {
      return translate(
        'أنتِ في مسار التمتع: للعمرة طواف وسعي، ثم بعد الإحرام بالحج سعي مستقل للحج. والهدي واجب عند تحقق شروطه.',
        'Tamattu: Umrah has its own Tawaf and Sai, with a separate Hajj Sai. Hady is required when applicable.',
        'تمتع میں عمرے کی الگ سعی اور حج کی الگ سعی ہوتی ہے۔ شرائط کے مطابق قربانی لازم ہے۔',
      );
    }

    if (isQiran) {
      return translate(
        'أنتِ في مسار القِران: الحج والعمرة في إحرام واحد، ويكفي سعي واحد للحج والعمرة إذا أُدّي صحيحًا. والهدي واجب بشروطه.',
        'Qiran: Hajj and Umrah share one Ihram, and one valid Sai is sufficient. Hady is required when applicable.',
        'قران میں ایک احرام اور ایک درست سعی کافی ہوتی ہے، اور شرائط پر قربانی واجب ہے۔',
      );
    }

    return translate(
      'أنتِ في مسار الإفراد: الإحرام للحج وحده، ويكفي سعي واحد للحج إذا أُدّي صحيحًا. ولا يجب الهدي لمجرد الإفراد.',
      'Ifrad: Ihram is for Hajj alone; one valid Hajj Sai is sufficient. Hady is not required solely for Ifrad.',
      'افراد میں صرف حج کا احرام ہوتا ہے، ایک درست سعی کافی ہے اور صرف افراد کی وجہ سے قربانی واجب نہیں۔',
    );
  }

  Widget sectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(
          color: AppStyle.gold,
          width: 1.3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: AppStyle.green),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppStyle.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: title,
                  onPressed: () {
                    TtsService.speak(
                      title,
                      language: lang,
                    );
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppStyle.green,
                  ),
                ),
              ],
            ),
            const Divider(color: AppStyle.gold),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(
                      color: AppStyle.text,
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: content,
                  onPressed: () {
                    TtsService.speak(
                      content,
                      language: lang,
                    );
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppStyle.green,
                  ),
                ),
              ],
            ),
          ],
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
          textDirection: lang == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Text(
                  translate(
                    'التصنيف الشرعي لهذه الخطوة',
                    'Religious Classification of This Step',
                    'اس مرحلے کی شرعی تقسیم',
                  ),
                  style: const TextStyle(
                    color: AppStyle.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              sectionCard(
                title: pillarTitle,
                content: pillar,
                icon: Icons.star_outline,
              ),
              sectionCard(
                title: obligatoryTitle,
                content: obligation,
                icon: Icons.check_circle_outline,
              ),
              sectionCard(
                title: sunnahTitle,
                content: sunnah,
                icon: Icons.auto_awesome_outlined,
              ),
              sectionCard(
                title: differencesTitle,
                content: difference,
                icon: Icons.alt_route,
              ),
              sectionCard(
                title: translate(
                  'تنبيه فقهي',
                  'Important Religious Note',
                  'اہم شرعی وضاحت',
                ),
                content: generalNote,
                icon: Icons.info_outline,
              ),
            ],
          ),
        );
      },
    );
  }
}
