import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar Menu Navigasi Aplikasi
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Data Kelompok',
        'subtitle': 'Daftar anggota kelompok kita',
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
              'Selamat Datang!!!',
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  // PERUBAHAN 1: Ubah rasio kartu agar lebih tinggi 
                  childAspectRatio: 1.1, 
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, item['route']);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        // PERUBAHAN 2: Kurangi padding dalam kartu agar ruang lebih lega
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, 
                          vertical: 12.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              // PERUBAHAN 3: Sedikit mengecilkan ukuran icon/avatar
                              radius: 22, 
                              backgroundColor: (item['color'] as Color).withOpacity(0.15),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              maxLines: 1, // Agar title tidak makan 2 baris
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // PERUBAHAN 4: Bungkus subtitle dengan Expanded
                            Expanded(
                              child: Text(
                                item['subtitle'],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
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