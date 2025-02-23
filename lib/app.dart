import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/lastfm/lastfm_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/mal/mal_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/register/register_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/ytmusic/ytmusic_bloc.dart';
import 'package:musicbud_flutter/blocs/main/main_screen_bloc.dart';
import 'package:musicbud_flutter/blocs/profile/profile_bloc.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/domain/repositories/bud_repository.dart';
import 'package:musicbud_flutter/domain/repositories/content_repository.dart';
import 'package:musicbud_flutter/domain/repositories/profile_repository.dart';
import 'package:musicbud_flutter/presentation/pages/home_page.dart';
import 'package:musicbud_flutter/presentation/pages/login_page.dart';
import 'package:musicbud_flutter/presentation/pages/main_screen.dart';
import 'package:musicbud_flutter/presentation/pages/profile_page.dart';
import 'package:musicbud_flutter/utils/colors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepository = GetIt.instance<AuthRepository>();
    final profileRepository = GetIt.instance<ProfileRepository>();
    final contentRepository = GetIt.instance<ContentRepository>();
    final budRepository = GetIt.instance<BudRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            profileRepository: profileRepository,
            contentRepository: contentRepository,
            budRepository: budRepository,
          ),
        ),
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
        BlocProvider<YtMusicBloc>(
          create: (context) => YtMusicBloc(authRepository: authRepository),
        ),
        BlocProvider<MALBloc>(
          create: (context) => MALBloc(authRepository: authRepository),
        ),
        BlocProvider<LastFmBloc>(
          create: (context) => LastFmBloc(authRepository: authRepository),
        ),
        BlocProvider<MainScreenBloc>(
          create: (context) => MainScreenBloc(
            profileRepository: GetIt.instance<ProfileRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MusicBud',
        theme: ThemeData(
          colorScheme: AppColors.colorScheme,
          useMaterial3: true,
          textTheme: GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        ),
        initialRoute: '/login',
        routes: {
          '/': (context) => const MainScreen(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
