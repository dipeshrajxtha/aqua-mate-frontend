import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/auth_controller.dart';
import '../../routes/app_routes.dart';

// ✅ FIX: Create AuthController instance
final AuthController authController = AuthController();

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedGender = 'Male';
  DateTime? _selectedDate;
  bool _isLoading = false;
  String _networkMessage = '';

  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  InputDecoration _commonInputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      setState(() => _networkMessage = "Please select your Date of Birth.");
      return;
    }

    setState(() {
      _isLoading = true;
      _networkMessage = "";
    });

    final dobFormatted = DateFormat("yyyy-MM-dd").format(_selectedDate!);

    // ✅ Using created controller instance
    final result = await authController.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      gender: _selectedGender,
      dob: dobFormatted,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful! Please log in."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      setState(() => _networkMessage = result);
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 230,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6DF0FB), Color(0xFF00C782)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: -95,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                "New Account",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Register to continue the AquaMate journey",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _fullNameController,
            decoration: _commonInputDecoration(label: "Full Name", icon: Icons.person),
            validator: (v) => v!.isEmpty ? "Enter full name" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: _commonInputDecoration(label: "Email", icon: Icons.email),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v!.isEmpty) return "Enter email";
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) return "Enter a valid email";
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: _commonInputDecoration(label: "Password", icon: Icons.lock),
            validator: (v) => v!.length < 6 ? "Minimum 6 characters" : null,
          ),
          const SizedBox(height: 20),
          InputDecorator(
            decoration: _commonInputDecoration(label: "Gender", icon: Icons.wc),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                  DropdownMenuItem(value: "Others", child: Text("Others")),
                ],
                onChanged: (value) {
                  setState(() => _selectedGender = value!);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            readOnly: true,
            controller: _dobController,
            decoration: _commonInputDecoration(label: "Date of Birth", icon: Icons.calendar_today)
                .copyWith(suffixIcon: const Icon(Icons.arrow_drop_down)),
            onTap: () => _selectDate(context),
            validator: (_) => _selectedDate == null ? "Select your date of birth" : null,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleRegistration,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              "Sign Up",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          if (_networkMessage.isNotEmpty)
            Text(
              _networkMessage,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }
}
