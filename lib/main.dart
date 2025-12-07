import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Your core imports
import 'routes/app_routes.dart';
import 'controller/reminder_controller.dart';
import 'controller/maintenance_controller.dart';
import 'controller/aquarium_controller.dart'; // <--- NEW IMPORT

void main() {
  // Add necessary initialization (e.g., local notifications) before runApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Primary Controllers (Independent Data Sources)
        ChangeNotifierProvider(create: (_) => ReminderController()),
        ChangeNotifierProvider(create: (_) => AquariumController()), // <--- NEW PROVIDER

        // 2. Dependent Controller (Uses ProxyProvider)
        ChangeNotifierProxyProvider<ReminderController, MaintenanceController>(
          create: (context) => MaintenanceController(
            reminderController: context.read<ReminderController>(),
          ),
          update: (context, reminderController, maintenanceController) {
            // This logic tells the existing MaintenanceController to update its internal state.
            if (maintenanceController == null) {
              return MaintenanceController(reminderController: reminderController);
            }
            // Ensure you have this method in your MaintenanceController!
            maintenanceController.updateDependency(reminderController);
            return maintenanceController;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aqua Mate',
        theme: ThemeData(
          // Using a consistent seed color
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF67D7A3)),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splash,
        // Using the centralized routes map
        routes: AppRoutes.routes,
      ),
    );
  }
}