// lib/view/reminders/reminder_setup_form.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/reminder_controller.dart';
import '../../model/reminder_model.dart';

// --- Custom Color Palette (kept but adjusted to allow dark mode) ---
class AppColors {
  static const Color aquaMain = Color(0xFF4ade80);
  static const Color primaryBlue = Color(0xFF49AEB1);
  static const Color errorRed = Color(0xFFF87171);
}

class ReminderSetupForm extends StatefulWidget {
  const ReminderSetupForm({super.key});

  @override
  State<ReminderSetupForm> createState() => _ReminderSetupFormState();
}

class _ReminderSetupFormState extends State<ReminderSetupForm> {
  String? _selectedTask;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _tankNameController = TextEditingController();

  final List<String> _tasks = [
    'Fish Feed',
    'Water Change',
    'Tank Cleaning',
    'Filter Wash',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _selectedTime = TimeOfDay.fromDateTime(
      DateTime.now().add(const Duration(hours: 1)),
    );
  }

  @override
  void dispose() {
    _tankNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context).colorScheme;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.copyWith(primary: AppColors.primaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final theme = Theme.of(context).colorScheme;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.copyWith(primary: AppColors.primaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _saveReminder(BuildContext context) async {
    final tankName = _tankNameController.text.trim();
    if (_selectedTask == null ||
        _selectedDate == null ||
        _selectedTime == null ||
        tankName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete all fields.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final scheduledDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    ReminderType type;
    switch (_selectedTask) {
      case 'Fish Feed':
        type = ReminderType.fishFeed;
        break;
      case 'Water Change':
        type = ReminderType.waterChange;
        break;
      case 'Tank Cleaning':
        type = ReminderType.tankCleaning;
        break;
      case 'Filter Wash':
        type = ReminderType.filterWash;
        break;
      default:
        return;
    }

    final result = await Provider.of<ReminderController>(context, listen: false)
        .addReminder(
      tankName: tankName,
      type: type,
      scheduledDate: scheduledDate,
    );

    if (result == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_selectedTask set for $tankName!'),
          backgroundColor: AppColors.aquaMain,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $result'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          'Schedule Maintenance',
          style: TextStyle(
              fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
        backgroundColor: cs.surface,
        iconTheme: IconThemeData(color: cs.onSurface),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(context, 'Tank Name'),
            _buildInputContainer(
              context: context,
              child: TextField(
                controller: _tankNameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Main 55 Gallon Reef',
                  hintStyle:
                  TextStyle(color: cs.onSurface.withOpacity(0.4)),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    color: cs.onSurface, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 30),

            _sectionTitle(context, 'Select Task Type'),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: _tasks.map((task) => _buildTaskChip(context, task)).toList(),
            ),
            const SizedBox(height: 30),

            _sectionTitle(context, 'Schedule Date & Time'),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: _buildInputContainer(
                context: context,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 24, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _selectTime(context),
              child: _buildInputContainer(
                context: context,
                child: Row(
                  children: [
                    Icon(Icons.access_time_filled,
                        size: 24, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime == null
                          ? 'Select Time'
                          : 'Time: ${_selectedTime!.format(context)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.error.withOpacity(0.1),
                      foregroundColor: cs.error,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveReminder(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.aquaMain,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Set Reminder',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---- Helpers -----

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildInputContainer({
    required BuildContext context,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }

  Widget _buildTaskChip(BuildContext context, String task) {
    bool isSelected = _selectedTask == task;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedTask = task),
      child: Chip(
        label: Text(task),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        backgroundColor:
        isSelected ? AppColors.primaryBlue : cs.surfaceVariant,
        side: BorderSide(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
