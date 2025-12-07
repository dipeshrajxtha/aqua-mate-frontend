import 'package:flutter/material.dart';

class SaltWaterFishDetailPage extends StatelessWidget {
  final String name;
  final String scientific;
  final String image;
  final Map<String, dynamic> details;

  const SaltWaterFishDetailPage({
    super.key,
    required this.name,
    required this.scientific,
    required this.image,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    // Define the salt water color scheme
    const Color primaryColor = Colors.blueAccent;
    const Color cardBackgroundColor = Color(0xFFF0F8FF); // Very light, icy blue

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
        elevation: 4.0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🐠 Image Header Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30), // Slightly larger curve
                bottomRight: Radius.circular(30),
              ),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 280, // Consistent height
                fit: BoxFit.cover,
              ),
            ),

            // 🐟 Details Section
            Padding(
              padding: const EdgeInsets.all(20.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Name and Scientific Name ---
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E1E)),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    scientific,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.lightBlue, // Using a lighter blue for salt water
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- Quick Info Card (New structure) ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1), // Subtle blue shadow
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow("Care Level", details["care"], Icons.health_and_safety_outlined, primaryColor),
                        _buildDivider(),
                        _buildInfoRow("Tank Size", details["tank"], Icons.waves, primaryColor),
                        _buildDivider(),
                        _buildInfoRow("Temperature", details["temp"], Icons.thermostat_outlined, primaryColor),
                        _buildDivider(),
                        _buildInfoRow("pH Level", details["ph"], Icons.science_outlined, primaryColor),
                        _buildDivider(),
                        _buildInfoRow("Food Type", details["food"], Icons.restaurant_menu_outlined, primaryColor),
                        _buildDivider(),
                        _buildInfoRow("Behavior", details["behavior"], Icons.pets_outlined, primaryColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- About Section ---
                  const Text(
                    "About the Fish",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E)),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    details["about"],
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 辅助函数 (Helper Widget)

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Divider(height: 1, color: Color(0xFFC0C0C0)), // Lighter divider
    );
  }

  // 🎣 Enhanced _buildInfoRow with Icon and Color
  Widget _buildInfoRow(String title, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor.withOpacity(0.7)),
          const SizedBox(width: 12),
          SizedBox(
            width: 100, // Fixed width for titles ensures alignment
            child: Text(
              "$title:",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242)
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Color(0xFF616161)),
            ),
          )
        ],
      ),
    );
  }
}