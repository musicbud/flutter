import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicbud_flutter/pages/profile_page.dart';
import 'package:musicbud_flutter/pages/login_page.dart';
import 'package:musicbud_flutter/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  runApp(MyApp(apiService: apiService, initialToken: token));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final String? initialToken;

  const MyApp({Key? key, required this.apiService, this.initialToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: initialToken != null
          ? ProfilePage(apiService: apiService)
          : LoginPage(apiService: apiService),
    );
  }
}

