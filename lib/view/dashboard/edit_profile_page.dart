// lib/view/dashboard/edit_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../global/user_session.dart';
import '../../model/user_model.dart';
import '../../controller/profile_controller.dart'; // Ensure this is imported for profileController usage

// Define a common color scheme for professionalism and attractiveness
const Color _primaryColor = Color(0xFF00C782); // Vibrant Green/Teal
const Color _secondaryColor = Color(0xFF333333); // Dark text color
const Color _backgroundColor = Color(0xFFF7F9FC); // Light background for contrast
const Color _accentColor = Color(0xFF6DF0FB); // Lighter Teal/Cyan for gradient/accent
const Color _errorColor = Color(0xFFEF5350); // Red for errors/logout

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  XFile? _pickedImageXFile;
  DateTime? _selectedDob;

  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserFromSession();
  }

  Future<void> _loadUserFromSession() async {
    currentUser = await UserSession.getUser();

    if (currentUser != null) {
      _fullNameController.text = currentUser!.fullName;

      if (currentUser!.dob.isNotEmpty && currentUser!.dob != "1900-01-01") {
        final parsed = DateTime.tryParse(currentUser!.dob);
        if (parsed != null) {
          _selectedDob = parsed;
          // Use the format that matches the date picker display
          _dobController.text = DateFormat('dd MMM, yyyy').format(parsed);
        }
      }
    }

    setState(() {}); // Refresh UI
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() => _pickedImageXFile = picked);
    }
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      builder: (context, child) {
        // Optional: Customizing the DatePicker theme for professionalism
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: _secondaryColor, // Day colors
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('dd MMM, yyyy').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (currentUser == null) return;

    final dobPayload = _selectedDob != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDob!)
        : currentUser!.dob;

    // Show a persistent loading indicator while saving
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(width: 16),
            Text("Saving profile...", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: _primaryColor,
        duration: Duration(seconds: 60), // Keep visible until update finishes
      ),
    );

    final result = await profileController.updateProfile(
      userId: currentUser!.id,
      fullName: _fullNameController.text,
      dob: dobPayload,
      profilePicture: _pickedImageXFile,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide loading indicator

    if (result.startsWith("Profile updated")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: _primaryColor),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $result"), backgroundColor: _errorColor),
      );
    }
  }

  void _logout() async {
    await UserSession.clear();
    // Use an animated route transition for a smoother user experience
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  ImageProvider getProfileImage() {
    const String fallback = "assets/images/library/user01.png"; // Placeholder path

    if (_pickedImageXFile != null) {
      return FileImage(File(_pickedImageXFile!.path));
    }
    // You'd typically check for currentUser!.profileImageUrl here if it exists
    // For now, using the original logic:
    return const AssetImage(fallback);
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileImageSection(),
                const SizedBox(height: 30),
                _buildProfileForm(),
                const SizedBox(height: 40),
                _buildLogoutButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets for Professional Look ---

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 180.0,
      backgroundColor: _primaryColor,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, _accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 20, bottom: 15),
          centerTitle: false,
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      // Use a subtle card/background for the image section
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 65, // Slightly larger
              backgroundColor: _backgroundColor,
              backgroundImage: getProfileImage(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2), // White border
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(
              controller: _fullNameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (v) =>
              v == null || v.isEmpty ? 'Please enter your full name.' : null,
            ),
            const SizedBox(height: 10),
            _buildField(
              controller: _dobController,
              label: 'Date of Birth',
              icon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: _presentDatePicker,
              validator: (v) =>
              v == null || v.isEmpty ? 'Please select your date of birth.' : null,
            ),
            const SizedBox(height: 10),
            _buildField(
              controller: TextEditingController(text: currentUser!.email),
              label: 'Email (Read-Only)',
              icon: Icons.email_outlined,
              readOnly: true,
            ),
            const SizedBox(height: 30),

            // Save Changes Button with modern styling
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: _primaryColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.exit_to_app, color: _errorColor),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _errorColor,
          ),
        ),
        style: TextButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(color: Colors.transparent), // Remove default border
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
      style: const TextStyle(color: _secondaryColor, fontSize: 16),
      cursorColor: _primaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _secondaryColor.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: _primaryColor),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Use shadow for depth instead of border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: _primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: _errorColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        // Add a subtle shadow to the TextFormField for a professional lift effect
        hintText: readOnly ? null : 'Enter $label',
      ),
    );
  }
}