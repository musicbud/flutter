import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/register/register_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/ytmusic/ytmusic_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/mal/mal_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/lastfm/lastfm_bloc.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/presentation/pages/login_page.dart';
import 'package:musicbud_flutter/presentation/pages/home_page.dart';
import 'package:musicbud_flutter/presentation/pages/signup_page.dart';
import 'package:musicbud_flutter/presentation/pages/connect_services_page.dart';
import 'package:musicbud_flutter/presentation/pages/spotify_connect_page.dart';
import 'package:musicbud_flutter/presentation/pages/ytmusic_connect_page.dart';
import 'package:musicbud_flutter/presentation/pages/mal_connect_page.dart';
import 'package:musicbud_flutter/presentation/pages/lastfm_connect_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService(baseUrl: 'http://localhost:8000');
  final chatService = ChatService(baseUrl: 'http://localhost:8000');
  final authRepository = AuthRepository(apiService: apiService);

  runApp(MusicBudApp(
    apiService: apiService,
    chatService: chatService,
    authRepository: authRepository,
  ));
}

class MusicBudApp extends StatelessWidget {
     
  final AuthRepository authRepository;

  const MusicBudApp({
    Key? key,
        
      ,
    required this.authRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authRepository: authRepository),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(authRepository: authRepository),
        ),
        BlocProvider<SpotifyBloc>(
          create: (context) => SpotifyBloc(authRepository: authRepository),
        ),
        BlocProvider<YTMusicBloc>(
          create: (context) => YTMusicBloc(authRepository: authRepository),
        ),
        BlocProvider<MALBloc>(
          create: (context) => MALBloc(authRepository: authRepository),
        ),
        BlocProvider<LastFMBloc>(
          create: (context) => LastFMBloc(authRepository: authRepository),
        ),
      ],
      child: MaterialApp(
        title: 'MusicBud',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/home': (context) => HomePage(
                apiService: apiService,
                chatService: chatService,
              ),
          '/login': (context) => LoginPage(
                apiService: apiService,
                chatService: chatService,
              ),
          '/signup': (context) => SignUpPage(apiService: apiService),
          '/connect_services': (context) =>
              ConnectServicesPage(apiService: apiService),
          '/connect/spotify': (context) =>
              SpotifyConnectPage(apiService: apiService),
          '/connect/ytmusic': (context) =>
              YtMusicConnectPage(apiService: apiService),
          '/connect/mal': (context) => MalConnectPage(apiService: apiService),
          '/connect/lastfm': (context) =>
              LastFmConnectPage(apiService: apiService),
        },
      ),
    );
  }
}
