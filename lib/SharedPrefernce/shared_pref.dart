import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static Future getIsLoggedIn(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
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
  static Future setName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", name);
  }

  static Future setEmail(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("email", name);
  }

  static Future clearPref(key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }

  static Future notificationList(int list) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("list", list);
  }
}

class SharedFcmToken {
  static Future setNotification(bool token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("notification", token);
  }

  static Future getFcmToken(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setFcmToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("fcmToken", token);
  }

  static Future removeFcmToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
