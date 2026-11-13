
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'reset_http_client_io.dart'
if (dart.library.html) 'reset_http_client_web.dart';

class ApiService {
  static const String baseUrl =
      'http://localhost/rafiq_al_manasik/api';

  // عميل خاص باستعادة كلمة المرور للحفاظ على جلسة PHP.
  static final http.Client _resetClient = createResetClient();

  // إنشاء حساب جديد
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data;
      }

      return {
        'success': false,
        'message': 'Invalid server response',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  // تسجيل الدخول
  static Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identifier': emailOrPhone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data;
      }

      return {
        'success': false,
        'message': 'Invalid server response',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  // إرسال رمز استعادة كلمة المرور إلى البريد الإلكتروني
  static Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    try {
      final response = await _resetClient.post(
        Uri.parse('$baseUrl/request-reset.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
        }),
      );

      if (kDebugMode) {
        debugPrint('RESET API status: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data;
      }

      return {
        'ok': false,
        'error': 'invalid_response',
      };
    } catch (e) {
      debugPrint('REQUEST RESET ERROR: $e');

      return {
        'ok': false,
        'error': 'connection_error',
      };
    }
  }

  // التحقق من رمز البريد الإلكتروني
  static Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _resetClient.post(
        Uri.parse('$baseUrl/verify-reset-code.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'code': code.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data;
      }

      return {
        'ok': false,
        'error': 'invalid_response',
      };
    } catch (e) {
      debugPrint('VERIFY RESET ERROR: $e');

      return {
        'ok': false,
        'error': 'connection_error',
      };
    }
  }

  // حفظ كلمة المرور الجديدة بعد نجاح التحقق
  static Future<Map<String, dynamic>> saveNewPassword({
    required String password,
  }) async {
    try {
      final response = await _resetClient.post(
        Uri.parse('$baseUrl/reset-password.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data;
      }

      return {
        'ok': false,
        'error': 'invalid_response',
      };
    } catch (e) {
      debugPrint('SAVE PASSWORD ERROR: $e');

      return {
        'ok': false,
        'error': 'connection_error',
      };
    }
  }
}
