import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'app_language.dart';

/// استخراج نصوص اللوحات المصورة على Android و iOS.
/// ملاحظة: هذا المحرك يدعم الحروف اللاتينية، ولا يدعم استخراج
/// نصوص اللوحات المكتوبة بالأحرف العربية أو الأردية.
/// الترجمة ليست جزءًا من OCR وتحتاج خدمة ترجمة منفصلة.
class OcrService {
  static String _message(String ar, String en, String ur) {
    final language = AppLanguage.currentLanguage;
    if (language == 'en') return en;
    if (language == 'ur') return ur;
    return ar;
  }

  static Future<String> extractText(String imagePath) async {
    if (kIsWeb) {
      return _message(
        'قراءة النص من الصور متاحة في تطبيق Android أو iOS فقط.',
        'Image text recognition is available only on Android or iOS.',
        'تصویر سے متن پڑھنا صرف Android یا iOS ایپ میں دستیاب ہے۔',
      );
    }

    if (imagePath.trim().isEmpty || !await File(imagePath).exists()) {
      return _message(
        'الصورة غير موجودة. التقطي صورة جديدة وحاولي مرة أخرى.',
        'Image not found. Please take another photo and try again.',
        'تصویر نہیں ملی۔ نئی تصویر لے کر دوبارہ کوشش کریں۔',
      );
    }

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await recognizer.processImage(inputImage);
      final result = recognizedText.text.trim();

      if (result.isEmpty) {
        return _message(
          'لم يتم العثور على نص واضح. جرّبي صورة أوضح للوحة المكتوبة بالإنجليزية. النص العربي والأردي غير مدعوم بهذا المحرك.',
          'No clear text found. Try a clearer photo of a sign in English. Arabic and Urdu script recognition is not supported by this engine.',
          'واضح متن نہیں ملا۔ انگریزی بورڈ کی صاف تصویر لیں۔ یہ انجن عربی اور اردو رسم الخط نہیں پڑھتا۔',
        );
      }

      return result;
    } catch (error) {
      return _message(
        'تعذرت قراءة الصورة. تأكدي من صلاحيات التطبيق وجربي مرة أخرى.',
        'Unable to read the image. Check app permissions and try again.',
        'تصویر نہیں پڑھی جا سکی۔ ایپ کی اجازتیں چیک کر کے دوبارہ کوشش کریں۔',
      );
    } finally {
      await recognizer.close();
    }
  }
}
