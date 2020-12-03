import 'package:shared_preferences/shared_preferences.dart' as sp;

class SharedPreferences {
  static Future<sp.SharedPreferences> get _instance async =>
      _prefsInstance ??= await sp.SharedPreferences.getInstance();
  static sp.SharedPreferences _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<sp.SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key, [String defValue]) {
    return _prefsInstance.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    return _prefsInstance.setString(key, value) ?? Future.value(false);
  }

  static Future<bool> clear() async {
    return _prefsInstance.clear();
  }
}
