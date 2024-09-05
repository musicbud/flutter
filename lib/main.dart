import 'package:flutter/material.dart';
import 'package:musicbud_flutter/pages/launcher_page.dart';
import 'package:musicbud_flutter/pages/login_page.dart';
import 'package:musicbud_flutter/pages/signup_page.dart';
import 'package:musicbud_flutter/pages/home_page.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Uncaught error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LauncherPage(title: 'MusicBud'),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

