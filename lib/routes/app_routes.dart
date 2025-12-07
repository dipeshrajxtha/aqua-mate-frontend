// lib/routes/app_routes.dart (Updated)

import 'package:flutter/material.dart';

import 'package:aqua_mate/view/auth/loginpage.dart';
import 'package:aqua_mate/view/auth/signup.dart';
import 'package:aqua_mate/view/onboarding/splash_screen.dart';
import 'package:aqua_mate/view/dashboard/aquarium_setup.dart';
import 'package:aqua_mate/view/dashboard/aquarium_step_form.dart';
import 'package:aqua_mate/view/dashboard/dashboard.dart';
import 'package:aqua_mate/view/dashboard/Maintaince.dart';
import 'package:aqua_mate/view/dashboard/library/library.dart';
import 'package:aqua_mate/view/dashboard/settings.dart';
import 'package:aqua_mate/view/dashboard/reminderSetupForm.dart'; // Corrected path to match the file structure above
import 'package:aqua_mate/view/dashboard/profile_page.dart';
import 'package:aqua_mate/view/compatibility/compatibility_checker.dart';


/// Central place to keep every named route used in the app.
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String maintenance = '/maintenance';
  static const String library = '/library';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String reminderSetup = '/reminder-setup';
  static const String aquariumSetup = '/aquarium-setup';
  static const String aquariumStepForm = '/aquarium-step-form';
  static const compatibilityChecker = '/compatibilityChecker';


  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginPage(),
    signup: (_) => const SignupPage(),
    dashboard: (_) => const DashboardPage(),
    maintenance: (_) => const MaintenanceScreen(),
    library: (_) => const LibraryPage(),
    settings: (_) => const SettingsPage(),
    profile: (_) => const ProfilePage(),
    reminderSetup: (_) => const ReminderSetupForm(),
    aquariumSetup: (_) => const AquariumSetupPage(),
    aquariumStepForm: (_) => const AquariumStepFormPage(),
    compatibilityChecker: (context) => const CompatibilityCheckerPage(),
    // compatibilityChecker: (context) => const CompatibilityCheckerPage(),
  };
}