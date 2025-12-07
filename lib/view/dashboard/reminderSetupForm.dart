// lib/view/reminders/reminder_setup_form.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/reminder_controller.dart';
import '../../model/reminder_model.dart';

// --- Custom Color Palette ---
class AppColors {
  static const Color aquaMain = Color(0xFF4ade80);
  static const Color primaryBlue = Color(0xFF49AEB1);
  static const Color primaryLight = Color(0xFFE0F7FA);
  static const Color textDark = Color(0xFF1F2937);
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder(BuildContext context) async {
    final tankName = _tankNameController.text.trim();
    if (_selectedTask == null || _selectedDate == null || _selectedTime == null || tankName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete all fields.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final DateTime finalScheduledDate = DateTime(
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

    final result = await Provider.of<ReminderController>(context, listen: false).addReminder(
      tankName: tankName,
      type: type,
      scheduledDate: finalScheduledDate,
    );

    if (result == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedTask} set for $tankName!'),
          backgroundColor: AppColors.aquaMain,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving reminder: $result'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight.withOpacity(0.3),
      appBar: AppBar(
        title: const Text(
          'Schedule Maintenance',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textDark),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tank Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark)),
            const SizedBox(height: 8),
            _buildInputContainer(
              isPicker: false,
              child: TextField(
                controller: _tankNameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Main 55 Gallon Reef',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 30),

            const Text('Select Task Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: _tasks.map((task) => _buildTaskChip(task)).toList(),
            ),
            const SizedBox(height: 30),

            const Text('Schedule Date & Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark)),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () => _selectDate(context),
              child: _buildInputContainer(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 24, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _selectTime(context),
              child: _buildInputContainer(
                child: Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 24, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime == null
                          ? 'Select Time'
                          : 'Time: ${_selectedTime!.format(context)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
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
                      backgroundColor: AppColors.errorRed.withOpacity(0.1),
                      foregroundColor: AppColors.errorRed,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 8,
                    ),
                    child: const Text('Set Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget builder for the common input/picker style
  Widget _buildInputContainer({required Widget child, bool isPicker = true}) {
    return Card(
      elevation: isPicker ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.zero,
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }

  // Widget builder for the Task Chips (Buttons)
  Widget _buildTaskChip(String task) {
    bool isSelected = _selectedTask == task;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTask = task;
        });
      },
      child: Chip(
        label: Text(task),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        backgroundColor: isSelected ? AppColors.primaryBlue.withOpacity(0.9) : Colors.grey[200],
        side: isSelected ? BorderSide(color: AppColors.primaryBlue, width: 1.5) : BorderSide.none,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}