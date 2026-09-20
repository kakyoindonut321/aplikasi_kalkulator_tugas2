import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/kalender_screen.dart';
import 'screens/konversi_weton_screen.dart';
import 'screens/group_data_screen.dart';
import 'screens/math_screen.dart';
import 'screens/odd_even_screen.dart';
import 'screens/sum_total_screen.dart';
import 'screens/stopwatch_screen.dart';
import 'screens/crud.dart';
import 'screens/test_ui.dart';

import 'screens/main_navigation_screen.dart';
import 'screens/auth_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Warmindo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Mendaftarkan semua route untuk navigasi
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/kalender': (context) => const KalenderScreen(),
        '/kalender-weton': (context) => const KonversiWetonScreen(),
        '/group': (context) => const GroupDataScreen(),
        '/math': (context) => const MathScreen(),
        '/odd_even': (context) => const OddEvenScreen(),
        '/sum_total': (context) => const SumTotalScreen(),
        '/stopwatch': (context) => const StopwatchScreen(),
        '/crud': (context) => const Crud(),
        '/test-ui': (context) => const TestUi(),
      },
      // Halaman awal — cek session, kalau sudah login langsung ke home
      home: const AuthWrapper(),
    );
  }
}
