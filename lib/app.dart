import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/main_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/login/login_bloc.dart';
import 'blocs/auth/register/register_bloc.dart';
import 'blocs/auth/spotify/spotify_bloc.dart';
import 'blocs/auth/ytmusic/ytmusic_bloc.dart';
import 'blocs/auth/mal/mal_bloc.dart';
import 'blocs/auth/lastfm/lastfm_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = GetIt.instance<AuthRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
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
          '/': (context) => const MainScreen(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
