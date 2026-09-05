import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar Menu Navigasi Aplikasi
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Data Kelompok',
        'subtitle': 'Daftar nama & NIM anggota',
        'icon': Icons.people_alt_rounded,
        'color': Colors.indigo,
        'route': '/group',
      },
      {
        'title': 'Kalkulator',
        'subtitle': 'Penjumlahan, pengurangan, dll.',
        'icon': Icons.calculate_rounded,
        'color': Colors.teal,
        'route': '/math',
      },
      {
        'title': 'Ganjil / Genap',
        'subtitle': 'Cek jenis bilangan',
        'icon': Icons.pin_rounded,
        'color': Colors.orange,
        'route': '/odd_even',
      },
      {
        'title': 'Total Sum',
        'subtitle': 'Hitung total deret angka',
        'icon': Icons.functions_rounded,
        'color': Colors.deepPurple,
        'route': '/sum_total',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Kembali ke halaman Login & hapus riwayat tumpukan halaman
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang! 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih salah satu menu di bawah untuk menggunakan fitur:',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: menuItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 Kolom Card
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];

                  return InkWell(
                    onTap: () {
                      // Pindah ke route sesuai menu yang diklik
                      Navigator.pushNamed(context, item['route']);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: (item['color'] as Color).withOpacity(0.15),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['subtitle'],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}