import 'package:flutter/material.dart';

class GroupDataScreen extends StatelessWidget {
  const GroupDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Anggota Kelompok
    final List<Map<String, String>> groupMembers = [
      {
        'nama': 'Nama Anggota 1',
        'nim': '1234567890',
        'angkatan': '2024',
        'prodi': 'Sistem Informasi',
      },
      {
        'nama': 'Nama Anggota 2',
        'nim': '1234567891',
        'angkatan': '2024',
        'prodi': 'Sistem Informasi',
      },
      {
        'nama': 'Nama Anggota 3',
        'nim': '1234567892',
        'angkatan': '2024',
        'prodi': 'Sistem Informasi',
      },
      {
        'nama': 'Nama Anggota 4',
        'nim': '1234567893',
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
                        Row(
                          children: [
                            Chip(
                              avatar: const Icon(Icons.school, size: 16),
                              label: Text(member['prodi']!),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 8),
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