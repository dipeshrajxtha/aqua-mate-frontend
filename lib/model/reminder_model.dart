import 'package:flutter/material.dart';

enum ReminderType {
  fishFeed,
  waterChange,
  tankCleaning,
  filterWash,
}

extension ReminderTypeExtension on ReminderType {
  String toShortString() => toString().split('.').last;
}

class ReminderModel {
  final String? id;
  final String tankName;
  final ReminderType type;
  final DateTime dueDateTime; // MATCH BACKEND

  ReminderModel({
    this.id,
    required this.tankName,
    required this.type,
    required this.dueDateTime,
  });

  String get formattedType {
    String name = type.toShortString();
    return name[0].toUpperCase() +
        name.substring(1).replaceAllMapped(
          RegExp(r'([A-Z])'),
              (m) => " ${m.group(0)}",
        );
  }

  bool get isOverdue => dueDateTime.isBefore(DateTime.now());
  bool get isUpcoming => dueDateTime.isAfter(DateTime.now());

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tankName': tankName,
      'type': type.toShortString(),
      'dueDateTime': dueDateTime.toIso8601String(), // MATCH BACKEND
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    ReminderType _stringToReminderType(String typeString) {
      switch (typeString) {
        case "fishFeed":
          return ReminderType.fishFeed;
        case "waterChange":
          return ReminderType.waterChange;
        case "tankCleaning":
          return ReminderType.tankCleaning;
        case "filterWash":
          return ReminderType.filterWash;
        default:
          return ReminderType.fishFeed;
      }
    }

    return ReminderModel(
      id: json['_id'],
      tankName: json['tankName'],
      type: _stringToReminderType(json['type']),
      dueDateTime: DateTime.parse(json['dueDateTime']).toLocal(),
    );
  }
}
