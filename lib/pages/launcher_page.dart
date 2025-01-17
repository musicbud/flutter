import 'package:flutter/material.dart';

class LauncherPage extends StatelessWidget {
  final String title;

  const LauncherPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building LauncherPage');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to MusicBud', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                print('Signup button pressed');
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
                print('Login button pressed');
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