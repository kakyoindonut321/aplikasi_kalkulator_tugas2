import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Template colors WARMIN-DO (disesuaikan dengan project)
const teal = Color(0xFF26A69A);
const tealDark = Color(0xFF00897B);
const yellow = Color(0xFFFBC02D);
const white = Color(0xFFFFFFFF);
const textDark = Color(0xFF333333);
const cardBg = Color(0xFFF5F5F5);
const greyText = Color(0xFF9E9E9E);
const greyLightText = Color(0xFFBDBDBD);
const greyMidText = Color(0xFF757575);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === HEADER (gaya WARMIN-DO dari TestUi) ===
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: teal,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF26A69A).withValues(alpha: 0.13),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOGIN',
                            style: TextStyle(
                              color: teal,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Aplikasi Tugas 3',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none_rounded, color: textDark),
                          style: IconButton.styleFrom(backgroundColor: Colors.white),
                        ),
                        Positioned(
                          right: 6,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // === BANNER PROMOSI (gaya WARMIN-DO dari TestUi) ===
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: teal,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF26A69A).withValues(alpha: 0.13),
                      blurRadius: 16,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SELAMAT DATANG!',
                            style: TextStyle(
                              color: yellow,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Masuk untuk\nmelanjutkan',
                            style: TextStyle(
                              color: white,
                              fontSize: 26,
                              height: 1.08,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Aplikasi Mobile - Kelompok 4 SI',
                            style: const TextStyle(color: Color(0xFFDCDCDC), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: yellow,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: white, width: 3),
                      ),
                      child: const Icon(
                        Icons.login,
                        color: tealDark,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // === FORM LOGIN ===
              Card(
                elevation: 0,
                color: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: teal.withValues(alpha: 0.25), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Masukkan username',
                          prefixIcon: Icon(Icons.person_outline, color: teal, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: teal.withValues(alpha: 0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: teal, width: 2),
                          ),
                          filled: true,
                          fillColor: teal.withValues(alpha: 0.04),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Masukkan password',
                          prefixIcon: Icon(Icons.lock_outline, color: teal, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: teal.withValues(alpha: 0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: teal, width: 2),
                          ),
                          filled: true,
                          fillColor: teal.withValues(alpha: 0.04),
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // === Tombol Login ===
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  foregroundColor: white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, child: CircularProgressIndicator(color: white, strokeWidth: 2))
                    : const Text('MASUK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 14),

              TextButton(
                onPressed: () {
                  setState(() {
                    _usernameController.text = 'admin';
                    _passwordController.text = '123456';
                  });
                },
                child: const Text(
                  'Gunakan akun demo (admin / 123456)',
                  style: TextStyle(color: teal, fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Aplikasi Mobile - Kelompok 4 SI',
                style: TextStyle(color: greyMidText, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Username dan password wajib diisi!');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (username == 'admin' && password == '123456') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_username', username);
      await prefs.setBool('is_logged_in', true);

      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Username atau password salah. Coba lagi.';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
