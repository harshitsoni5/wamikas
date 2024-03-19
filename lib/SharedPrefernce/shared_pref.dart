import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static Future getIsLoggedIn(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setIsLoggedIn(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("IsLoggedIn", value);
  }

  static Future setPhone(String phone) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("phone", phone);
  }

  static Future getIsOnboardDone(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setIsOnboardDone(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("IsOnboardDone", value);
  }

  static Future setUid(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("uid", uid);
  }

  static Future setImageUrl(String imageUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("profile", imageUrl);
  }
}