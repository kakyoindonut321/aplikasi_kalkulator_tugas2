// lib/screens/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  // Hardcoded validation
  void _login() {
    setState(() {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      
      if (username == 'admin' && password == '123456') {
        _message = '✅ Login berhasil!';
        // Pindah ke halaman data kelompok
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GroupDataScreen()),
        );
      } else {
        _message = '❌ Username atau password salah!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login Aplikasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('✅') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Gunakan: admin / 123456',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman data kelompok setelah login
class GroupDataScreen extends StatelessWidget {
  const GroupDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kelompok'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👋 Data Kelompok',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nama: [Nama Anggota 1]'),
              subtitle: Text('NIM: [NIM Anggota 1]'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nama: [Nama Anggota 2]'),
              subtitle: Text('NIM: [NIM Anggota 2]'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nama: [Nama Anggota 3]'),
              subtitle: Text('NIM: [NIM Anggota 3]'),
            ),
          ],
        ),
      ),
    );
  }
}
