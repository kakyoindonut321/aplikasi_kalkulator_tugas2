import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'stopwatch_screen.dart';

// Palette Warna Warmindo
const Color warmindoRed = Color(0xFFE51A24);
const Color warmindoYellow = Color(0xFFFFD100);
const Color warmindoGreen = Color(0xFF008752);
const Color warmindoBg = Color(0xFFFAF7F2);

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Daftar Layar Utama untuk BottomNavBar
  final List<Widget> _screens = [
    const HomeScreen(),
    const StopwatchScreen(), // Pastikan nama class di stopwatch_screen.dart sesuai
    const HelpLogoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga State tetap aktif (contoh: stopwatch tidak ter-reset saat pindah tab)
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: warmindoYellow,
              width: 2,
            ), // Akses aksen kuning Warmindo
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: warmindoRed,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, color: warmindoRed),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer, color: warmindoRed),
              label: 'Stopwatch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline_rounded),
              activeIcon: Icon(Icons.help_rounded, color: warmindoRed),
              label: 'Bantuan & Logout',
            ),
          ],
        ),
      ),
    );
  }
}

// === LAYAR BANTUAN & LOGOUT (TAB KE-3) ===
class HelpLogoutScreen extends StatelessWidget {
  const HelpLogoutScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('session_username');

    if (!context.mounted) return;

    // Kembali ke LoginScreen dan hapus stack navigasi sebelumnya
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmindoBg,
      appBar: AppBar(
        title: const Text(
          'Bantuan & Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: warmindoRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Panduan Penggunaan
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: warmindoGreen),
                        SizedBox(width: 10),
                        Text(
                          'Panduan Penggunaan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    Text(
                      '1. Halaman Beranda berisi 5 menu utama sesuai kategori aplikasi.\n'
                      '2. Fitur Stopwatch dapat digunakan kapan saja tanpa terhenti saat berpindah menu.\n'
                      '3. Gunakan menu CRUD untuk melakukan pengelolaan data produk/pesanan.\n'
                      '4. Tombol Logout di bawah digunakan untuk mengakhiri sesi login.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kartu Logout
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sesi Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Klik tombol di bawah jika Anda ingin keluar dari akun ini.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('LOGOUT / KELUAR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warmindoRed,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
