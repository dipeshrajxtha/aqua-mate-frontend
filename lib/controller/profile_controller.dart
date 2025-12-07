// lib/controller/profile_controller.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../global/user_session.dart';
import '../model/user_model.dart';

class ProfileController {
  static final ProfileController _instance = ProfileController._internal();
  factory ProfileController() => _instance;
  ProfileController._internal();

  static const String baseUrl = 'https://aqua-mate-backend.onrender.com/api';

  Future<String> updateProfile({
    required String userId,
    required String fullName,
    required String dob,
    XFile? profilePicture,
  }) async {
    try {
      final token = await UserSession.getToken();
      if (token == null) return "Not authorized. Please log in again.";

      final url = Uri.parse('$baseUrl/profile/update');

      /// 🚨 FIXED: MUST USE PUT (NOT POST)
      final request = http.MultipartRequest('PUT', url);

      /// HEADERS
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      /// TEXT FIELDS
      request.fields['userId'] = userId;
      request.fields['fullName'] = fullName;
      request.fields['dob'] = dob;

      /// FILE (optional)
      if (profilePicture != null) {
        final stream = http.ByteStream(profilePicture.openRead());
        final length = await profilePicture.length();

        final file = http.MultipartFile(
          'profilePicture',
          stream,
          length,
          filename: profilePicture.name,
          contentType:
          MediaType.parse(profilePicture.mimeType ?? 'image/jpeg'),
        );

        request.files.add(file);
      }

      /// SEND REQUEST
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      /// SAFE JSON PARSING
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(responseBody);
      } catch (e) {
        print("❌ Server returned non-JSON:");
        print(responseBody);
        return "Server error: Invalid response from server.";
      }

      /// SUCCESS
      if (response.statusCode == 200) {
        final updatedUser = UserModel.fromJson(data!);
        await UserSession.save(updatedUser, token);
        return "Profile updated successfully!";
      }

      /// API ERROR
      return data?['message'] ??
          "Profile update failed (${response.statusCode})";
    } catch (e) {
      print("PROFILE UPDATE ERROR: $e");
      return "Connection Error. Try again.";
    }
  }
}

final profileController = ProfileController();
