import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Palette Warna Tema Warmindo
const Color warmindoRed = Color(0xFFE51A24);
const Color warmindoYellow = Color(0xFFFFD100);
const Color warmindoGreen = Color(0xFF008752);
const Color warmindoBg = Color(0xFFFAF7F2);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmindoBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Banner Warmindo
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: warmindoRed,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'WARMINDO APP',
                              style: TextStyle(
                                color: warmindoYellow,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FutureBuilder<SharedPreferences>(
                              future: SharedPreferences.getInstance(),
                              builder: (context, snapshot) {
                                final username =
                                    snapshot.data?.getString(
                                      'session_username',
                                    ) ??
                                    'Pengguna';
                                return Text(
                                  'Halo, $username! 👋',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          backgroundColor: warmindoYellow,
                          radius: 22,
                          child: Icon(
                            Icons.ramen_dining,
                            color: warmindoRed,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Section Judul Menu
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'Menu Utama',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // 4 Menu Vertikal Utama (Sesuai Sketsa)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 1. Daftar Kelompok
                  _buildMenuCard(
                    context: context,
                    title: 'Daftar Kelompok',
                    subtitle: 'Informasi dan profil anggota tim',
                    icon: Icons.groups_rounded,
                    accentColor: warmindoRed,
                    onTap: () => Navigator.pushNamed(context, '/group'),
                  ),
                  const SizedBox(height: 12),

                  // 2. Menu Komputasi (Sub-Navigasi)
                  _buildMenuCard(
                    context: context,
                    title: 'Menu Komputasi',
                    subtitle: 'Kalkulator Matematika, Ganjil/Genap, & Total',
                    icon: Icons.calculate_rounded,
                    accentColor: warmindoGreen,
                    onTap: () => _showComputationModal(context),
                  ),
                  const SizedBox(height: 12),

                  // 3. Menu CRUD (Database Warmindo)
                  _buildMenuCard(
                    context: context,
                    title: 'Menu CRUD',
                    subtitle: 'Kelola data produk/pesanan berbasis database',
                    icon: Icons.dataset_rounded,
                    accentColor: Colors.deepOrange,
                    onTap: () => Navigator.pushNamed(context, '/testdbscreen'),
                  ),
                  const SizedBox(height: 12),

                  // 4. Menu Konversi (Sub-Navigasi: Hijriah, Umur, Weton & Saka Bali)
                  _buildMenuCard(
                    context: context,
                    title: 'Menu Konversi',
                    subtitle: 'Konversi Tanggal Hijriah, Umur, Weton & Saka',
                    icon: Icons.published_with_changes_rounded,
                    accentColor: Colors.purple,
                    onTap: () => _showConversionModal(context),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kartu Menu Vertikal
  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  // Modal Bottom Sheet Pilihan Menu Komputasi
  void _showComputationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Fitur Komputasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calculate, color: warmindoGreen),
                title: const Text('Operasi Matematika'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/math');
                },
              ),
              ListTile(
                leading: const Icon(Icons.numbers, color: warmindoGreen),
                title: const Text('Cek Ganjil / Genap'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/odd_even');
                },
              ),
              ListTile(
                leading: const Icon(Icons.summarize, color: warmindoGreen),
                title: const Text('Hitung Total (Sum Total)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/sum_total');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Modal Bottom Sheet Pilihan Menu Konversi
  void _showConversionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Fitur Konversi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.access_time_filled_rounded,
                  color: Colors.purple,
                ),
                title: const Text('Konversi Tanggal Hijriah & Umur Detail'),
                subtitle: const Text('Tahun, Bulan, Hari, Jam, Menit, Detik'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  // Buka layar konversi umur & hijriah (dapat dibuat/disesuaikan kemudian)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Membuka Konversi Tanggal Hijriah & Umur'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.indigo,
                ),
                title: const Text('Kalender Weton Jawa & Saka Bali'),
                subtitle: const Text('Hitung Weton & Kalender Saka'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/kalender');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
