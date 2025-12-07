// lib/view/dashboard/aquarium_setup.dart

import 'package:flutter/material.dart';
import 'package:aqua_mate/routes/app_routes.dart';
import 'package:aqua_mate/widgets/shared_bottom_nav.dart';

// --- Custom Fish Painter ---
class FishPainter extends CustomPainter {
  final Color fishColor;

  FishPainter({required this.fishColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fishColor
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: size.width * 0.6,
        height: size.height * 0.5,
      ),
      const Radius.circular(20),
    );
    canvas.drawRRect(bodyRect, paint);

    // Tail
    final tailPath = Path()
      ..moveTo(centerX - size.width * 0.3, centerY)
      ..lineTo(centerX - size.width * 0.5, centerY - size.height * 0.2)
      ..lineTo(centerX - size.width * 0.5, centerY + size.height * 0.2)
      ..close();
    canvas.drawPath(tailPath, paint);

    // Eye
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;

    final eyeOffset =
    Offset(centerX + size.width * 0.15, centerY - size.height * 0.1);

    canvas.drawCircle(eyeOffset, size.width * 0.08, eyePaint);
    canvas.drawCircle(eyeOffset, size.width * 0.04, pupilPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AquariumColors {
  static const Color lightBlue = Color(0xFFB3E5FC);
  static const Color lightGreen = Color(0xFFC8E6C9);
  static const Color tealMain = Color(0xFF80DED0);
  static const Color tealDark = Color(0xFF29A091);
  static const Color navBarColor = Colors.white;
  static const Color aquaMain = Color(0xFF4ade80);
}

class AquariumSetupPage extends StatefulWidget {
  const AquariumSetupPage({super.key});

  @override
  State<AquariumSetupPage> createState() => _AquariumSetupPageState();
}

class _AquariumSetupPageState extends State<AquariumSetupPage> {
  /// Stores user's selection: "fresh" or "salt"
  String? _selectedAquariumType;

  // Converts UI selection to backend ENUM
  String _mapToBackendEnum(String type) {
    switch (type) {
      case "fresh":
        return "FRESHWATER";
      case "salt":
        return "SALTWATER";
      default:
        return "";
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AquariumColors.tealMain, AquariumColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 8),
              const Text(
                'AquaMate',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.notifications_none, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Icon(Icons.person_outline, color: Colors.white, size: 28),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Step 1 of 5',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                '35%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AquariumColors.tealDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.35,
              minHeight: 8,
              valueColor: AlwaysStoppedAnimation(AquariumColors.tealDark),
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFishIcon({required Color fishColor}) {
    return CustomPaint(
      size: const Size(80, 80),
      painter: FishPainter(fishColor: fishColor),
    );
  }

  Widget _buildAquariumCard({
    required String title,
    required String subtitle,
    required Color cardColor,
    required String type,
    required Color fishColor,
  }) {
    final isSelected = _selectedAquariumType == type;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedAquariumType = type);

        final enumValue = _mapToBackendEnum(type);

        Navigator.pushNamed(
          context,
          AppRoutes.aquariumStepForm,
          arguments: {"aquariumType": enumValue},
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AquariumColors.tealDark : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: _buildFishIcon(fishColor: fishColor)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Aquarium Setup',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  'Step by step guidance',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Choose Aquarium type',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildAquariumCard(
                    title: "Fresh Water",
                    subtitle: "For beginner/experienced",
                    cardColor: AquariumColors.lightBlue,
                    type: "fresh",
                    fishColor: const Color(0xFFE91E63),
                  ),
                  _buildAquariumCard(
                    title: "Salt Water",
                    subtitle: "For beginner/experienced",
                    cardColor: AquariumColors.lightGreen,
                    type: "salt",
                    fishColor: const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 1),
    );
  }
}
