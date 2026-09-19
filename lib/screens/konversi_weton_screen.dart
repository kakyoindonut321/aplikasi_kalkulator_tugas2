import 'package:flutter/material.dart';

// === PALET WARNA TEMA WARMINDO ===
const warmindoRed = Color(0xFFD32F2F); // Merah Warmindo / Indomie
const warmindoDarkRed = Color(0xFFB71C1C); // Merah Gelap
const warmindoYellow = Color(0xFFFFC107); // Kuning Mustard
const warmindoGreen = Color(0xFF388E3C); // Hijau Aksen
const white = Color(0xFFFFFFFF);
const textDark = Color(0xFF212121);
const cardBg = Color(0xFFFFF8E1); // Krem Lembut
const greyText = Color(0xFF757575);
const greyLightText = Color(0xFF9E9E9E);
const greyMidText = Color(0xFF616161);

class KonversiWetonScreen extends StatefulWidget {
  const KonversiWetonScreen({super.key});

  @override
  State<KonversiWetonScreen> createState() => _KonversiWetonScreenState();
}

class _KonversiWetonScreenState extends State<KonversiWetonScreen> {
  DateTime? _selectedDate;

  // Data Weton Jawa
  final List<String> _hariList = [
    'Minggu',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];
  final List<int> _neptuHari = [5, 4, 3, 7, 8, 6, 9];
  final List<String> _pasaranList = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
  final List<int> _neptuPasaran = [5, 9, 7, 4, 8];

  // Data Saka Bali (Wewaran)
  final List<String> _saptawaraList = [
    'Redite',
    'Coma',
    'Anggara',
    'Buda',
    'Wraspati',
    'Sukra',
    'Saniscara',
  ];
  final List<String> _pancawaraList = [
    'Umanis',
    'Paing',
    'Pon',
    'Wage',
    'Kliwon',
  ];
  final List<String> _triwaraList = ['Pasah', 'Beteng', 'Kajeng'];

  // Wuku (Sama untuk Jawa & Bali)
  final List<String> _wukuList = [
    'Sinta',
    'Landep',
    'Wukir',
    'Kurantil',
    'Tolu',
    'Gumbreg',
    'Warigalit',
    'Warigagung',
    'Julungwangi',
    'Sungsang',
    'Galungan',
    'Kuningan',
    'Langkir',
    'Mandasiya',
    'Julungpujut',
    'Pahang',
    'Kuruwelut',
    'Marakeh',
    'Tambir',
    'Medangkungan',
    'Maktal',
    'Wuye',
    'Manahil',
    'Prangbakat',
    'Bala',
    'Wugu',
    'Wayang',
    'Kulawu',
    'Dukut',
    'Watugunung',
  ];

  // Hasil Weton
  String _resultWeton = '';
  String _resultNeptu = '';
  String _resultWuku = '';
  String _resultKarakter = '';

  // Hasil Saka Bali
  String _resultSakaYear = '';
  String _resultTriwara = '';
  String _resultPancawara = '';
  String _resultSaptawara = '';

  void _calculateDate(DateTime date) {
    // === LOGIKA WETON JAWA ===
    // Gunakan tanggal anchor untuk Hari & Pasaran: 1 Jan 1970 adalah Kamis Wage
    DateTime pasaranEpoch = DateTime.utc(1970, 1, 1);
    DateTime target = DateTime.utc(date.year, date.month, date.day);

    int diffPasaran = target.difference(pasaranEpoch).inDays;

    // Hari Jawa (1 Jan 1970 adalah Kamis -> index 4)
    int hariIndex = (diffPasaran + 4) % 7;
    if (hariIndex < 0) hariIndex += 7;

    // Pasaran Jawa (1 Jan 1970 adalah Wage -> index 3)
    int pasaranIndex = (diffPasaran + 3) % 5;
    if (pasaranIndex < 0) pasaranIndex += 5;

    int neptuTotal = _neptuHari[hariIndex] + _neptuPasaran[pasaranIndex];

    // === LOGIKA WUKU & SAKA BALI ===
    // Gunakan tanggal anchor untuk Wuku: 30 Nov 1969 adalah Minggu Pahing (Redite Paing), awal Wuku Sinta
    DateTime wukuEpoch = DateTime.utc(1969, 11, 30);
    int diffWuku = target.difference(wukuEpoch).inDays;
    if (diffWuku < 0) {
      diffWuku = (diffWuku % 210 + 210) % 210;
    }

    int wukuIndex = (diffWuku ~/ 7) % 30;
    int saptawaraIndex = diffWuku % 7;
    int pancawaraIndex =
        (diffWuku + 1) % 5; // +1 karena Redite Paing Sinta (Paing index 1)
    int triwaraIndex = diffWuku % 3;

    // Estimasi Tahun Saka (Nyepi biasanya bulan Maret, jadi jika < Maret kurangi 79, else 78)
    int sakaYear = date.month < 3 ? date.year - 79 : date.year - 78;

    setState(() {
      // Set State Weton Jawa
      _resultWeton = '${_hariList[hariIndex]} ${_pasaranList[pasaranIndex]}';
      _resultNeptu =
          '$neptuTotal (${_neptuHari[hariIndex]} + ${_neptuPasaran[pasaranIndex]})';
      _resultWuku = _wukuList[wukuIndex];
      _resultKarakter = _getMaknaKarakter(neptuTotal);

      // Set State Saka Bali
      _resultSakaYear = '$sakaYear Saka (Estimasi)';
      _resultSaptawara = _saptawaraList[saptawaraIndex];
      _resultPancawara = _pancawaraList[pancawaraIndex];
      _resultTriwara = _triwaraList[triwaraIndex];
    });
  }

