// lib/config/api_config.dart

// 🚨 CRITICAL: Use your live Render URL here.
const String BASE_API_URL = 'https://aqua-mate-backend.onrender.com/api';

// Placeholder function to get the current user's JWT token
// NOTE: You must replace this with your actual secure token retrieval method (e.g., SharedPreferences/FlutterSecureStorage).
Future<String?> getAuthToken() async {
  // Replace this placeholder with logic to fetch your stored JWT token
  // For now, returning a hardcoded dummy or null to avoid crashes.
  // Example: final prefs = await SharedPreferences.getInstance(); return prefs.getString('token');
  return 'YOUR_JWT_TOKEN_HERE'; // MUST be replaced with the actual token
}