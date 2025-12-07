import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/aquarium_model.dart';
import '../global/user_session.dart';

class AquariumController extends ChangeNotifier {
  List<Aquarium> _aquariums = [];
  bool _isLoading = false;
  final String _apiBaseUrl = 'https://aqua-mate-backend.onrender.com';

  List<Aquarium> get aquariums => _aquariums;
  bool get isLoading => _isLoading;

  Future<String?> _getToken() async {
    final token = await UserSession.getToken();
    if (token == null || token.isEmpty) {
      debugPrint("AquariumController: No token found!");
    }
    return token;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Map<String, String> _authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // =======================
  // FETCH
  // =======================
  Future<void> fetchAquariums() async {
    _setLoading(true);

    try {
      final token = await _getToken();
      if (token == null) {
        _setLoading(false);
        return;
      }

      final response = await http.get(
        Uri.parse('$_apiBaseUrl/api/aquariums'),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          _aquariums = decoded.map((json) => Aquarium.fromJson(json)).toList();
        }
      } else {
        debugPrint("Fetch failed ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }

    _setLoading(false);
  }

  // =======================
  // ADD AQUARIUM (FIXED)
  // =======================
  Future<bool> addAquarium(Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      final token = await _getToken();
      if (token == null) {
        _setLoading(false);
        return false;
      }

      // No more wrong keys — use exactly what the form produces.
      final mappedData = {
        "name": data["name"],
        "aquariumType": data["aquariumType"],
        "tankSize": data["tankSize"],
        "tankShape": data["tankShape"],
        "temperature": data["temperature"],
        "location": data["location"],
        "description": data["description"],
      };

      final response = await http.post(
        Uri.parse('$_apiBaseUrl/api/aquariums'),
        headers: _authHeaders(token),
        body: jsonEncode(mappedData),
      );

      if (response.statusCode == 201) {
        await fetchAquariums();
        _setLoading(false);
        return true;
      } else {
        debugPrint(
            "Add failed ${response.statusCode} -> ${response.body}");
      }
    } catch (e) {
      debugPrint("Add Error: $e");
    }

    _setLoading(false);
    return false;
  }

  // =======================
  // REMOVE
  // =======================
  Future<bool> removeAquarium(String aquariumId) async {
    _setLoading(true);

    try {
      final token = await _getToken();
      if (token == null) {
        _setLoading(false);
        return false;
      }

      final response = await http.delete(
        Uri.parse('$_apiBaseUrl/api/aquariums/$aquariumId'),
        headers: _authHeaders(token),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _aquariums.removeWhere((a) => a.id == aquariumId);
        notifyListeners();
        _setLoading(false);
        return true;
      } else {
        debugPrint(
            "Remove failed ${response.statusCode} -> ${response.body}");
      }
    } catch (e) {
      debugPrint("Remove Error: $e");
    }

    _setLoading(false);
    return false;
  }
}