  String _getMaknaKarakter(int neptu) {
    if (neptu == 7) {
      return 'Pendito Kang Lelaku: Senang bepergian, tidak tahan berdiam diri di suatu tempat.';
    }
    if (neptu == 8) {
      return 'Lakune Geni: Suka marah, pendendam, namun pemberani.';
    }
    if (neptu == 9) {
      return 'Lakune Angin: Lincah, kebal terhadap guna-guna, tapi mudah terpengaruh.';
    }
    if (neptu == 10) {
      return 'Pendito Mbangun Teki: Suka menasihati, cerdas, tidak mudah tersinggung.';
    }
    if (neptu == 11) {
      return 'Lakune Setan: Tidak bisa diam, selalu ingin tahu, plin-plan.';
    }
    if (neptu == 12) {
      return 'Lakune Kembang: Suka mengalah, cinta damai, disukai banyak orang.';
    }
    if (neptu == 13) {
      return 'Lakune Lintang: Lemah lembut, ramah, suka menolong, tapi sering merasa kesepian.';
    }
    if (neptu == 14) {
      return 'Lakune Rembulan: Pendengar yang baik, pemberi solusi, mudah bergaul.';
    }
    if (neptu == 15) {
      return 'Lakune Srengenge: Berwibawa, tegas, pemaaf, dan bisa menjadi pencerah.';
    }
    if (neptu == 16) {
      return 'Lakune Banyu: Ramah, tenang, memiliki empati tinggi, mudah bergaul.';
    }
    if (neptu == 17) {
      return 'Lakune Bumi: Sabar, penyayang, namun jika marah bisa sangat menakutkan.';
    }
    if (neptu == 18) {
      return 'Lakune Paripurna: Egois, dominan, tapi punya kemampuan memimpin yang kuat.';
    }
    return 'Karakter unik yang memiliki banyak potensi untuk dikembangkan.';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: warmindoRed,
            onPrimary: white,
            surface: white,
            onSurface: textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _calculateDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: warmindoRed,
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: warmindoYellow,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: warmindoYellow.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: warmindoDarkRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Weton & Saka Bali',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === BANNER INFORMASI TEMA WARMINDO ===
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: warmindoYellow),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    'Hitung Penanggalan Tradisional',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: warmindoDarkRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Masukkan tanggal masehi untuk mengetahui Weton Jawa dan elemen Kalender Saka Bali (Pawukon).',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: greyMidText, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // === TOMBOL PILIH TANGGAL WARMINDO ===
            ElevatedButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_month, color: warmindoDarkRed),
              label: Text(
                _selectedDate == null
                    ? 'Pilih Tanggal'
                    : 'Tanggal: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: warmindoDarkRed,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: warmindoYellow,
                foregroundColor: warmindoDarkRed,
                elevation: 3,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: white, width: 1.5),
                ),
                shadowColor: warmindoYellow.withValues(alpha: 0.4),
              ),
            ),

            const SizedBox(height: 24),

            if (_resultWeton.isNotEmpty) ...[
              // KARTU WETON JAWA
              Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: warmindoRed.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: warmindoRed.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: warmindoRed,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Weton Jawa',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: warmindoDarkRed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.black12, height: 1),
                      const SizedBox(height: 16),

                      _buildResultRow('Weton', _resultWeton),
                      const SizedBox(height: 12),
                      _buildResultRow('Neptu', _resultNeptu),
                      const SizedBox(height: 12),
                      _buildResultRow('Wuku', _resultWuku),

                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: warmindoYellow.withValues(alpha: 0.8),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Makna Karakter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: warmindoDarkRed,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _resultKarakter,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: textDark,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // KARTU SAKA BALI
              Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: warmindoGreen.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: warmindoGreen.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.brightness_5,
                              color: warmindoGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Kalender Saka Bali',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: warmindoGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.black12, height: 1),
                      const SizedBox(height: 16),

                      _buildResultRow('Tahun Saka', _resultSakaYear),
                      const SizedBox(height: 12),
                      _buildResultRow('Wuku', _resultWuku),
                      const SizedBox(height: 12),
                      _buildResultRow('Saptawara (7)', _resultSaptawara),
                      const SizedBox(height: 12),
                      _buildResultRow('Pancawara (5)', _resultPancawara),
                      const SizedBox(height: 12),
                      _buildResultRow('Triwara (3)', _resultTriwara),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Silakan pilih tanggal terlebih dahulu',
                    style: TextStyle(color: greyLightText),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            Center(
              child: Text(
                'Kalender Tradisional - Kelompok 4 SI',
                style: TextStyle(fontSize: 10, color: greyLightText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: greyText,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: textDark,
          ),
        ),
      ],
    );
  }
}
