import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class UserSession {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  // ================= SAVE SESSION =================
  static Future<void> save(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_tokenKey, token);
  }

  // ================= LOAD USER =================
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString == null) return null;

    final userJson = jsonDecode(userString);
    return UserModel.fromJson(userJson);
  }

  // ================= LOAD TOKEN =================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ================= CLEAR SESSION =================
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }
}
