import 'package:flutter/material.dart';

// === WARNA TEMPLATE WARMIN-DO ===
const teal = Color(0xFF26A69A);
const tealDark = Color(0xFF00897B);
const yellow = Color(0xFFFBC02D);
const white = Color(0xFFFFFFFF);
const textDark = Color(0xFF333333);
const cardBg = Color(0xFFF5F5F5);
const greyText = Color(0xFF9E9E9E);
const greyLightText = Color(0xFFBDBDBD);
const greyMidText = Color(0xFF757575);

// ===================== LAYAR KALENDER =====================
// SELURUH LOGIC DAN UI DIGABUNG DALAM SATU FILE
// Tidak ada class terpisah - semua method ada di dalam State class
// =====================
class KalenderScreen extends StatefulWidget {
  const KalenderScreen({super.key});

  @override
  State<KalenderScreen> createState() => _KalenderScreenState();
}

class _KalenderScreenState extends State<KalenderScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime? _birthDate;

  // === SEMUA LOGIC KONVERSI ADA DI SINI ===
  
  // Nama bulan Hijriah (digunakan di beberapa method)
  static const _namaBulanHijri = [
    'Muharram', 'Safar', 'Rabiul Awal', 'Rabiul Akhir',
    'Jumadil Awal', 'Jumadil Akhir', 'Rajab', 'Syakban',
    'Ramadhan', 'Syawal', 'Zulqa\'dah', 'Zulhijjah'
  ];

  // Konversi Gregorian ke Hijri
  String _konversiGregorianKeHijri(DateTime dt) {
    final jd = _hitungJulianDay(dt);
    final hariSejakEpoch = jd - 1948440;
    final cycles = hariSejakEpoch ~/ 10631;
    int sisaHari = hariSejakEpoch % 10631;
    int tahunHijriah = cycles * 30 + 1;

    for (int y = 1; y <= 30 && sisaHari >= 0; y++) {
      final tahunIni = cycles * 30 + y;
      final hariDalamTahun = _apakahTahunHijriKabisat(tahunIni) ? 355 : 354;
      if (sisaHari < hariDalamTahun) {
        tahunHijriah = tahunIni;
        break;
      }
      sisaHari -= hariDalamTahun;
    }
    
    int hari = sisaHari + 1;
    int bulan = 1;
    for (int b = 1; b <= 12; b++) {
      final hariBulan = _hariDalamBulanHijri(b, tahunHijriah);
      if (hari <= hariBulan) {
        bulan = b;
        break;
      }
      hari -= hariBulan;
    }
    
    return '$hari ${_namaBulanHijri[bulan - 1]} $tahunHijriah H';
  }

  // Hitung Julian Day dari tanggal Gregorian
  int _hitungJulianDay(DateTime dt) {
    final a = (14 - dt.month) ~/ 12;
    final y = dt.year + 4800 - a;
    final m = dt.month + 12 * a - 3;
    return dt.day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045;
  }

  // Cek apakah tahun Hijriah kabisat
  bool _apakahTahunHijriKabisat(int tahun) {
    final mod = tahun % 30;
    return mod == 2 || mod == 5 || mod == 7 ||
           mod == 10 || mod == 13 || mod == 15 ||
           mod == 18 || mod == 21 || mod == 24 ||
           mod == 27 || mod == 29;
  }

  // Hari dalam bulan Hijriah
  int _hariDalamBulanHijri(int bulan, int tahun) {
    if (bulan == 12) {
      return _apakahTahunHijriKabisat(tahun) ? 30 : 29;
    }
    return bulan % 2 == 1 ? 30 : 29;
  }

  // Dapatkan info Ramadan (NU hanya untuk tahun >= 2025)
  RamadanData? _getInfoRamadan(int year) {
    if (year < 2025) return null;
    return _hitungRamadanNU(year);
  }

  RamadanData _hitungRamadanNU(int year) {
    final jan1 = DateTime(year, 1, 1);
    final hijriJan1 = _konversiGregorianKeHijri(jan1);
    final parts = hijriJan1.split(' ');
    
    int hYear;
    try {
      hYear = int.parse(parts[2]);
    } catch (e) {
      hYear = year - 622;
    }
    
    int daysToRamadan = 0;
    for (int m = 1; m < 9; m++) {
      daysToRamadan += _hariDalamBulanHijri(m, hYear);
    }
    
    final baseHijriYear = 1448;
    final baseMuharram = DateTime(2026, 6, 16);
    final hijriDiff = hYear - baseHijriYear;
    final daysDiff = hijriDiff * 354;
    
    DateTime muharram1 = baseMuharram.add(Duration(days: daysDiff));
    DateTime ramadan1 = muharram1.add(Duration(days: daysToRamadan));
    
    // Koreksi khusus tahun (data NU)
    if (year == 2027) {
      ramadan1 = DateTime(2027, 2, 9);
    } else if (year == 2026) {
      ramadan1 = DateTime(2026, 1, 29);
    }
    
    DateTime syawal1 = ramadan1.add(
      Duration(days: _apakahTahunHijriKabisat(hYear) ? 30 : 29)
    );
    
    return RamadanData(
      hijriYear: hYear,
      startDate: ramadan1,
      endDate: syawal1.subtract(Duration(days: 1)),
      method: 'NU (Nahdliyin Indonesia)',
    );
  }

  // === FORMAT TANGGAL ===
  String _formatTanggal(DateTime dt) {
    const bulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                   'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${dt.day} ${bulan[dt.month - 1]} ${dt.year}';
  }

  // === PICKER TANGGAL ===
  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: teal, onPrimary: white, surface: white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pilihTanggalLahir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: teal, onPrimary: white, surface: white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  // === BUILD UI ===
  @override
  Widget build(BuildContext context) {
    // Panggil method logic di sini
    final hasilHijri = _konversiGregorianKeHijri(_selectedDate);
    final ramadanInfo = _getInfoRamadan(_selectedDate.year);
    
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: teal,
        centerTitle: true,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBC02D).withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.calendar_today, color: tealDark, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Kalender Hijriah',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: white),
                onPressed: () {},
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === 1. HERO BANNER ===
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TANGGAL TERPILIH',
                              style: TextStyle(
                                color: yellow,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTanggal(_selectedDate),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: _pilihTanggal,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: yellow,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFBC02D).withValues(alpha: 0.10),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: textDark,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.swap_horiz, color: yellow, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Hasil Konversi Hijriah:',
                        style: TextStyle(
                          fontSize: 11,
                          color: yellow,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          hasilHijri,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // === 2. KARTU RAMADHAN (jika ada) ===
            if (ramadanInfo != null) ...[
              _buildRamadanCard(ramadanInfo),
              const SizedBox(height: 14),
            ],

            // === 3. KARTU KONVERSI UMUR ===
            _buildUmurCard(),
            const SizedBox(height: 18),

            Center(
              child: Text(
                'Kalender Hijriah Converter - Kelompok 4 SI',
                style: TextStyle(fontSize: 10, color: greyLightText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRamadanCard(RamadanData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: teal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: teal.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26A69A).withValues(alpha: 0.047),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: yellow.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFBC02D).withValues(alpha: 0.055),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.holiday_village, color: yellow, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Ramadan ', style: TextStyle(fontSize: 14, color: textDark)),
                    Text(
                      '${data.hijriYear} H',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: teal),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${_formatTanggal(data.startDate)} - ${_formatTanggal(data.endDate)}',
                  style: const TextStyle(fontSize: 13, color: textDark),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: yellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: yellow.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Metode: ${data.method}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFF57F17),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUmurCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: teal.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: yellow.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFBC02D).withValues(alpha: 0.055),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.cake, color: yellow, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'KONVERSI UMUR',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textDark, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Tanggal Lahir: ', style: TextStyle(fontSize: 12, color: greyMidText)),
              GestureDetector(
                onTap: _pilihTanggalLahir,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: teal.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _birthDate != null ? _formatTanggal(_birthDate!) : 'Tap untuk memilih',
                    style: TextStyle(fontSize: 12, color: _birthDate != null ? tealDark : greyText),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.edit, color: teal, size: 16),
            ],
          ),
          const SizedBox(height: 14),
          if (_birthDate != null) ...[
            const Text('Umur Anda:', style: TextStyle(fontSize: 12, color: greyMidText, height: 1.2)),
            const SizedBox(height: 6),
            _tampilUmur(_birthDate!),
          ],
        ],
      ),
    );
  }

  // === UI: TAMPILKAN UMUR ===
  Widget _tampilUmur(DateTime tglLahir) {
    final now = DateTime.now();
    int years = now.year - tglLahir.year;
    int months = now.month - tglLahir.month;
    int days = now.day - tglLahir.day;
    
    if (days < 0) {
      months--;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += DateTime(prevMonth.year, prevMonth.month + 1, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: yellow.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: yellow.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoChip('Tahun', years.toString(), teal),
          _infoChip('Bulan', months.toString(), tealDark),
          _infoChip('Hari', days.toString(), tealDark),
          _infoChip('Jam', now.hour.toString(), tealDark),
          _infoChip('Menit', now.minute.toString(), tealDark),
          _infoChip('Detik', now.second.toString(), tealDark),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 8, color: greyText)),
      ],
    );
  }
}

// === CLASS DATA RAMADHAN (hanya data container, bukan logic) ===
// Class ini hanya menyimpan data, bukan mengandung logic konversi
class RamadanData {
  final int hijriYear;
  final DateTime startDate;
  final DateTime endDate;
  final String method;
  
  RamadanData({
    required this.hijriYear,
    required this.startDate,
    required this.endDate,
    required this.method,
  });
}
