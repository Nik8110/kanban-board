import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  static SharedPreferences? _prefs;

  reset() {
    print("==============shared prefs cleared===============");
    _prefs?.clear();
  }

  init() async {
    _prefs = await SharedPreferences.getInstance();
    print("shared preference instance created===================");
  }

  getUserId() {
    return _prefs?.getString("userId") ?? "";
  }

  getOnboardingFlag() {
    return _prefs?.getBool("isOnboardingShown") ?? false;
  }

  setOnboardingFlag() {
    _prefs?.setBool("isOnboardingShown", true);
    print("Onboarding complete===========");
  }

  void setUserId(String id) {
    _prefs?.setString("userId", id);
    print("userId set======= $id");
  }

  void setToken(String token) {
    _prefs?.setString("token", token);
    print("token set======= ");
  }

  getToken() {
    return _prefs?.getString("token");
  }
}
