// main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/group_data_screen.dart';
import 'screens/math_screen.dart';
import 'screens/odd_even_screen.dart';
import 'screens/sum_total_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Tugas Kelompok',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Mendaftarkan semua route untuk navigasi
      routes: {
        // '/login': (context) => const LoginScreen(),
        // '/group': (context) => const GroupDataScreen(),
        // '/math': (context) => const MathScreen(),
        // '/odd_even': (context) => const OddEvenScreen(),
        // '/sum_total': (context) => const SumTotalScreen(),
      },
      // Halaman awal
      home: const LoginScreen(),
    );
  }
}
