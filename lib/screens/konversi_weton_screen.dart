import 'package:flutter/material.dart';

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
    if (neptu == 7)
      return 'Pendito Kang Lelaku: Senang bepergian, tidak tahan berdiam diri di suatu tempat.';
    if (neptu == 8)
      return 'Lakune Geni: Suka marah, pendendam, namun pemberani.';
    if (neptu == 9)
      return 'Lakune Angin: Lincah, kebal terhadap guna-guna, tapi mudah terpengaruh.';
    if (neptu == 10)
      return 'Pendito Mbangun Teki: Suka menasihati, cerdas, tidak mudah tersinggung.';
    if (neptu == 11)
      return 'Lakune Setan: Tidak bisa diam, selalu ingin tahu, plin-plan.';
    if (neptu == 12)
      return 'Lakune Kembang: Suka mengalah, cinta damai, disukai banyak orang.';
    if (neptu == 13)
      return 'Lakune Lintang: Lemah lembut, ramah, suka menolong, tapi sering merasa kesepian.';
    if (neptu == 14)
      return 'Lakune Rembulan: Pendengar yang baik, pemberi solusi, mudah bergaul.';
    if (neptu == 15)
      return 'Lakune Srengenge: Berwibawa, tegas, pemaaf, dan bisa menjadi pencerah.';
    if (neptu == 16)
      return 'Lakune Banyu: Ramah, tenang, memiliki empati tinggi, mudah bergaul.';
    if (neptu == 17)
      return 'Lakune Bumi: Sabar, penyayang, namun jika marah bisa sangat menakutkan.';
    if (neptu == 18)
      return 'Lakune Paripurna: Egois, dominan, tapi punya kemampuan memimpin yang kuat.';
    return 'Karakter unik yang memiliki banyak potensi untuk dikembangkan.';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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
      appBar: AppBar(
        title: const Text('Weton & Saka Bali'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hitung Penanggalan Tradisional',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan tanggal masehi untuk mengetahui Weton Jawa dan elemen Kalender Saka Bali (Pawukon).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _selectedDate == null
                    ? 'Pilih Tanggal'
                    : 'Tanggal: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 32),

            if (_resultWeton.isNotEmpty) ...[
              // KARTU WETON JAWA
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.brown),
                          const SizedBox(width: 8),
                          const Text(
                            'Weton Jawa',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      _buildResultRow('Weton', _resultWeton),
                      const SizedBox(height: 12),
                      _buildResultRow('Neptu', _resultNeptu),
                      const SizedBox(height: 12),
                      _buildResultRow('Wuku', _resultWuku),

                      const SizedBox(height: 24),
                      const Text(
                        'Makna Karakter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _resultKarakter,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // KARTU SAKA BALI
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.brightness_5, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Kalender Saka Bali',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

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
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
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
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
