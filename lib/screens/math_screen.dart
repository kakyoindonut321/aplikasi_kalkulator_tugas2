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

  void _onDecimalPressed() {
    setState(() {
      if (_isResult) {
        _num1 = '0.';
        _operator = '';
        _num2 = '';
        _display = _num1;
        _isResult = false;
      } else if (_operator.isEmpty) {
        if (!_num1.contains('.')) {
          _num1 = _num1.isEmpty ? '0.' : '$_num1.';
          _display = _num1;
        }
      } else {
        if (!_num2.contains('.')) {
          _num2 = _num2.isEmpty ? '0.' : '$_num2.';
          _display = _num2;
        }
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

    result = double.parse(result.toStringAsFixed(10));

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

  Widget _buildCalcButton({
    required String label,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    if (label.isEmpty || onTap == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
          'Kalkulator Kasir',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: warmindoRed,
        elevation: 3,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display Area dengan Container Berwarna & Shadow
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: warmindoYellow, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _operator.isNotEmpty ? '$_num1 $_operator' : '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: warmindoRed,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Keypad Area
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.0,
                  children: [
                    // Baris 1
                    _buildCalcButton(
                      label: 'C',
                      onTap: _onClear,
                      backgroundColor: warmindoRed,
                      foregroundColor: Colors.white,
                    ),
                    const SizedBox.shrink(),
                    _buildCalcButton(
                      label: '⌫',
                      onTap: _onBackspace,
                      backgroundColor: const Color(0xFFE0E0E0),
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '÷',
                      onTap: () => _onOperatorPressed('/'),
                      backgroundColor: warmindoYellow,
                      foregroundColor: Colors.black87,
                    ),

                    // Baris 2
                    _buildCalcButton(
                      label: '7',
                      onTap: () => _onNumberPressed('7'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '8',
                      onTap: () => _onNumberPressed('8'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '9',
                      onTap: () => _onNumberPressed('9'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: 'x',
                      onTap: () => _onOperatorPressed('x'),
                      backgroundColor: warmindoYellow,
                      foregroundColor: Colors.black87,
                    ),

                    // Baris 3
                    _buildCalcButton(
                      label: '4',
                      onTap: () => _onNumberPressed('4'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '5',
                      onTap: () => _onNumberPressed('5'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '6',
                      onTap: () => _onNumberPressed('6'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '-',
                      onTap: () => _onOperatorPressed('-'),
                      backgroundColor: warmindoYellow,
                      foregroundColor: Colors.black87,
                    ),

                    // Baris 4
                    _buildCalcButton(
                      label: '1',
                      onTap: () => _onNumberPressed('1'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '2',
                      onTap: () => _onNumberPressed('2'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '3',
                      onTap: () => _onNumberPressed('3'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '+',
                      onTap: () => _onOperatorPressed('+'),
                      backgroundColor: warmindoYellow,
                      foregroundColor: Colors.black87,
                    ),

                    // Baris 5
                    const SizedBox.shrink(),
                    _buildCalcButton(
                      label: '0',
                      onTap: () => _onNumberPressed('0'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '.',
                      onTap: _onDecimalPressed,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    _buildCalcButton(
                      label: '=',
                      onTap: _onCalculate,
                      backgroundColor: warmindoGreen,
                      foregroundColor: Colors.white,
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
