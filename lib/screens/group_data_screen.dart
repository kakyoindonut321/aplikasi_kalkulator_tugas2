import 'package:flutter/material.dart';

class GroupDataScreen extends StatelessWidget {
  const GroupDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Anggota Kelompok
    final List<Map<String, String>> groupMembers = [
      {
        'nama': 'Dimas Febryansyah Al Ghiffary',
        'nim': '124240145',
        'angkatan': '2024',
        'prodi': 'Sistem Informasi',
      },
      {
        'nama': 'Abelyo Gidheoni Ginting',
        'nim': '124240124',
        'angkatan': '2024',
        'prodi': 'Sistem Informasi',
      },
      {
        'nama': 'Muhammad Rifqi Navis FS',
        'nim': '124240133',
        'angkatan': '2024',
        'prodi': 'Sistem Informasi',
      },
      {
        'nama': 'Thirafi Naufal Zakiri',
        'nim': '124240148',
        'angkatan': '2024',
        'prodi': 'Sistem Informasi',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kelompok'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groupMembers.length,
        itemBuilder: (context, index) {
          final member = groupMembers[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Ditambahkan agar avatar tetap rata atas jika Card memanjang
                children: [
                  // Avatar / Icon Profil
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Detail Data Anggota
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['nama']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIM: ${member['nim']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        
                        // PERUBAHAN: Mengganti Row dengan Wrap
                        Wrap(
                          spacing: 8.0, // Jarak horizontal antar Chip
                          runSpacing: 4.0, // Jarak vertikal jika Chip turun ke baris baru
                          children: [
                            Chip(
                              avatar: const Icon(Icons.school, size: 16),
                              label: Text(member['prodi']!),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                            Chip(
                              avatar: const Icon(Icons.calendar_today, size: 16),
                              label: Text(member['angkatan']!),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}