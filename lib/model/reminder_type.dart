enum ReminderType {
  fishFeed,
  waterChange,
  tankCleaning,
  filterWash,
}

class ReminderModel {
  final String tankName;
  final ReminderType type;
  final DateTime scheduledDate;

  ReminderModel({
    required this.tankName,
    required this.type,
    required this.scheduledDate,
  });

  // Convert enum to readable string
  String get formattedType {
    String name = type.toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1).replaceAllMapped(
      RegExp(r'([A-Z])'),
          (m) => " ${m.group(0)}",
    );
  }

  // Helpers
  bool get isOverdue => scheduledDate.isBefore(DateTime.now());
  bool get isUpcoming => scheduledDate.isAfter(DateTime.now());
}