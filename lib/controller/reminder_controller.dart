// lib/controller/reminder_controller.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/reminder_model.dart';
import '../global/user_session.dart';

class ReminderController with ChangeNotifier {
  static const String _baseUrl =
      'https://aqua-mate-backend.onrender.com/api/reminders';

  List<ReminderModel> _reminders = [];
  List<ReminderModel> get reminders => _reminders;

  // ================= AUTH HEADERS =================
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await UserSession.getToken();

    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  // ================= FETCH REMINDERS =================
  Future<String> fetchReminders() async {
    final token = await UserSession.getToken();
    if (token == null) return "Not logged in.";

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: await _getAuthHeaders(),
      );

      final jsonBody = json.decode(response.body);

      if (response.statusCode == 200 && jsonBody["success"] == true) {
        final List<dynamic> list = jsonBody["data"];

        _reminders = list.map((e) => ReminderModel.fromJson(e)).toList();

        _reminders.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));

        notifyListeners();
        return "Success";
      }

      return jsonBody["message"] ?? "Failed to load reminders.";
    } catch (e) {
      return "Network error: $e";
    }
  }

  // ================= ADD REMINDER =================
  Future<String> addReminder({
    required String tankName,
    required ReminderType type,
    required DateTime scheduledDate,
  }) async {
    final token = await UserSession.getToken();
    if (token == null) return "You must be logged in.";

    final body = {
      "tankName": tankName,
      "type": type.toShortString(),
      "dueDateTime": scheduledDate.toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await _getAuthHeaders(),
        body: json.encode(body),
      );

      final jsonBody = json.decode(response.body);

      if (response.statusCode == 201 && jsonBody["success"] == true) {
        final reminder = ReminderModel.fromJson(jsonBody["data"]);

        _reminders.add(reminder);
        _reminders.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));

        notifyListeners();
        return "Success";
      }

      return jsonBody["message"] ?? "Failed to create reminder.";
    } catch (e) {
      return "Network error: $e";
    }
  }

  // ================= DELETE REMINDER =================
  Future<String> removeReminder(ReminderModel reminder) async {
    final token = await UserSession.getToken();
    if (token == null) return "Not logged in.";
    if (reminder.id == null) return "Invalid reminder ID.";

    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/${reminder.id}"),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        _reminders.removeWhere((r) => r.id == reminder.id);
        notifyListeners();
        return "Success";
      }

      return "Delete failed";
    } catch (e) {
      return "Network error: $e";
    }
  }

  // =====================================================
  // ===================== FILTERS ========================
  // =====================================================

  /// URGENT = due within next 24 hours AND not overdue
  List<ReminderModel> get urgentReminders {
    final now = DateTime.now();

    return _reminders.where((r) {
      final diffMinutes = r.dueDateTime.difference(now).inMinutes;

      return diffMinutes <= 1440 && // 24 hours
          diffMinutes >= 0; // Not overdue
    }).toList();
  }

  /// UPCOMING = due MORE than 24 hours away
  List<ReminderModel> get upcomingReminders {
    final now = DateTime.now();

    return _reminders.where((r) {
      final diffMinutes = r.dueDateTime.difference(now).inMinutes;

      return diffMinutes > 1440;
    }).toList();
  }

  /// Overdue reminders (optional, if you need it)
  List<ReminderModel> get overdueReminders {
    final now = DateTime.now();

    return _reminders.where((r) => r.dueDateTime.isBefore(now)).toList();
  }
}
