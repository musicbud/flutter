import 'package:flutter/material.dart';

/// Simple theme test page to verify theme system
class ThemeTestPage extends StatelessWidget {
  const ThemeTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Test'),
      ),
      body: const Center(
        child: Text('Theme Test Page'),
      ),
    );
  }
}
