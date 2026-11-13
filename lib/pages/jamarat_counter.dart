import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/progress_service.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import '../widgets/voice_increment_button.dart';

class JamaratCounter extends StatefulWidget {
  final String hajjType;

  const JamaratCounter({
    super.key,
    required this.hajjType,
  });

  @override
  State<JamaratCounter> createState() =>
      _JamaratCounterState();
}

class _JamaratCounterState extends State<JamaratCounter> {
  int selectedDay = 11;

  // اليوم 11 و12 و13
  // ثلاث جمرات، لكل واحدة سبع حصيات.
  final Map<int, List<int>> counts = {
    11: [0, 0, 0],
    12: [0, 0, 0],
    13: [0, 0, 0],
  };

  bool loading = true;

  String get lang {
    final current = AppLanguage.currentLanguage;

    if (['ar', 'en', 'ur'].contains(current)) {
      return current;
    }

    return 'ar';
  }

  static const words = {
    'ar': {
      'title': 'عداد رمي الجمرات',
      'subtitle':
      'اختاري اليوم، ثم اضغطي + أو المايك وقولي «واحد» بعد كل حصاة.',
      'day11': 'اليوم الحادي عشر',
      'day12': 'اليوم الثاني عشر',
      'day13': 'اليوم الثالث عشر',
      'small': 'الجمرة الصغرى',
      'middle': 'الجمرة الوسطى',
      'large': 'جمرة العقبة الكبرى',
      'pebbles': 'حصيات',
      'done': 'اكتمل رمي هذه الجمرة',
      'dayDone': 'اكتمل تسجيل الجمرات الثلاث لهذا اليوم',
      'reset': 'تصفير هذا العداد',
      'resetDay': 'تصفير عدادات اليوم',
      'confirm': 'تأكيد التصفير',
      'confirmMessage':
      'هل تريدين تصفير عدادات هذا اليوم؟',
      'cancel': 'إلغاء',
      'yes': 'نعم، تصفير',
      'note':
      'يكون الرمي بالترتيب: الصغرى، ثم الوسطى، ثم جمرة العقبة الكبرى، وسبع حصيات لكل جمرة.',
      'day13Note':
      'اليوم الثالث عشر لمن تأخر. يجوز التعجل في اليوم الثاني عشر إذا تحققت شروطه الشرعية.',
      'timing':
      'يجب مراعاة الوقت الشرعي للرمي والرخص المتعلقة بالأعذار، واتباع تعليمات تنظيم الحشود.',
      'saved':
      'يتم حفظ الأعداد على هذا الجهاز.',
    },
    'en': {
      'title': 'Jamarat Counter',
      'subtitle':
      'Choose a day, then tap + or the microphone and say “one” after each pebble.',
      'day11': '11 Dhul-Hijjah',
      'day12': '12 Dhul-Hijjah',
      'day13': '13 Dhul-Hijjah',
      'small': 'Small Jamarah',
      'middle': 'Middle Jamarah',
      'large': 'Jamrat Aqabah',
      'pebbles': 'Pebbles',
      'done': 'This Jamarah is complete',
      'dayDone': 'All three Jamarat are recorded for this day',
      'reset': 'Reset This Counter',
      'resetDay': 'Reset Day Counters',
      'confirm': 'Confirm Reset',
      'confirmMessage':
      'Reset all counters for this day?',
      'cancel': 'Cancel',
      'yes': 'Yes, Reset',
      'note':
      'Stone in this order: small, middle, then Jamrat Aqabah, with seven pebbles at each.',
      'day13Note':
      'Day 13 is for pilgrims who remain. Early departure on Day 12 is allowed under its conditions.',
      'timing':
      'Observe the prescribed stoning times, applicable concessions and official crowd-management instructions.',
      'saved':
      'Counts are saved on this device.',
    },
    'ur': {
      'title': 'رمی جمرات کا کاؤنٹر',
      'subtitle':
      'دن منتخب کریں، پھر ہر کنکری کے بعد + دبائیں یا مائیک پر «ایک» کہیں۔',
      'day11': 'گیارہ ذوالحجہ',
      'day12': 'بارہ ذوالحجہ',
      'day13': 'تیرہ ذوالحجہ',
      'small': 'چھوٹا جمرہ',
      'middle': 'درمیانی جمرہ',
      'large': 'جمرہ عقبہ',
      'pebbles': 'کنکریاں',
      'done': 'اس جمرے کی رمی مکمل',
      'dayDone': 'اس دن تینوں جمرات کی رمی درج ہو گئی',
      'reset': 'یہ گنتی صفر کریں',
      'resetDay': 'اس دن کی تمام گنتی صفر کریں',
      'confirm': 'تصدیق',
      'confirmMessage':
      'کیا اس دن کے تمام کاؤنٹر صفر کرنے ہیں؟',
      'cancel': 'منسوخ',
      'yes': 'ہاں، صفر کریں',
      'note':
      'ترتیب: پہلے چھوٹا، پھر درمیانی اور پھر جمرہ عقبہ؛ ہر ایک پر سات کنکریاں۔',
      'day13Note':
      'تیرہ ذوالحجہ قیام کرنے والوں کے لیے ہے۔ شرائط پوری ہوں تو بارہ تاریخ کو تعجل جائز ہے۔',
      'timing':
      'رمی کے شرعی اوقات، رعایتوں اور انتظامی ہدایات کا خیال رکھیں۔',
      'saved':
      'گنتی اس آلے میں محفوظ ہوتی ہے۔',
    },
  };

  String tr(String key) {
    return words[lang]?[key] ?? words['ar']![key]!;
  }

