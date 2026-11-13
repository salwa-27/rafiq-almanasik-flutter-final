import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;

import 'services/app_language.dart';
import 'theme/app_style.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  // تحميل اللغة المحفوظة قبل تشغيل التطبيق
  await AppLanguage.loadLanguage();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('ur'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: Locale(AppLanguage.currentLanguage),
      child: const RafiqAlManasikApp(),
    ),
  );
}

class RafiqAlManasikApp extends StatelessWidget {
  const RafiqAlManasikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رفيق المناسك',
      debugShowCheckedModeBanner: false,

      // إعدادات اللغة الافتراضية
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,


      // الألوان والتصميم الأساسي
      theme: ThemeData(
        primaryColor: AppStyle.green,
        scaffoldBackgroundColor: AppStyle.cream,
        useMaterial3: true,
      ),

      // اتجاه الصفحة (يقرأ اللغة الحالية)
      builder: (context, child) {
        return Directionality(
          textDirection: AppLanguage.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox(),
        );
      },

      // أول صفحة تفتح (شاشة البداية)
      home: const SplashPage(),
    );
  }
}