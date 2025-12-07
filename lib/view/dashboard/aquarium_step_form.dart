// lib/view/dashboard/aquarium_step_form.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/shared_bottom_nav.dart';
// Note: Ensure you have a stub/definition for AquariumController
import '../../controller/aquarium_controller.dart';
import '../../routes/app_routes.dart';

class AquariumStepFormColors {
  static const Color tealStart = Color(0xFF7FEDE0);
  static const Color tealEnd = Color(0xFF29A091); // Main Accent
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF29A091);
  static const Color inputBg = Color(0xFFF7FAFB);
  static const Color subtleText = Color(0xFF6B7280);
  static const Color danger = Color(0xFFE53935);
  static const Color lightGrey = Color(0xFFEBEFF2);
}

class AquariumStepFormPage extends StatefulWidget {
  const AquariumStepFormPage({super.key});

  @override
  State<AquariumStepFormPage> createState() => _AquariumStepFormPageState();
}

class _AquariumStepFormPageState extends State<AquariumStepFormPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 5;

  // FORM CONTROLLERS
  final TextEditingController _tankNameController = TextEditingController();
  final TextEditingController _tankSizeController = TextEditingController();
  final TextEditingController _tankShapeController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController(text: "Created via AquaMate setup wizard");

  String aquariumType = "FRESHWATER"; // default

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
    // Initialize controller values based on defaults or stored data if needed
    // Example: _tankShapeController.text = "Rectangular";
  }

  void _pageListener() {
    final newPage =
    _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
    if (newPage != _currentPage) {
      setState(() => _currentPage = newPage);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['aquariumType'] is String) {
      aquariumType = args['aquariumType'];
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    _tankNameController.dispose();
    _tankSizeController.dispose();
    _tankShapeController.dispose();
    _tempController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ----------------- Helpers -----------------

  String _cleanNumber(String input) {
    return input.replaceAll(RegExp(r'[^0-9.]'), '');
  }

  int? _tryParseInt(String input) {
    final cleaned = _cleanNumber(input);
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  double? _tryParseDouble(String input) {
    final cleaned = _cleanNumber(input);
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  void _goNext() {
    // Basic validation before advancing step
    if (_currentPage == 0 && _tankNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name for your aquarium.")),
      );
      return;
    }

    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _saveAquariumSetup();
    }
  }

  void _goPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveAquariumSetup() async {
    // Trim values
    final String name = _tankNameController.text.trim();
    final String sizeText = _tankSizeController.text.trim();
    final String shape = _tankShapeController.text.trim();
    final String tempText = _tempController.text.trim();
    final String location = _locationController.text.trim();
    final String description = _descriptionController.text.trim();

    // Basic validation for ALL fields (moved to final step for submission)
    if (name.isEmpty ||
        sizeText.isEmpty ||
        shape.isEmpty ||
        tempText.isEmpty ||
        location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please ensure all steps are completed and fields are filled.")),
      );
      return;
    }

    final int? tankSize = _tryParseInt(sizeText);
    final double? temp = _tryParseDouble(tempText);

    if (tankSize == null || tankSize <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Tank size must be a valid positive number.")),
      );
      return;
    }

    if (temp == null || temp <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Temperature must be a valid positive number.")),
      );
      return;
    }

    final payload = {
      "name": name,
      "aquariumType": aquariumType,
      "tankSize": tankSize,
      "tankShape": shape,
      "temperature": temp,
      "location": location,
      "description": description.isNotEmpty
          ? description
          : "Created via AquaMate setup wizard",
    };

    // Note: Provider dependency lookup should be outside of async gap if possible
    // but often needs to be inside if the context isn't available externally.
    final controller = Provider.of<AquariumController>(context, listen: false);

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text("Saving aquarium…"),
        duration: Duration(minutes: 5), // Long duration for continuous progress
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      final success = await controller.addAquarium(payload);

      messenger.clearSnackBars();

      if (success) {
        await controller.fetchAquariums();

        messenger.showSnackBar(
          const SnackBar(
            content: Text("Aquarium created successfully!"),
            backgroundColor: AquariumStepFormColors.accent,
          ),
        );

        // Navigate to DASHBOARD and remove all routes below it
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.dashboard,
              (route) => false,
        );

      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Failed to save aquarium. Please try again."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ----------------- UI Component Refinements -----------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AquariumStepFormColors.tealStart, AquariumStepFormColors.tealEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4))
        ],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _goPrevious,
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("AquaMate Setup Wizard",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text("Creating your perfect habitat",
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 48), // Spacer for back button alignment
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentPage + 1} of $_totalSteps',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AquariumStepFormColors.tealEnd,
                ),
              ),
              Text(
                '${((_currentPage + 1) / _totalSteps * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AquariumStepFormColors.subtleText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_totalSteps, (index) {
              final isActive = index <= _currentPage;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 10,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AquariumStepFormColors.tealEnd
                        : AquariumStepFormColors.lightGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
    String? hint,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
            if (suffix != null)
              Text(suffix,
                  style: const TextStyle(
                      fontSize: 13, color: AquariumStepFormColors.subtleText)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AquariumStepFormColors.inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.text.isNotEmpty ? AquariumStepFormColors.tealStart : AquariumStepFormColors.lightGrey,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (v) {
              setState(() {});
              if (onChanged != null) onChanged(v);
            },
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontWeight: FontWeight.normal, color: AquariumStepFormColors.subtleText),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              border: InputBorder.none, // Remove default border
            ),
          ),
        ),
      ],
    );
  }

  // --- Step Content Wrapper for Consistent Styling ---
  Widget _buildStepContent(String title, Widget content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AquariumStepFormColors.accent,
            ),
          ),
          Text(
            aquariumType == "FRESHWATER" ? "Freshwater Setup" : "Saltwater Setup",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AquariumStepFormColors.subtleText,
            ),
          ),
          const Divider(height: 30, thickness: 1.5, color: AquariumStepFormColors.lightGrey),
          content,
        ],
      ),
    );
  }

  // ----------------- Steps -----------------

  Widget _step1() {
    return _buildStepContent(
      "1. Basic Tank Info",
      Column(
        children: [
          _buildInputField(
              label: "Aquarium Name",
              controller: _tankNameController,
              hint: "e.g. Living Room Reef"),
          const SizedBox(height: 25),
          _buildInputField(
            label: "Tank Size",
            controller: _tankSizeController,
            keyboardType: TextInputType.number,
            suffix: "Gallons",
            hint: "e.g. 55",
          ),
        ],
      ),
    );
  }

  Widget _step2() {
    final bool isRectangular = _tankShapeController.text == "Rectangular";
    final bool isCube = _tankShapeController.text == "Cube";

    return _buildStepContent(
      "2. Tank Shape",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
              label: "Specify Tank Shape",
              controller: _tankShapeController,
              hint: "Rectangular / Cube / Custom"),
          const SizedBox(height: 20),
          const Text(
            'Quick Select:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _tankShapeController.text = "Rectangular";
                    setState(() {});
                  },
                  icon: Icon(Icons.crop_3_2, color: isRectangular ? Colors.white : AquariumStepFormColors.accent),
                  label: const Text("Rectangular"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isRectangular ? AquariumStepFormColors.accent : Colors.white,
                      foregroundColor: isRectangular ? Colors.white : AquariumStepFormColors.subtleText,
                      elevation: isRectangular ? 4 : 1,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isRectangular ? AquariumStepFormColors.accent : AquariumStepFormColors.lightGrey)
                      )
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _tankShapeController.text = "Cube";
                    setState(() {});
                  },
                  icon: Icon(Icons.square_foot, color: isCube ? Colors.white : AquariumStepFormColors.accent),
                  label: const Text("Cube"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isCube ? AquariumStepFormColors.accent : Colors.white,
                      foregroundColor: isCube ? Colors.white : AquariumStepFormColors.subtleText,
                      elevation: isCube ? 4 : 1,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isCube ? AquariumStepFormColors.accent : AquariumStepFormColors.lightGrey)
                      )
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _step3() {
    return _buildStepContent(
      "3. Environment",
      Column(
        children: [
          _buildInputField(
            label: "Target Water Temperature",
            controller: _tempController,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            suffix: "°C",
            hint: "e.g. 25.5",
          ),
        ],
      ),
    );
  }

  Widget _step4() {
    return _buildStepContent(
      "4. Location & Notes",
      Column(
        children: [
          _buildInputField(
              label: "Aquarium Location",
              controller: _locationController,
              hint: "Living room, Bedroom, Office"),
          const SizedBox(height: 25),
          _buildInputField(
            label: "Description (Optional)",
            controller: _descriptionController,
            hint: "Short note about this aquarium (e.g., first tank, planted)",
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _step5() {
    return _buildStepContent(
      "5. Review & Finish",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AquariumStepFormColors.inputBg,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AquariumStepFormColors.tealStart, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _reviewRow("Type", aquariumType),
                const SizedBox(height: 10),
                _reviewRow("Name", _tankNameController.text),
                _reviewRow("Tank Size", "${_tankSizeController.text} gal"),
                _reviewRow("Shape", _tankShapeController.text),
                _reviewRow("Temperature", "${_tempController.text} °C"),
                _reviewRow("Location", _locationController.text),
                const SizedBox(height: 15),
                const Text("Description:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  _descriptionController.text.isNotEmpty
                      ? _descriptionController.text
                      : "(No description provided)",
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic, color: AquariumStepFormColors.subtleText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tap "Complete Setup" to save your new aquarium and go to the dashboard.',
            style: TextStyle(
                fontSize: 14,
                color: AquariumStepFormColors.subtleText,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
              width: 140,
              child: Text("$label:",
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87))),
          Expanded(
              child: Text(value.isEmpty ? "Required" : value,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: value.isEmpty ? AquariumStepFormColors.danger : AquariumStepFormColors.accent))),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    final isLast = _currentPage == _totalSteps - 1;
    // Safely retrieve the controller; assume a default state if not found (though Provider should guarantee it)
    final controller = Provider.of<AquariumController>(context);
    final bool isLoading = controller.isLoading;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : _goPrevious,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: BorderSide(
                    color: _currentPage == 0
                        ? AquariumStepFormColors.danger
                        : AquariumStepFormColors.lightGrey,
                    width: 1.5
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                _currentPage == 0 ? "Cancel" : "Previous",
                style: TextStyle(
                    color: _currentPage == 0
                        ? AquariumStepFormColors.danger
                        : Colors.black87,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading ? null : _goNext,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AquariumStepFormColors.accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 6, // Increased elevation for emphasis
              ),
              child: isLoading
                  ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
                  : Text(isLast ? "Complete Setup" : "Next",
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- Build -----------------

  @override
  Widget build(BuildContext context) {
    final steps = [_step1(), _step2(), _step3(), _step4(), _step5()];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                // Block manual swipes to enforce step progression
                physics: const NeverScrollableScrollPhysics(),
                children: steps,
              ),
            ),
            _buildButtons(),
            // Ensure SharedBottomNav is correctly implemented elsewhere
            const SharedBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}