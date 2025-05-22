import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Setters
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }



  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    print('Saving to SharedPreferences key: $key, value: $value');
    await prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringListAsync(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getStringList(key) ?? [];
    print('Retrieved from SharedPreferences key: $key, value: $value');
    return value;
  }

  // Getters

  static String? getString(String key) => _prefs?.getString(key);
  static bool? getBool(String key) => _prefs?.getBool(key);
  static int? getInt(String key) => _prefs?.getInt(key);
  static double? getDouble(String key) => _prefs?.getDouble(key);
 
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
