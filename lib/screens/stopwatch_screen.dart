import 'dart:async';

import 'package:flutter/material.dart';

// === WARMINDO COLOR PALETTE ===
const Color warmindoRed = Color(0xFFE51A24);
const Color warmindoYellow = Color(0xFFFFD100);
const Color warmindoGreen = Color(0xFF008752);
const Color warmindoBg = Color(0xFFFAF7F2);
const Color textDark = Color(0xFF2C2C2C);
const Color textMuted = Color(0xFF757575);

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _lapTimes = [];

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
        setState(() {});
      });
    }
  }

  void _pauseStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      _timer = null;
      setState(() {});
    }
  }

  void _resetStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    }

    _timer?.cancel();
    _timer = null;
    _stopwatch.reset();
    _lapTimes.clear();
    setState(() {});
  }

  void _recordLap() {
    if (!_stopwatch.isRunning) return;

    setState(() {
      _lapTimes.insert(0, 'Lap ${_lapTimes.length + 1}: ${_formatTime()}');
    });
  }

  String _formatTime() {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (elapsed.inMilliseconds % 1000) ~/ 10;

    return '$minutes:$seconds.${milliseconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmindoBg,
      appBar: AppBar(
        title: const Text(
          'Stopwatch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: warmindoRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // === CONTAINER TIMER (Gaya Card Warmindo) ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: warmindoYellow.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _formatTime(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: warmindoRed,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // === TOMBOL START / PAUSE (Warna Hijau Warmindo saat Start, Merah saat Pause) ===
              ElevatedButton.icon(
                onPressed: _stopwatch.isRunning
                    ? _pauseStopwatch
                    : _startStopwatch,
                icon: Icon(
                  _stopwatch.isRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  _stopwatch.isRunning ? 'PAUSE' : 'START',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _stopwatch.isRunning
                      ? warmindoRed
                      : warmindoGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(180, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 12),

              // === BARIS TOMBOL RESET & RECORD ===
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Reset
                  OutlinedButton.icon(
                    onPressed: _resetStopwatch,
                    icon: const Icon(
                      Icons.restart_alt_rounded,
                      color: warmindoRed,
                    ),
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        color: warmindoRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(130, 48),
                      side: const BorderSide(color: warmindoRed, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Record Lap
                  FilledButton.icon(
                    onPressed: _stopwatch.isRunning ? _recordLap : null,
                    icon: const Icon(Icons.flag_rounded),
                    label: const Text(
                      'Record',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: warmindoYellow,
                      foregroundColor: textDark,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      minimumSize: const Size(150, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // === CONTAINER DAFTAR CATATAN LAP ===
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _lapTimes.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada catatan waktu',
                            style: TextStyle(color: textMuted),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _lapTimes.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 14,
                                backgroundColor: warmindoGreen.withValues(
                                  alpha: 0.15,
                                ),
                                child: Text(
                                  '${_lapTimes.length - index}',
                                  style: const TextStyle(
                                    color: warmindoGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                _lapTimes[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
