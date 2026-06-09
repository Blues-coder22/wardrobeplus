import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool isFirstLaunch() {
    return _prefs.getBool('is_first_launch') ?? true;
  }

  static Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool('is_first_launch', false);
  }

  static bool hasCompletedOnboarding() {
    return _prefs.getBool('has_completed_onboarding') ?? false;
  }

  static Future<void> setOnboardingComplete() async {
    await _prefs.setBool('has_completed_onboarding', true);
  }

  static Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  static String? getToken() {
    return _prefs.getString('auth_token');
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
