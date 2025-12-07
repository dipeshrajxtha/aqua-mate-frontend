// lib/view/dashboard/settings.dart

import 'package:flutter/material.dart';
import 'package:aqua_mate/routes/app_routes.dart';
import 'package:aqua_mate/widgets/shared_bottom_nav.dart';
import '../../global/user_session.dart';

// Define the gradient and colors for consistency
const Color _primaryGreen = Color(0xFF00C782); // From EditProfilePage
const Color _accentCyan = Color(0xFF6DF0FB); // From EditProfilePage
const Color _lightBackground = Color(0xFFF7F9FC); // Light background for contrast
const Color _textColor = Color(0xFF333333); // Dark text color
const Color _errorColor = Color(0xFFEF5350); // Red for logout

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // ---------------- ABOUT APP ----------------
  void _showAboutApp(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'AquaMate',
      applicationVersion: 'v1.0.0',
      applicationLegalese: '© ${DateTime.now().year} AquaMate',
    );
  }

  // ---------------- DEVELOPER INFO ----------------
  void _showDeveloperDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Developer & Credits', style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        content: const Text(
          'Designed and built by the dedicated AquaMate team.\n\nThank you for using our app!',
          style: TextStyle(color: _textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: _primaryGreen)),
          ),
        ],
      ),
    );
  }

  // ---------------- LOGOUT ----------------
  Future<void> _handleLogout(BuildContext context) async {
    // 1. Clear session data
    await UserSession.clear();

    // 2. Navigate to login page
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );

    // 3. Snackbar (Improved styling)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logged out successfully.", style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ---------------- HEADER (Using Gradient and Rounded Corners) ----------------
  Widget _buildHeader(BuildContext context) {
    return ClipRRect( // <--- WRAP WITH CLIPRRECT
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 20,
          left: 20,
          right: 20,
          bottom: 25, // Slightly increased bottom padding
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_accentCyan, _primaryGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Note: Box decoration no longer needs borderRadius here, ClipRRect handles it.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Placeholder for Notifications
                      },
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.profile);
                      },
                      icon: const Icon(Icons.person_outline, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Manage your account and application preferences.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            )
          ],
        ),
      ),
    );
  }

  // ---------------- SETTING CARD (Modernized) ----------------
  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2, // Subtle elevation for depth
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isLogout ? _errorColor.withOpacity(0.1) : _primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isLogout ? _errorColor : _primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: isLogout ? FontWeight.w600 : FontWeight.w500,
                      color: isLogout ? _errorColor : _textColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- MAIN UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ACCOUNT Section
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Account & Security',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  _buildSettingCard(
                    title: 'Edit Profile',
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),

                  // APP INFO Section
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Application Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  _buildSettingCard(
                    title: 'About AquaMate',
                    icon: Icons.info_outline,
                    onTap: () => _showAboutApp(context),
                  ),
                  _buildSettingCard(
                    title: 'Help & Support',
                    icon: Icons.live_help_outlined,
                    onTap: () {
                      // Implement navigation to a Help/FAQ screen
                    },
                  ),
                  _buildSettingCard(
                    title: 'Developer & Credits',
                    icon: Icons.code_outlined,
                    onTap: () => _showDeveloperDialog(context),
                  ),

                  // LOGOUT Section
                  const SizedBox(height: 40),
                  _buildSettingCard(
                    title: 'Logout',
                    icon: Icons.logout,
                    onTap: () => _handleLogout(context),
                    isLogout: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 3),
    );
  }
}