
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  static const String _languageKey = 'selectedLanguage';

  static String currentLanguage = 'ar';

  static final ValueNotifier<String> languageNotifier =
  ValueNotifier<String>('ar');

  static const List<String> supportedLanguages = [
    'ar',
    'en',
    'ur',
  ];

  static bool get isRtl =>
      currentLanguage == 'ar' ||
          currentLanguage == 'ur';

  static Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    final savedLanguage =
        prefs.getString(_languageKey) ?? 'ar';

    currentLanguage =
    supportedLanguages.contains(savedLanguage)
        ? savedLanguage
        : 'ar';

    languageNotifier.value = currentLanguage;
  }

  static Future<void> changeLanguage(
      String language,
      ) async {
    if (!supportedLanguages.contains(language)) {
      return;
    }

    currentLanguage = language;
    languageNotifier.value = language;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _languageKey,
      language,
    );
  }
}
