
import 'package:flutter/material.dart';
import '../services/app_language.dart';
import '../services/tts_service.dart';
import '../theme/app_style.dart';
import 'register_page.dart';
import 'choose_ritual_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
final bool afterLogin;

const HomePage({super.key, this.afterLogin = false});

@override
State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
static const _languages = <String, Map<String, String>>{
'ar': {
'name': 'العربية',
'welcome': 'أهلاً وسهلاً بك',
'start': 'ابدأ الآن',
},
'en': {
'name': 'English',
'welcome': 'Welcome',
'start': 'Start Now',
},
'ur': {
'name': 'اردو',
'welcome': 'خوش آمدید',
'start': 'اب شروع کریں',
},
};

late String _language;
bool _menuOpen = false;

@override
void initState() {
super.initState();
_language = _languages.containsKey(
AppLanguage.currentLanguage,
)
? AppLanguage.currentLanguage
    : 'ar';
}

Future<void> _selectLanguage(String code) async {
await AppLanguage.changeLanguage(code);

if (!mounted) return;

await context.setLocale(Locale(code));

if (!mounted) return;

setState(() {
_language = code;
_menuOpen = false;
});
}

void _openRegistration() {
Navigator.of(context).push(
MaterialPageRoute<void>(
builder: (_) => const RegisterPage(),
),
);
}

Widget _soundButton(
String text,
String code, {
double size = 46,
}) {
return SizedBox(
width: size,
height: size,
child: Material(
color: Colors.white,
shape: const CircleBorder(
side: BorderSide(
color: AppStyle.gold,
width: 2,
),
),
elevation: 3,
child: IconButton(
tooltip: code == 'en'
? 'Listen'
    : code == 'ur'
? 'سنیں'
    : 'استمع',
padding: EdgeInsets.zero,
icon: Icon(
Icons.volume_up_rounded,
color: AppStyle.green,
size: size * .48,
),
onPressed: () {
TtsService.speak(
text,
language: code,
);
},
),
),
);
}

Widget _languagePicker() {
return SizedBox(
width: 260,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Material(
color: Colors.white,
borderRadius: BorderRadius.circular(30),
elevation: 4,
child: InkWell(
borderRadius: BorderRadius.circular(30),
onTap: () {
setState(() {
_menuOpen = !_menuOpen;
});
},
child: Padding(
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 14,
),
child: Row(
children: [
Expanded(
child: Text(
_languages[_language]!['name']!,
style: const TextStyle(
color: AppStyle.green,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),
Icon(
_menuOpen
? Icons.keyboard_arrow_up
    : Icons.keyboard_arrow_down,
color: AppStyle.green,
),
],
),
),
),
),
if (_menuOpen) ...[
const SizedBox(height: 8),
Material(
color: Colors.white,
borderRadius: BorderRadius.circular(22),
elevation: 5,
clipBehavior: Clip.antiAlias,
child: Column(
children: _languages.entries.map((entry) {
return Padding(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 3,
),
child: Row(
children: [
Expanded(
child: TextButton(
onPressed: () {
_selectLanguage(entry.key);
},
style: TextButton.styleFrom(
alignment:
AlignmentDirectional.centerStart,
),
child: Text(
entry.value['name']!,
style: const TextStyle(
color: AppStyle.green,
fontWeight: FontWeight.bold,
fontSize: 17,
),
),
),
),
_soundButton(
entry.value['name']!,
entry.key,
size: 40,
),
],
),
);
}).toList(),
),
),
],
],
),
);
}

@override
Widget build(BuildContext context) {
final isRtl = _language != 'en';
final words = _languages[_language]!;
final screen = MediaQuery.sizeOf(context);
final height = screen.height;
final width = screen.width;
final compact = width < 600;
final shortScreen = height < 700;
final logoSize = compact ? (width * .44).clamp(110.0, 190.0) : 210.0;

return Directionality(
textDirection:
isRtl
? ui.TextDirection.rtl
    : ui.TextDirection.ltr,
child: Scaffold(
body: Stack(
fit: StackFit.expand,
children: [
Image.asset(
'assets/images/backgrund.jpg',
fit: BoxFit.cover,
),

Container(
color: Colors.black.withValues(alpha: .16),
),

SafeArea(
child: LayoutBuilder(
builder: (context, constraints) => SingleChildScrollView(
padding: EdgeInsets.symmetric(
horizontal: compact ? 16 : 28,
vertical: shortScreen ? 14 : 24,
),
child: Center(
child: ConstrainedBox(
constraints: BoxConstraints(
maxWidth: 680,
minHeight: (constraints.maxHeight -
(shortScreen ? 28 : 48))
    .clamp(0.0, double.infinity)
    .toDouble(),
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.center,
children: [
_languagePicker(),

SizedBox(
height: shortScreen ? 24 : (compact ? 55 : 85),
),

Image.asset(
'assets/images/logo.png',
width: logoSize,
height: logoSize,
fit: BoxFit.contain,
),

const SizedBox(height: 20),

Wrap(
alignment: WrapAlignment.center,
crossAxisAlignment:
WrapCrossAlignment.center,
spacing: 12,
runSpacing: 10,
children: [
Text(
words['welcome']!,
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
fontSize: compact ? 25 : 32,
shadows: [
Shadow(
color: Colors.black54,
blurRadius: 10,
offset: Offset(0, 3),
),
],
),
),

_soundButton(
words['welcome']!,
_language,
),
],
),

const SizedBox(height: 40),

Wrap(
alignment: WrapAlignment.center,
crossAxisAlignment:
WrapCrossAlignment.center,
spacing: 14,
runSpacing: 12,
children: [
Material(
color: const Color(0xFF08705B),
borderRadius:
BorderRadius.circular(40),
elevation: 5,
child: InkWell(
borderRadius:
BorderRadius.circular(40),
onTap: () {
if (widget.afterLogin) {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const ChooseRitualPage(),
),
);
} else {
_openRegistration();
}
},
child: Container(
padding:
const EdgeInsets.symmetric(
horizontal: 40,
vertical: 14,
),
decoration: BoxDecoration(
borderRadius:
BorderRadius.circular(40),
border: Border.all(
color: AppStyle.gold,
width: 2,
),
),
child: Text(
words['start']!,
style: TextStyle(
color: Colors.white,
fontSize: compact ? 20 : 23,
fontWeight: FontWeight.bold,
),
),
),
),
),

_soundButton(
words['start']!,
_language,
),
],
),
],
),
),
),
),
),
),
],
),
),
);
}
}
