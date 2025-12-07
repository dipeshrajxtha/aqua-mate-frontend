// lib/model/maintenance_model.dart

class MaintenanceTask {
  final String id;
  final String task;
  final DateTime scheduledFor;

  MaintenanceTask({
    required this.id,
    required this.task,
    required this.scheduledFor,
  });

  // --- Helpful factory methods if you load from JSON ---
  factory MaintenanceTask.fromJson(Map<String, dynamic> json) {
    return MaintenanceTask(
      id: json["id"],
      task: json["task"],
      scheduledFor: DateTime.parse(json["scheduledFor"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "task": task,
      "scheduledFor": scheduledFor.toIso8601String(),
    };
  }
}
