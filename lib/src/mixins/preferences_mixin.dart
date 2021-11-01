import 'package:shared_preferences/shared_preferences.dart';

mixin PreferencesMixin {
  void savePreference(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future getPreference(key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      final preference = prefs.getString(key);
      return preference ?? false;
    }
  }
}
