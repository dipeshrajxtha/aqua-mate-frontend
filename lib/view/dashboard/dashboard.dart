import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aqua_mate/routes/app_routes.dart';
import 'package:aqua_mate/widgets/shared_bottom_nav.dart';
import 'package:aqua_mate/controller/aquarium_controller.dart';
import 'package:aqua_mate/model/aquarium_model.dart';

// --- Define Consistent Colors ---
const Color _primaryGreen = Color(0xFF00C782); // Consistent Primary
const Color _accentCyan = Color(0xFF6DF0FB); // Consistent Accent
const Color _darkText = Color(0xFF1E272E);
const Color _lightBackground = Color(0xFFF7F9FC);

// --- Card Widget (Professional Style) ---
class AquariumInfoCard extends StatelessWidget {
  final Aquarium tank;

  const AquariumInfoCard({
    super.key,
    required this.tank,
  });

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: _darkText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Tank Detail Page
        // Use the primary green color for the detail page transition if needed
        // Navigator.pushNamed(context, AppRoutes.aquariumDetails, arguments: tank);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, // Use pure white for a crisp contrast
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Name and Icon
            Row(
              children: [
                const Icon(Icons.water_rounded, color: _primaryGreen, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tank.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: _darkText,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),

            const Divider(height: 25, thickness: 1, color: Color(0xFFF0F8FF)),

            // Details section
            _buildDetailRow("Type", tank.aquariumType),
            _buildDetailRow("Size", "${tank.tankSize} Liters"),
            _buildDetailRow("Shape", tank.tankShape),
            _buildDetailRow("Temperature", "${tank.temperature}°C"),
            _buildDetailRow("Location", tank.location),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const double _padding = 20.0; // Increased padding for a cleaner look

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<AquariumController>().fetchAquariums();
      }
    });
  }

  // UPDATED: Fish Compatibility Checker Card (CTA-focused style with consistent colors)
  Widget _buildCompatibilityCheckerCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.compatibilityChecker);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        margin: const EdgeInsets.only(bottom: 25, top: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            // Using a slightly varied gradient, starting with primary green
            colors: [_primaryGreen, Color(0xFF00B376)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryGreen.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          children: [
            Icon(Icons.compare_arrows_rounded, color: Colors.white, size: 35),
            SizedBox(height: 10),
            Text(
              "Compatibility Checker",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Check if your species are compatible",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Consumer<AquariumController>(
              builder: (context, controller, child) {
                return _buildBody(controller);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 1),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // UPDATED: Header with consistent gradient colors and typography
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding:
      EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 10, left: 24, right: 24, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_accentCyan, _primaryGreen], // Consistent gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // App Name and Logo (Updated to use Image.asset)
              Row(
                children: [
                  // --- START LOGO CHANGE ---
                  Image.asset(
                    "assets/images/logo.png", // Use the logo path
                    height: 35, // Adjusted size
                    color: Colors.white, // Ensure it contrasts with the gradient
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "AquaMate",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Keep text white for contrast
                    ),
                  ),
                  // --- END LOGO CHANGE ---
                ],
              ),
              // Action Icons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 26),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Greeting
          const Text(
            "Welcome Back!",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "View your tanks and track key metrics.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AquariumController controller) {
    if (controller.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child:
          CircularProgressIndicator(color: _primaryGreen),
        ),
      );
    }

    if (controller.aquariums.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(_padding),
        children: [
          _buildCompatibilityCheckerCard(context),
          const SizedBox(height: 50),
          Center(
            child: Column(
              children: [
                Icon(Icons.bubble_chart_outlined, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                const Text(
                  "No aquariums found.\nTap the '+' button to add your first tank!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.only(left: _padding, right: _padding, top: 0),
      children: [
        _buildCompatibilityCheckerCard(context),

        const Text(
          "Your Aquariums",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: _darkText,
          ),
        ),

        const SizedBox(height: 18),

        ...controller.aquariums.map(
              (tank) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AquariumInfoCard(tank: tank),
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  // UPDATED: FAB color matches the primary green
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.aquariumSetup);
      },
      backgroundColor: _primaryGreen, // Use primary green
      elevation: 10,
      shape: const CircleBorder(),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 35),
    );
  }
}