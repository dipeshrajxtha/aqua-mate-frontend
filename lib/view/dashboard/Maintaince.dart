import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:aqua_mate/routes/app_routes.dart';
import 'package:aqua_mate/widgets/shared_bottom_nav.dart';
import 'package:aqua_mate/controller/reminder_controller.dart';
import 'package:aqua_mate/model/reminder_model.dart';

// --- Custom Color Palette (Updated for Consistency) ---
class AppColors {
  // Primary App Colors (Consistent with other screens)
  static const Color primaryGreen = Color(0xFF00C782); // Primary Accent (formerly aquaMain)
  static const Color accentCyan = Color(0xFF6DF0FB); // Header Gradient Start
  static const Color lightBackground = Color(0xFFF7F9FC); // Consistent Screen BG
  static const Color darkText = Color(0xFF1E272E); // Dark Text

  // State-based Colors (Refined for professionalism)
  static const Color urgentIcon = Color(0xFFEF5350); // Bright Red (Error/Overdue)
  static const Color upcomingIcon = Color(0xFF007bff); // Standard Blue
  static const Color upcomingBg = Color(0xFFE6F5FF); // Light Blue Background

  // Overdue state colors
  static const Color overdueCardColor = Color(0xFFFFECEC); // Very light red background
  static const Color overdueBorderColor = urgentIcon;
}

typedef MaintenanceTask = ReminderModel;

// --- Main Maintenance Screen ---
class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ReminderController>().fetchReminders();
    });
  }

  String _formatSchedule(DateTime dateTime) {
    return DateFormat('dd MMM, hh:mm a').format(dateTime);
  }

  Widget _buildTaskCard({
    required BuildContext context,
    required MaintenanceTask task,
    required Color iconColor,
    required Color iconBgColor,
    required IconData icon,
  }) {
    final reminderController = context.read<ReminderController>();
    final bool isOverdue = task.isOverdue;

    // Determine colors based on overdue status
    final Color cardColor = isOverdue ? AppColors.overdueCardColor : Colors.white;
    final Color accentColor = isOverdue ? AppColors.overdueBorderColor : iconColor;
    final Color titleColor = isOverdue ? AppColors.overdueBorderColor : AppColors.darkText;
    final Color detailColor = isOverdue ? AppColors.overdueBorderColor : Colors.grey[600]!;

    return Card(
      elevation: isOverdue ? 6 : 4, // Slightly raised for overdue tasks
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isOverdue
            ? BorderSide(color: AppColors.overdueBorderColor.withOpacity(0.7), width: 1)
            : BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 18),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // Use a subtle background color for the icon circle
                color: isOverdue
                    ? AppColors.overdueBorderColor.withOpacity(0.1)
                    : iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),

            const SizedBox(width: 16),

            // Title + Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task.formattedType} - ${task.tankName}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: detailColor),
                      const SizedBox(width: 6),
                      Text(
                        _formatSchedule(task.dueDateTime),
                        style: TextStyle(
                          fontSize: 14,
                          color: detailColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Complete button (Use the primary green for success/completion)
            Tooltip(
              message: 'Mark as Complete',
              child: InkWell(
                onTap: () async {
                  await reminderController.removeReminder(task);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${task.formattedType} for ${task.tankName} marked as complete!'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primaryGreen,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection({
    required BuildContext context,
    required String title,
    required List<MaintenanceTask> tasks,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String emptyText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.darkText,
            ),
          ),
        ),

        if (tasks.isEmpty)
          _buildEmptyState(emptyText)
        else
          ...tasks.map(
                (task) => _buildTaskCard(
              context: context,
              task: task,
              icon: icon,
              iconColor: iconColor,
              iconBgColor: iconBgColor,
            ),
          ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppColors.darkText.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding:
      const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 30),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accentCyan, AppColors.primaryGreen], // Consistent Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30), // Increased radius
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: App Name (Subtle contrast for a premium look)
          const Text(
            'AquaMate',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // Main Title
          const Text(
            'Maintenance Dashboard',
            style: TextStyle(
              fontSize: 28, // Prominent title
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          const Text(
            'Keep your aquarium healthy and thriving with timely reminders.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderController>(
      builder: (context, reminderController, _) {
        return Scaffold(
          backgroundColor: AppColors.lightBackground, // Use consistent light BG

          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryGreen, // Use primary green
            elevation: 10,
            shape: const CircleBorder(),
            child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.reminderSetup);
              reminderController.fetchReminders();
            },
          ),

          bottomNavigationBar: const SharedBottomNav(currentIndex: 0),

          body: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryGreen, // Match indicator color
                  onRefresh: reminderController.fetchReminders,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Urgent Tasks
                        _buildTaskSection(
                          context: context,
                          title:
                          "Urgent Tasks (${reminderController.urgentReminders.length})",
                          tasks: reminderController.urgentReminders,
                          icon: Icons.notifications_active_outlined, // More professional icon
                          iconColor: AppColors.urgentIcon,
                          iconBgColor: AppColors.urgentIcon.withOpacity(0.1),
                          emptyText:
                          "All caught up! No urgent tasks right now.",
                        ),

                        // Upcoming Tasks
                        _buildTaskSection(
                          context: context,
                          title:
                          "Upcoming Tasks (${reminderController.upcomingReminders.length})",
                          tasks: reminderController.upcomingReminders,
                          icon: Icons.event_note_outlined, // More professional icon
                          iconColor: AppColors.upcomingIcon,
                          iconBgColor: AppColors.upcomingBg,
                          emptyText:
                          "Nothing scheduled. Add a reminder to get started.",
                        ),

                        const SizedBox(height: 60), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}