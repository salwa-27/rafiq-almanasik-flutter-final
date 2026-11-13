import 'package:shared_preferences/shared_preferences.dart';
class ProgressService {
  static Future<void> saveLastPage(String page) async { final p = await SharedPreferences.getInstance(); await p.setString('last', page); }
  static Future<void> saveCounter(String key, int val) async { final p = await SharedPreferences.getInstance(); await p.setInt(key, val); }
  static Future<int> getCounter(String key) async { final p = await SharedPreferences.getInstance(); return p.getInt(key) ?? 0; }
}