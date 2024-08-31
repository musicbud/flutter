import 'package:flutter/material.dart';
import 'package:musicbud_flutter/pages/profile_page.dart';
import 'package:musicbud_flutter/services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  
  // Set the auth token
  apiService.setAuthToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzI1MTQ3OTIzLCJpYXQiOjE3MjUwNjE1MjMsImp0aSI6IjJjOTdhMTc0OThlMjRjYjE4YmMwNmI1ZGFmMWQwMmE0IiwidXNlcl9pZCI6MTQ0MH0.ZqoUHDAIHOOwb4zQYtRBjq5qrnfVo3GDrVnrjgB3k3Q');
  
  // Set the session ID
  apiService.setSessionId('8jnl9l28o3egdc25ezykc3v5may4o74i');

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(apiService: apiService),
    );
  }
}

