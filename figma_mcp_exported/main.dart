import 'package:flutter/material.dart';
import '../lib/core/theme/design_system.dart';
import 'music_buds_0_screen.dart';
import 'music_bud_screen.dart';

void main() {
  runApp(const MusicBudApp());
}

class MusicBudApp extends StatelessWidget {
  const MusicBudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Bud App',
      theme: DesignSystem.darkTheme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Bud Designs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MusicBuds0Screen()),
              ),
              child: const Text('Music Buds 0 Design'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MusicBudScreen()),
              ),
              child: const Text('Music Bud Design'),
            ),
          ],
        ),
      ),
    );
  }
}