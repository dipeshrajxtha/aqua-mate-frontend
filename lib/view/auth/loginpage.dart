  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  import '../../controller/auth_controller.dart';
  import '../../controller/reminder_controller.dart';
  import '../../controller/aquarium_controller.dart';  // ⭐ ADDED
  import '../../routes/app_routes.dart';

  // Global Auth Controller instance
  final AuthController authController = AuthController();

  class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    bool _isLoading = false;
    String _networkMessage = "";

    @override
    void dispose() {
      _emailController.dispose();
      _passwordController.dispose();
      super.dispose();
    }

    InputDecoration _commonInputDecoration(
        {required String label, required IconData icon}) {
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

    // =================================
    //     LOGIN HANDLER (UPDATED)
    // =================================
    Future<void> _handleLogin() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() {
        _isLoading = true;
        _networkMessage = "";
      });

      final result = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (result.toLowerCase() == "success") {
        // Fetch reminders
        final reminderController =
        Provider.of<ReminderController>(context, listen: false);

        // ⭐ Fetch aquariums ALSO (this was missing)
        final aquariumController =
        Provider.of<AquariumController>(context, listen: false);

        await reminderController.fetchReminders();
        await aquariumController.fetchAquariums(); // ⭐ REQUIRED FIX

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        setState(() => _networkMessage = result);
      }
    }

    // =================================
    //            HEADER
    // =================================
    Widget _buildHeader() {
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
            child: Center(
              child: Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // =================================
    //            FORM
    // =================================
    Widget _buildForm() {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            // EMAIL
            TextFormField(
              controller: _emailController,
              decoration:
              _commonInputDecoration(label: "Email", icon: Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your email";
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // PASSWORD
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration:
              _commonInputDecoration(label: "Password", icon: Icons.lock),
              validator: (value) =>
              (value == null || value.isEmpty) ? "Enter your password" : null,
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LOGIN BUTTON
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (_networkMessage.isNotEmpty)
              Text(
                _networkMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.signup);
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // =================================
    //            BUILD
    // =================================
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: _buildForm(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
