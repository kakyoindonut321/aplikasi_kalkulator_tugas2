import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/database_helper.dart'; // Sesuaikan lokasi DatabaseHelper kamu

// === WARMINDO COLOR PALETTE ===
const Color warmindoRed = Color(0xFFE51A24);
const Color warmindoYellow = Color(0xFFFFD100);
const Color warmindoGreen = Color(0xFF008752);
const Color warmindoBg = Color(0xFFFAF7F2);
const Color textDark = Color(0xFF2C2C2C);
const Color textMuted = Color(0xFF757575);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmindoBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // === HEADER SPANDUK WARMINDO (MERAH -> KUNING -> HIJAU) ===
            CustomPaint(
              painter: WarmindoHeaderPainter(),
              child: SizedBox(
                width: double.infinity,
                height:
                    280, // Tinggi diperbesar agar teks & logo masuk sempurna
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // Logo Icon Mangkok
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.ramen_dining_rounded,
                          color: warmindoRed,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Title WARMINDO (Sangat kontras di atas Merah)
                      const Text(
                        'WARMIN DO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'MANAJEMEN MENU',
                        style: TextStyle(
                          color: warmindoYellow,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // === FORM LOGIN ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: warmindoYellow.withValues(alpha: 0.8),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Silakan Masuk',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Masukkan akun untuk mengelola pesanan & menu.',
                            style: TextStyle(color: textMuted, fontSize: 12),
                          ),
                          const SizedBox(height: 20),

                          // Field Username
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Masukkan username',
                              prefixIcon: const Icon(
                                Icons.person,
                                color: warmindoRed,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: warmindoRed,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: warmindoBg,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Field Password
                          TextField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Masukkan password',
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: warmindoRed,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: textMuted,
                                ),
                                onPressed: () {
                                  setState(() => _isObscure = !_isObscure);
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: warmindoRed,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: warmindoBg,
                            ),
                          ),

                          // Pesan Error
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: warmindoRed.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: warmindoRed,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: warmindoRed,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TOMBOL LOGIN
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warmindoGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'MASUK APLIKASI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Aplikasi Mobile - Kelompok 4 SI',
                    style: TextStyle(color: textMuted, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
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

    try {
      final user = await DatabaseHelper.instance.login(username, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_username', user.username);
        await prefs.setBool('is_logged_in', true);

        if (!mounted) return;
        setState(() => _isLoading = false);

        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Username atau password tidak ditemukan.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan database: $e';
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

// === PAINTER UNTUK SPANDUK TIGA WARNA WARMINDO (MERAH -> KUNING -> HIJAU) ===
class WarmindoHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Layer Dasar (Background Merah Utama - Paling Atas & Dominan)
    Paint redPaint = Paint()..color = warmindoRed;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), redPaint);

    // 2. Layer Pita Kuning (Di Atas Merah, Melengkung Halus)
    Paint yellowPaint = Paint()..color = warmindoYellow;
    Path yellowPath = Path();
    yellowPath.moveTo(0, size.height - 65);
    yellowPath.quadraticBezierTo(
      size.width * 0.4,
      size.height - 15,
      size.width,
      size.height - 55,
    );
    yellowPath.lineTo(size.width, size.height);
    yellowPath.lineTo(0, size.height);
    yellowPath.close();
    canvas.drawPath(yellowPath, yellowPaint);

    // 3. Layer Pita Hijau (Di Atas Kuning, Paling Bawah Spanduk)
    Paint greenPaint = Paint()..color = warmindoGreen;
    Path greenPath = Path();
    greenPath.moveTo(0, size.height - 35);
    greenPath.quadraticBezierTo(
      size.width * 0.4,
      size.height,
      size.width,
      size.height - 30,
    );
    greenPath.lineTo(size.width, size.height);
    greenPath.lineTo(0, size.height);
    greenPath.close();
    canvas.drawPath(greenPath, greenPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
