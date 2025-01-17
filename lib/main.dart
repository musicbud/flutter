import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/login_page.dart';
import 'package:musicbud_flutter/pages/home_page.dart';
import 'package:musicbud_flutter/pages/signup_page.dart';
import 'package:musicbud_flutter/pages/connect_services_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  await apiService
      .initialize('http://127.0.0.1:8000'); // Make sure this URL is correct
  final chatService = ChatService('http://127.0.0.1:8000' as Dio);
  final isLoggedIn = await apiService.isLoggedIn();
  runApp(MusicBudApp(
      isLoggedIn: isLoggedIn,
      apiService: apiService,
      chatService: chatService));

  apiService.logDioConfiguration();

  final connectivityResult = await apiService.checkServerConnectivity();
  print('Server connectivity check result: $connectivityResult');

  if (connectivityResult['isReachable']) {
    // Proceed with your app initialization
    runApp(MusicBudApp(
        isLoggedIn: isLoggedIn,
        apiService: apiService,
        chatService: chatService));
  } else {
    // Show an error message or handle the unreachable server scenario
    print(
        'Server is not reachable. Please check your connection and try again.');
    // You might want to show a dialog to the user or retry the connection
  }
}

class MusicBudApp extends StatelessWidget {
  final bool isLoggedIn;
  final ApiService apiService;
  final ChatService chatService;

  const MusicBudApp(
      {Key? key,
      required this.isLoggedIn,
      required this.apiService,
      required this.chatService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn
          ? HomePage(apiService: apiService, chatService: chatService)
          : LoginPage(apiService: apiService, chatService: chatService),
      routes: {
        '/home': (context) =>
            HomePage(apiService: apiService, chatService: chatService),
        '/login': (context) =>
            LoginPage(apiService: apiService, chatService: chatService),
        '/signup': (context) => SignUpPage(apiService: apiService),
        '/connect_services': (context) =>
            ConnectServicesPage(apiService: apiService),
      },
    );
  }
}
