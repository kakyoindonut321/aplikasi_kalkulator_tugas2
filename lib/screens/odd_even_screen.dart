import 'package:flutter/material.dart';

class OddEvenScreen extends StatefulWidget {
  const OddEvenScreen({super.key});

  @override
  State<OddEvenScreen> createState() => _OddEvenScreenState();
}

class _OddEvenScreenState extends State<OddEvenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  String? _result;
  int? _checkedNumber;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _checkNumber() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _result = null;
        _checkedNumber = null;
      });
      return;
    }

    final number = int.parse(_numberController.text.trim());
    setState(() {
      _checkedNumber = number;
      _result = number.isEven ? 'Genap' : 'Ganjil';
    });
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
          'Cek Ganjil / Genap',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: warmindoRed,
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.pin_rounded, size: 72, color: warmindoRed),
                const SizedBox(height: 16),
                Text(
                  'Masukkan sebuah angka',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aplikasi akan menentukan apakah angka tersebut genap atau ganjil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Angka',
                    hintText: 'Contoh: 24',
                    prefixIcon: const Icon(
                      Icons.numbers_rounded,
                      color: warmindoRed,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: warmindoRed,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Angka wajib diisi';
                    }
                    if (int.tryParse(text) == null) {
                      return 'Masukkan bilangan bulat yang valid';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _checkNumber(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _checkNumber,
                    icon: const Icon(Icons.search_rounded, color: Colors.white),
                    label: const Text(
                      'Cek Angka',
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
                if (_result != null) ...[
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
                          Icon(
                            _result == 'Genap'
                                ? Icons.circle_outlined
                                : Icons.change_history,
                            size: 48,
                            color: warmindoRed,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$_checkedNumber adalah bilangan $_result',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF222222),
                                ),
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
      ),
    );
  }
}
