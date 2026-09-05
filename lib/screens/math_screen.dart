import 'package:flutter/material.dart';

class MathScreen extends StatefulWidget {
  const MathScreen({super.key});

  @override
  State<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  String _num1 = '';
  String _num2 = '';
  String _operator = '';
  String _display = '0';
  bool _isResult = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_isResult) {
        _num1 = number;
        _operator = '';
        _num2 = '';
        _display = _num1;
        _isResult = false;
      } else if (_operator.isEmpty) {
        if (_num1 == '0') _num1 = '';
        _num1 += number;
        _display = _num1;
      } else {
        if (_num2 == '0') _num2 = '';
        _num2 += number;
        _display = _num2;
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_num1.isEmpty) {
        _num1 = '0';
      }
      if (_isResult) {
        _isResult = false;
      }
      if (_num1.isNotEmpty && _operator.isNotEmpty && _num2.isNotEmpty) {
        _onCalculate();
        _isResult = false;
      }
      _operator = op;
    });
  }

  void _onCalculate() {
    if (_num1.isEmpty || _operator.isEmpty || _num2.isEmpty) return;

    double n1 = double.parse(_num1);
    double n2 = double.parse(_num2);
    double result = 0;

    switch (_operator) {
      case '+':
        result = n1 + n2;
        break;
      case '-':
        result = n1 - n2;
        break;
      case 'x':
        result = n1 * n2;
        break;
      case '/':
        result = n2 == 0 ? 0 : n1 / n2;
        break;
    }

    setState(() {
      _display = result == result.toInt() 
          ? result.toInt().toString() 
          : result.toString();
          
      _num1 = _display;
      _operator = '';
      _num2 = '';
      _isResult = true;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_isResult) return;

      if (_operator.isEmpty) {
        if (_num1.isNotEmpty) {
          _num1 = _num1.substring(0, _num1.length - 1);
          _display = _num1.isEmpty ? '0' : _num1;
        }
      } else {
        if (_num2.isNotEmpty) {
          _num2 = _num2.substring(0, _num2.length - 1);
          _display = _num2.isEmpty ? '0' : _num2;
        }
      }
    });
  }

  void _onClear() {
    setState(() {
      _num1 = '';
      _num2 = '';
      _operator = '';
      _display = '0';
      _isResult = false;
    });
  }

  // Helper untuk membuat Tombol dengan Efek Sentuh / Feedback yang Responsif
  Widget _buildCalcButton({
    required String label,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isAccent = false,
  }) {
    if (label.isEmpty || onTap == null) {
      return const SizedBox.shrink(); // Widget kosong untuk layout
    }

    // Menggunakan FilledButton / ElevatedButton bawaan Material 3
    // yang otomatis punya efek tekan (ripple effect & elevation animation)
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Area Display
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Indikator Operator di Atas
                    Text(
                      _operator.isNotEmpty ? '$_num1 $_operator' : '',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Display Angka Utama
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _display,
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, indent: 16, endIndent: 16),

            // Area Keypad (Dibuat kontras dan responsif)
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                  children: [
                    // Baris 1
                    _buildCalcButton(
                      label: 'C',
                      onTap: _onClear,
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                    ),
                    const SizedBox.shrink(),
                    _buildCalcButton(
                      label: '⌫',
                      onTap: _onBackspace,
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                    ),
                    _buildCalcButton(
                      label: '/',
                      onTap: () => _onOperatorPressed('/'),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),

                    // Baris 2
                    _buildCalcButton(
                      label: '7',
                      onTap: () => _onNumberPressed('7'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '8',
                      onTap: () => _onNumberPressed('8'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '9',
                      onTap: () => _onNumberPressed('9'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: 'x',
                      onTap: () => _onOperatorPressed('x'),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),

                    // Baris 3
                    _buildCalcButton(
                      label: '4',
                      onTap: () => _onNumberPressed('4'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '5',
                      onTap: () => _onNumberPressed('5'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '6',
                      onTap: () => _onNumberPressed('6'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '-',
                      onTap: () => _onOperatorPressed('-'),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),

                    // Baris 4
                    _buildCalcButton(
                      label: '1',
                      onTap: () => _onNumberPressed('1'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '2',
                      onTap: () => _onNumberPressed('2'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '3',
                      onTap: () => _onNumberPressed('3'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    _buildCalcButton(
                      label: '+',
                      onTap: () => _onOperatorPressed('+'),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),

                    // Baris 5
                    const SizedBox.shrink(),
                    _buildCalcButton(
                      label: '0',
                      onTap: () => _onNumberPressed('0'),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    const SizedBox.shrink(),
                    _buildCalcButton(
                      label: '=',
                      onTap: _onCalculate,
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}