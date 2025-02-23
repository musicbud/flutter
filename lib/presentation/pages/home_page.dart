import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../blocs/user/user_event.dart';
import '../../domain/models/user_profile.dart';
import 'spotify_control_page.dart';
import 'profile_page.dart';
import 'chat_home_page.dart';
import 'connect_services_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    context.read<UserBloc>().add(LoadMyProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        debugPrint('UserBloc State Changed: ${state.runtimeType}');
        // if (state is UserError) {
        //   debugPrint('UserError: ${(state as UserError).message}');
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //       builder: (context) => const LoginPage(),
        //     ),
        //   );
        // }
      },
      builder: (context, state) {
        debugPrint('UserBloc Builder State: ${state.runtimeType}');
        if (state is UserLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProfileLoaded) {
          debugPrint('Profile Loaded: ${state.profile.username}');
          _userProfile = state.profile;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('MusicBud'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to MusicBud!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (_userProfile != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Hello, ${_userProfile!.username}!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _userProfile != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatHomePage(
                                currentUsername: _userProfile!.username,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Go to Chat'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpotifyControlPage(),
                      ),
                    );
                  },
                  child: const Text('Spotify Control'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnectServicesPage(),
                      ),
                    );
                  },
                  child: const Text('Connect Services'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
