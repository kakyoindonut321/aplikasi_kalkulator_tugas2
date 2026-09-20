// lib/screens/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'main_navigation_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan loading sementara saat mengecek SharedPreferences
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE51A24), // Warna Merah Warmindo
        ),
      ),
    );
  }
}
