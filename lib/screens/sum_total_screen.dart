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
    return Scaffold(
      appBar: AppBar(title: const Text('Hitung Total Angka')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Masukkan deret angka:\n(Pisahkan dengan koma atau spasi)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Contoh: 10 20 30 atau 10, 20, 30',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateSum,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Hitung Total', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
            Text(
              _result,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
