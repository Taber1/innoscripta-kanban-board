import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _preferences;
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      _preferences = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  static Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static Future<void> setListMap(
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    final jsonValue = jsonEncode(value);
    await _preferences.setString(key, jsonValue);
  }

  static List<Map<String, dynamic>>? getListMap(String key) {
    final jsonString = _preferences.getString(key);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    }
    return null;
  }

  static Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  static Future<void> clear() async {
    await _preferences.clear();
  }

  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }
}
