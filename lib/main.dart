import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/login_page.dart';
import 'package:musicbud_flutter/pages/home_page.dart';

void main() {
  final String baseUrl = 'http://127.0.0.1:8000';
  final apiService = ApiService();
  apiService.init(baseUrl);
  runApp(MyApp(baseUrl: baseUrl, apiService: apiService));
}

class MyApp extends StatelessWidget {
  final String baseUrl;
  late final ChatService chatService;
  final ApiService apiService;

  MyApp({required this.baseUrl, required this.apiService}) {
    chatService = ChatService(baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(chatService: chatService, apiService: apiService),
        '/home': (context) => HomePage(chatService: chatService, apiService: apiService),
      },
    );
  }
}