  String counterKey(int day, int jamarah) {
    return 'jamarat_${widget.hajjType}_${day}_$jamarah';
  }

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    final loaded = <int, List<int>>{};

    for (final day in [11, 12, 13]) {
      final values = <int>[];

      for (var i = 0; i < 3; i++) {
        final saved = await ProgressService.getCounter(
          counterKey(day, i),
        );

        values.add(saved.clamp(0, 7).toInt());
      }

      loaded[day] = values;
    }

    if (!mounted) return;

    setState(() {
      counts.addAll(loaded);
      loading = false;
    });
  }

  Future<void> changeCount(
      int day,
      int jamarah,
      int value,
      ) async {
    final newValue = value.clamp(0, 7).toInt();

    setState(() {
      counts[day]![jamarah] = newValue;
    });

    await ProgressService.saveCounter(
      counterKey(day, jamarah),
      newValue,
    );
  }

  Future<void> resetDay() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tr('confirm')),
          content: Text(tr('confirmMessage')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(tr('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(tr('yes')),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    for (var i = 0; i < 3; i++) {
      await changeCount(selectedDay, i, 0);
    }
  }

  Widget sound(String text) {
    return IconButton(
      tooltip: lang == 'ar'
          ? 'استمع'
          : lang == 'en'
          ? 'Listen'
          : 'سنیں',
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
      String text, {
        double fontSize = 15,
        bool bold = false,
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight:
              bold ? FontWeight.bold : FontWeight.normal,
              color: AppStyle.green,
              height: 1.6,
            ),
          ),
        ),
        sound(text),
      ],
    );
  }

  Widget dayButton(int day) {
    final selected = selectedDay == day;
    final title = tr('day$day');

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() {
              selectedDay = day;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 3,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppStyle.green
                  : Colors.white,
              border: Border.all(
                color: AppStyle.gold,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? Colors.white
                        : AppStyle.green,
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 11,
                    color: selected
                        ? Colors.white
                        : AppStyle.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget counterCard(
      int jamarah,
      String title,
      ) {
    final current = counts[selectedDay]![jamarah];
    final complete = current == 7;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 13),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppStyle.gold,
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            spokenText(
              title,
              fontSize: 19,
              bold: true,
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: current / 7,
              color: AppStyle.green,
              backgroundColor:
              AppStyle.gold.withOpacity(.18),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 14),

            Text(
              '$current / 7',
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppStyle.green,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: current > 0
                      ? () => changeCount(
                    selectedDay,
                    jamarah,
                    current - 1,
                  )
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: AppStyle.green,
                    foregroundColor: Colors.white,
                  ),
                ),

                const SizedBox(width: 20),

                // كل جمرة لها زر صوت مستقل، ويفعّل زيادة واحدة فقط.
                VoiceIncrementButton(
                  key: ValueKey('voice_${widget.hajjType}_${selectedDay}_$jamarah'),
                  language: lang,
                  value: current,
                  maximum: 7,
                  onIncrement: () {
                    final latest = counts[selectedDay]![jamarah];
                    if (latest < 7) {
                      changeCount(selectedDay, jamarah, latest + 1);
                    }
                  },
                ),

                const SizedBox(width: 20),

                IconButton.filled(
                  onPressed: current < 7
                      ? () => changeCount(
                    selectedDay,
                    jamarah,
                    current + 1,
                  )
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppStyle.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            if (complete)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppStyle.green,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tr('done'),
                        style: const TextStyle(
                          color: AppStyle.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            TextButton(
              onPressed: current > 0
                  ? () => changeCount(
                selectedDay,
                jamarah,
                0,
              )
                  : null,
              child: Text(tr('reset')),
            ),
          ],
        ),
      ),
    );
  }

  Widget noticeCard(
      String text,
      IconData icon,
      ) {
    return Card(
      color: const Color(0xFFFFFBF2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppStyle.gold),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Icon(icon, color: AppStyle.green),
            const SizedBox(width: 10),
            Expanded(child: spokenText(text)),
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
        final dayCounts = counts[selectedDay]!;
        final dayComplete =
        dayCounts.every((number) => number == 7);

        return Directionality(
          textDirection: lang == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              color: AppStyle.cream,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppStyle.gold,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: loading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                spokenText(
                  tr('title'),
                  fontSize: 23,
                  bold: true,
                ),

                const SizedBox(height: 8),

                spokenText(tr('subtitle')),

                const SizedBox(height: 16),

                Row(
                  children: [
                    dayButton(11),
                    dayButton(12),
                    dayButton(13),
                  ],
                ),

                const SizedBox(height: 17),

                counterCard(0, tr('small')),

                counterCard(1, tr('middle')),

                counterCard(2, tr('large')),

                if (dayComplete)
                  noticeCard(
                    tr('dayDone'),
                    Icons.check_circle_outline,
                  ),

                if (selectedDay == 13)
                  noticeCard(
                    tr('day13Note'),
                    Icons.info_outline,
                  ),

                noticeCard(
                  tr('note'),
                  Icons.format_list_numbered,
                ),

                noticeCard(
                  tr('timing'),
                  Icons.schedule_outlined,
                ),

                const SizedBox(height: 10),

                OutlinedButton.icon(
                  onPressed: resetDay,
                  icon: const Icon(Icons.refresh),
                  label: Text(tr('resetDay')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppStyle.green,
                    side: const BorderSide(
                      color: AppStyle.gold,
                    ),
                    padding: const EdgeInsets.all(14),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    tr('saved'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppStyle.green,
                      fontSize: 12,
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
