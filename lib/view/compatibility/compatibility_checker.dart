import 'dart:ui';
import 'package:flutter/material.dart';

class CompatibilityCheckerPage extends StatefulWidget {
  const CompatibilityCheckerPage({super.key});

  @override
  State<CompatibilityCheckerPage> createState() =>
      _CompatibilityCheckerPageState();
}

class _CompatibilityCheckerPageState extends State<CompatibilityCheckerPage> {
  // Colors
  static const Color _primaryAqua = Color(0xFF49AEB1);
  static const Color _secondaryLight = Color(0xFF7EE8FA);
  static const Color _successColor = Color(0xFF2ECC71);
  static const Color _dangerColor = Color(0xFFE74C3C);

  // Data
  final List<Map<String, String>> fishList = const [
    {"name": "Goldfish", "icon": "icons/goldfish.png"},
    {"name": "Betta", "icon": "icons/betta.png"},
    {"name": "Guppy", "icon": "icons/guppy.png"},
    {"name": "Tetra", "icon": "icons/tetra.png"},
    {"name": "Angelfish", "icon": "icons/angelfish.png"},
    {"name": "Molly", "icon": "icons/molly.png"},
    {"name": "Oscar", "icon": "icons/oscar.png"},
  ];

  String? fishA;
  String? fishB;

  final Map<String, List<String>> compatibility = const {
    "Goldfish": ["Tetra", "Molly", "Guppy"],
    "Betta": ["Guppy", "Molly"],
    "Guppy": ["Betta", "Tetra", "Molly"],
    "Tetra": ["Goldfish", "Guppy", "Molly"],
    "Angelfish": ["Tetra", "Molly"],
    "Molly": ["Tetra", "Guppy", "Goldfish"],
    "Oscar": [],
  };

  Map<String, dynamic> _checkCompatibility() {
    if (fishA == null || fishB == null) {
      return {"text": "Select two fish species.", "isCompatible": null};
    }

    if (fishA == fishB) {
      return {
        "text": "✔ $fishA species can live together.",
        "isCompatible": true
      };
    }

    final isCompatible = compatibility[fishA]!.contains(fishB);

    return {
      "text": isCompatible
          ? "✔ Compatible! $fishA and $fishB can live together happily."
          : "✖ Not Recommended. These species may not match in temperament or requirements.",
      "isCompatible": isCompatible,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _checkCompatibility();

    return Scaffold(
      backgroundColor: const Color(0xFFF5FEFF),
      appBar: _buildGlassAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(), // UPDATED HEADER

            const SizedBox(height: 30),
            _buildDropdown("Select Fish", fishA,
                    (v) => setState(() => fishA = v)),

            _buildCenterSwapIcon(),

            _buildDropdown("Select Fish", fishB,
                    (v) => setState(() => fishB = v)),

            const SizedBox(height: 40),
            _buildSectionTitle("Compatibility Result"),
            const SizedBox(height: 15),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _buildResultCard(result),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // APPBAR
  // ----------------------------------------------------------------
  PreferredSizeWidget _buildGlassAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AppBar(
            backgroundColor: _secondaryLight.withOpacity(0.45),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "AquaMate Tool",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontSize: 22,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // UPDATED HEADER - EXACTLY LIKE SCREENSHOT
  // ----------------------------------------------------------------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aquarium Compatibility",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Check if fish can live together",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  Widget _buildDropdown(
      String label, String? value, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value != null
              ? _primaryAqua.withOpacity(0.8)
              : Colors.grey.shade300,
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_rounded,
              size: 28, color: _primaryAqua),
          hint: Text(
            label,
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600),
          ),
          items: fishList.map((fish) {
            return DropdownMenuItem(
              value: fish["name"],
              child: Row(
                children: [
                  _buildFishAvatar(fish["name"]!),
                  const SizedBox(width: 14),
                  Text(
                    fish["name"]!,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFishAvatar(String name) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _secondaryLight.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          name[0],
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryAqua),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  Widget _buildCenterSwapIcon() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 18),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _primaryAqua.withOpacity(0.12),
        ),
        child:
        const Icon(Icons.sync_alt_rounded, color: _primaryAqua, size: 28),
      ),
    );
  }

  // ----------------------------------------------------------------
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }

  // ----------------------------------------------------------------
  Widget _buildResultCard(Map<String, dynamic> result) {
    bool? comp = result["isCompatible"];

    Color accent = comp == true
        ? _successColor
        : comp == false
        ? _dangerColor
        : Colors.grey.shade500;

    IconData icon = comp == true
        ? Icons.check_circle_rounded
        : comp == false
        ? Icons.error_rounded
        : Icons.info_rounded;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          key: ValueKey(result["text"]),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.25),
                accent.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: accent.withOpacity(0.35), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent, size: 34),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  result["text"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
