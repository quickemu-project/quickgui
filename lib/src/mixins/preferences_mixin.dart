import 'package:shared_preferences/shared_preferences.dart';

mixin PreferencesMixin {
  void savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    }
  }

  Future<T?> getPreference<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      if (T == bool) {
        return prefs.getBool(key) as T;
      } else if (T == double) {
        return prefs.getDouble(key) as T;
      } else if (T == int) {
        return prefs.getInt(key) as T;
      } else if (T == String) {
        return prefs.getString(key) as T;
      } else if (T == List) {
        return prefs.getStringList(key) as T;
      }
    }
    return null;
  }

  Future<void> deletePreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      prefs.remove(key);
    }
  }
}
