import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:musicbud_flutter/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:musicbud_flutter/data/repositories/auth_repository_impl.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/data/network/dio_client.dart';
import 'app.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/register/register_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/ytmusic/ytmusic_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/mal/mal_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/lastfm/lastfm_bloc.dart';
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
import 'package:musicbud_flutter/domain/repositories/api_repository.dart';
import 'package:musicbud_flutter/data/repositories/api_repository_impl.dart';
import 'package:musicbud_flutter/domain/repositories/chat_repository.dart';
import 'package:musicbud_flutter/data/repositories/chat_repository_impl.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';

void main() {
  setupDependencies();
}

void setupDependencies() {
  final getIt = GetIt.instance;

  // Network
  const baseUrl =
      'https://api.musicbud.com'; // Replace with your actual API URL
  getIt.registerLazySingleton(() => DioClient(baseUrl: baseUrl));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dioClient: getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ApiRepository>(
    () => ApiRepositoryImpl(baseUrl: baseUrl),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(baseUrl: baseUrl),
  );

  // Run the app
  runApp(MusicBudApp(
    authRepository: getIt<AuthRepository>(),
    apiRepository: getIt<ApiRepository>(),
    chatRepository: getIt<ChatRepository>(),
  ));
}

class MusicBudApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ApiRepository apiRepository;
  final ChatRepository chatRepository;

  const MusicBudApp({
    Key? key,
    required this.authRepository,
    required this.apiRepository,
    required this.chatRepository,
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
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(apiRepository: apiRepository),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(chatRepository: chatRepository),
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
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/connect_services': (context) => const ConnectServicesPage(),
          '/connect/spotify': (context) => const SpotifyConnectPage(),
          '/connect/ytmusic': (context) => const YtMusicConnectPage(),
          '/connect/mal': (context) => const MalConnectPage(),
          '/connect/lastfm': (context) => const LastFmConnectPage(),
        },
      ),
    );
  }
}
