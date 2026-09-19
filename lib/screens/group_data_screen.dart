import 'package:flutter/material.dart';

// === WARMINDO COLOR PALETTE ===
const Color warmindoRed = Color(0xFFE51A24);
const Color warmindoYellow = Color(0xFFFFD100);
const Color warmindoGreen = Color(0xFF008752);
const Color warmindoBg = Color(0xFFFAF7F2);
const Color textDark = Color(0xFF2C2C2C);

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
      backgroundColor: warmindoBg,
      appBar: AppBar(
        title: const Text(
          'Daftar Anggota Kelompok',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: warmindoRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groupMembers.length,
        itemBuilder: (context, index) {
          final member = groupMembers[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12.0),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: warmindoYellow.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar / Icon Profil Nomor Urut (Aksen Warmindo)
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: warmindoRed,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: warmindoYellow,
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
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIM: ${member['nim']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Wrap Chip bertema Hijriah/Sawi Warmindo
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            Chip(
                              avatar: const Icon(
                                Icons.school,
                                size: 16,
                                color: warmindoGreen,
                              ),
                              label: Text(
                                member['prodi']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: warmindoGreen.withValues(
                                alpha: 0.12,
                              ),
                              side: BorderSide.none,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.calendar_today,
                                size: 15,
                                color: warmindoGreen,
                              ),
                              label: Text(
                                member['angkatan']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: warmindoGreen.withValues(
                                alpha: 0.12,
                              ),
                              side: BorderSide.none,
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
