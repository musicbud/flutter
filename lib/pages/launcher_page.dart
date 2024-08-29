import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key, required this.title});
  final String title;

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: const Text('Signup'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}