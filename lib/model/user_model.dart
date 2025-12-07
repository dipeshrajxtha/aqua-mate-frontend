// lib/model/user_model.dart

// Note: Ensure you have a dependency on 'package:flutter/material.dart'
// if using it in other parts of the app.
import 'package:flutter/material.dart';

class UserModel {
  // Required fields for persistence
  final String id;
  final String fullName;
  final String email;
  final String token; // CRITICAL: Used for API authorization

  // Optional fields
  final String password; // Used only for registration/login payload, often blank after login
  final String gender;
  final String dob;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.token, // Must be required

    // Non-essential for session, but necessary for data consistency
    this.password = '',
    this.gender = '',
    this.dob = '',
    this.profilePicture,
  });

  // Factory to create a user from JSON data (used when logging in)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Handles MongoDB _id or a generic id field
      id: json['_id'] ?? json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',

      // The token is often attached directly to the root response or passed via copyWith
      token: json['token'] as String? ?? '',

      password: '', // Password is never returned by the backend
      gender: json['gender'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      profilePicture: json['profilePicture'] as String?,
    );
  }

  // Converts the user object to JSON for saving in SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'token': token,
      'gender': gender,
      'dob': dob,
      'profilePicture': profilePicture,
    };
  }

  // Method to easily create a copy of the object with some changed values.
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? token,
    String? password,
    String? gender,
    String? dob,
    String? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      token: token ?? this.token, // Crucial for updating the token after login
      password: password ?? this.password,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}