import 'package:flutter/material.dart';

class SumTotalScreen extends StatefulWidget {
  const SumTotalScreen({super.key});

  @override
  State<SumTotalScreen> createState() => _SumTotalScreenState();
}

class _SumTotalScreenState extends State<SumTotalScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void _calculateSum() {
    String input = _controller.text;

    if (input.trim().isEmpty) {
      setState(() {
        _result = 'Masukkan angka terlebih dahulu';
      });
      return;
    }

    // Misahin input berdasarkan spasi atau koma
    List<String> numbersStr = input.split(RegExp(r'[,\s]+'));
    double total = 0;
    bool hasError = false;

    for (String numStr in numbersStr) {
      if (numStr.trim().isEmpty) continue;

      double? num = double.tryParse(numStr);
      if (num != null) {
        total += num;
      } else {
        hasError = true;
      }
    }

    setState(() {
      if (hasError) {
        _result = 'Terdapat input tidak valid.\nTotal sementara: $total';
      } else {
        // Ngehapus angka desimal kalau hasilnya bilangan bulat
        _result =
            'Total Jumlah: ${total == total.toInt() ? total.toInt() : total}';
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Khas Warmindo
    const warmindoRed = Color(0xFFE52320);
    const warmindoYellow = Color(0xFFFFCC00);
    const warmindoGreen = Color(0xFF009944);
    const warmindoBg = Color(0xFFFBF6EE);

    return Scaffold(
      backgroundColor: warmindoBg,
      appBar: AppBar(
        title: const Text(
          'Hitung Total Angka',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: warmindoRed,
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.functions_rounded, size: 72, color: warmindoRed),
              const SizedBox(height: 16),
              Text(
                'Masukkan Deret Angka',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pisahkan setiap angka dengan koma atau spasi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Deret Angka',
                  hintText: 'Contoh: 10 20 30 atau 10, 20, 30',
                  prefixIcon: const Icon(
                    Icons.calculate_outlined,
                    color: warmindoRed,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: warmindoRed, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _calculateSum,
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Hitung Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warmindoGreen,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (_result.isNotEmpty) ...[
                const SizedBox(height: 28),
                Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: warmindoYellow, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.receipt_long_rounded,
                          size: 48,
                          color: warmindoRed,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _result,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222222),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
