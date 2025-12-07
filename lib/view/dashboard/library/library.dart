import 'package:aqua_mate/view/dashboard/library/salt_water_fish.dart';
import 'package:flutter/material.dart';
import 'package:aqua_mate/widgets/shared_bottom_nav.dart';
import 'package:aqua_mate/routes/app_routes.dart'; // Assuming you have AppRoutes defined

import './fresh_water.dart';

// Define the cohesive color scheme
const Color _primaryColor = Color(0xFF00C782); // Vibrant Green/Teal (from previous pages)
const Color _accentColor = Color(0xFF6DF0FB); // Lighter Teal/Cyan
const Color _darkText = Color(0xFF1E272E); // Dark almost black text
const Color _lightBackground = Color(0xFFF7F9FC); // Light background for contrast

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ------- REFINED HEADER --------
          _buildHeader(context),

          const SizedBox(height: 20),

          // ------- MAIN CONTENT --------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildImageCard(
                    context,
                    label: "Fresh Water Species",
                    description: "Explore fish and plants for freshwater tanks.",
                    imagePath: "assets/images/library/freshwater.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FreshWaterFishPage(),
                        ),
                      );
                    },
                  ),
                  _buildImageCard(
                    context,
                    label: "Salt Water Species",
                    description: "A guide to marine life and corals.",
                    imagePath: "assets/images/library/saltwater.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SaltWaterFishPage(),
                        ),
                      );
                    },
                  ),
                  _buildImageCard(
                    context,
                    label: "Aquascape Designs",
                    description: "Inspiration and guides for planted aquariums.",
                    imagePath: "assets/images/library/aquascape.png",
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),

      // ------- SHARED BOTTOM NAV -------
      bottomNavigationBar: const SharedBottomNav(currentIndex: 2),
    );
  }

  // -------- HEADER WIDGET (Using Cohesive Gradient) --------
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 10,
        left: 20,
        right: 20,
        bottom: 25, // Increased bottom padding
      ),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_accentColor, _primaryColor], // Lighter to darker
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), // More pronounced curve
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row (Logo + Icons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and App Name
              Row(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 30,
                    color: Colors.white, // White logo contrasts better on gradient
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "AquaMate",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                ],
              ),

              // Icons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.white),
                    onPressed: () {
                      // Navigate to Profile page (assuming it's defined in AppRoutes)
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Main Header Text
          const Text(
            "Knowledge Base",
            style: TextStyle(
              fontSize: 28, // Larger and bolder
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Explore our comprehensive species and setup guides.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // -------- IMAGE CARD WIDGET (Modernized with Info) --------
  Widget _buildImageCard(
      BuildContext context, {
        required String label,
        required String description,
        required String imagePath,
        VoidCallback? onTap,
      }) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Opacity(
                    opacity: 0.8, // Slightly more transparent
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Subtle Gradient Overlay (for better text readability on top)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.0)
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
              ),

              // Text Label and Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 3, color: Colors.black45),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        shadows: const [
                          Shadow(blurRadius: 3, color: Colors.black45),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Positioned(
                right: 15,
                top: 15,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}