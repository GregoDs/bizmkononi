// lib/services/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _firstLaunchKey = 'firstLaunch';
  static const _isLoginKey = 'isLogin';

  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  // Login status
  bool get isLoggedIn => _prefs.getBool(_isLoginKey) ?? false;
  Future<void> setLoggedIn(bool value) => _prefs.setBool(_isLoginKey, value);

  // First launch
  bool get isFirstLaunch => _prefs.getBool(_firstLaunchKey) ?? true;
  Future<void> setFirstLaunch(bool value) => _prefs.setBool(_firstLaunchKey, value);

  // Initialize (call this once at app startup)
  static Future<LocalStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage(prefs);
  }
}