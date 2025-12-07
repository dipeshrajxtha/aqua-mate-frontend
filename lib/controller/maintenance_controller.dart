import 'package:flutter/material.dart';
import '../model/reminder_model.dart';
import 'reminder_controller.dart';

typedef MaintenanceTask = ReminderModel;

class MaintenanceController extends ChangeNotifier {
  ReminderController _reminderController;

  MaintenanceController({required ReminderController reminderController})
      : _reminderController = reminderController {
    _reminderController.addListener(_notify);
  }

  void updateDependency(ReminderController newReminderController) {
    if (_reminderController != newReminderController) {
      _reminderController.removeListener(_notify);
      _reminderController = newReminderController;
      _reminderController.addListener(_notify);
      notifyListeners();
    }
  }

  void _notify() => notifyListeners();

  // 🔥 CORRECTED URGENT LOGIC
  List<MaintenanceTask> get urgent {
    final now = DateTime.now();
    final fiveHoursFromNow = now.add(const Duration(hours: 5));

    final sorted = List<MaintenanceTask>.from(_reminderController.reminders)
      ..sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));

    return sorted.where((task) {
      final due = task.dueDateTime;

      final overdue = due.isBefore(now);
      final dueSoon = due.isAfter(now) && due.isBefore(fiveHoursFromNow);

      return overdue || dueSoon;
    }).toList();
  }

  // UPCOMING TASKS (UNCHANGED)
  List<MaintenanceTask> get upcoming {
    final now = DateTime.now();
    final fiveHoursFromNow = now.add(const Duration(hours: 5));

    final sorted = List<MaintenanceTask>.from(_reminderController.reminders)
      ..sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));

    return sorted.where((task) {
      return task.dueDateTime.isAfter(fiveHoursFromNow);
    }).toList();
  }

  @override
  void dispose() {
    _reminderController.removeListener(_notify);
    super.dispose();
  }
}
