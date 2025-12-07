import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/user_session.dart';
import '../model/user_model.dart';

class AuthController with ChangeNotifier {
  static const String baseUrl =
      'https://aqua-mate-backend.onrender.com/api/auth';

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ========================= REGISTER =========================
  Future<String> register({
    required String fullName,
    required String email,
    required String password,
    required String gender,
    required String dob,
  }) async {
    try {
      _setLoading(true);

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "password": password,
          "gender": gender,
          "dob": dob,
        }),
      );

      _setLoading(false);

      if (response.statusCode == 201) {
        return "Success";
      }

      final data = jsonDecode(response.body);
      return data['message'] ?? "Registration failed";
    } catch (e) {
      _setLoading(false);
      return "Connection Error: $e";
    }
  }

  // ========================= LOGIN =========================
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final userJson = responseData['user'];
        String token = responseData['token'];

        if (userJson == null || token == null) {
          _setLoading(false);
          return "Login failed: Missing user or token.";
        }

        // -------------------------------
        // FIX: Remove "Bearer " prefix if backend already sends it
        // -------------------------------
        if (token.startsWith("Bearer ")) {
          token = token.replaceFirst("Bearer ", "");
        }

        _currentUser = UserModel.fromJson(userJson);

        // Save session
        await UserSession.save(_currentUser!, token);

        notifyListeners();
        _setLoading(false);
        return "Success";
      }

      _setLoading(false);
      return responseData['message'] ?? "Login failed";
    } catch (e) {
      _setLoading(false);
      return "Connection Error: $e";
    }
  }

  // ========================= LOGOUT =========================
  Future<void> logout() async {
    await UserSession.clear();
    _currentUser = null;
    notifyListeners();
  }

  // ========================= LOAD SESSION =========================
  Future<void> loadUserFromSession() async {
    _currentUser = await UserSession.getUser();
    notifyListeners();
  }
}
