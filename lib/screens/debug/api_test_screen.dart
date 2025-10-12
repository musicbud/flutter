import 'package:flutter/material.dart';

/// Simplified debug screen for API testing
class ApiTestScreen extends StatelessWidget {
  const ApiTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Endpoint Testing'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bug_report,
                size: 64,
                color: Colors.deepPurple,
              ),
              SizedBox(height: 24),
              Text(
                'API Test Screen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'This debug screen has been simplified to avoid compilation issues.\n\nUse the main app screens to test API functionality:\n\n• Home Screen - Content loading\n• Discover Screen - Music discovery\n• Profile Screen - User data\n• Settings Screen - Service connections\n• Search Screen - Search functionality',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}