import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/login_page.dart';
import 'package:musicbud_flutter/pages/home_page.dart';
import 'package:musicbud_flutter/pages/profile_page.dart'; // Add this import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();
  final ChatService chatService = ChatService('http://127.0.0.1:8000');

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(apiService: apiService, chatService: chatService),
        '/home': (context) => HomePage(chatService: chatService, apiService: apiService),
        '/profile': (context) => ProfilePage(apiService: apiService),
      },
    );
  }
}

