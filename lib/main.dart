import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/presentation/pages/login_page.dart';
import 'package:musicbud_flutter/presentation/pages/home_page.dart';
import 'package:musicbud_flutter/presentation/pages/signup_page.dart';
import 'package:musicbud_flutter/presentation/pages/connect_services_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MusicBudApp();


}

class MusicBudApp extends StatelessWidget {

  const MusicBudApp(Key? key)
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: isLoggedIn
      //     ? HomePage()
      //     : LoginPage(),
      routes: {
        '/home': (context) =>
            HomePage(),
        '/login': (context) =>
            LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/connect_services': (context) =>
            ConnectServicesPage(),
      },
    );
  }
}
