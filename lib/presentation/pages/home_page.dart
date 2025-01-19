import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/presentation/pages/spotify_control_page.dart';
import 'package:musicbud_flutter/presentation/pages/profile_page.dart';
import 'package:musicbud_flutter/presentation/pages/chat_home_page.dart';
import 'package:musicbud_flutter/presentation/pages/connect_services_page.dart';
import 'package:musicbud_flutter/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
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
        if (state is UserError) {
          // If there's an error, navigate to login page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProfileLoaded) {
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
                  child: const Text('Go to Chat'),
                  onPressed: () {
                    if (_userProfile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatHomePage(
                            currentUsername: _userProfile!.username,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Spotify Control'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpotifyControlPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Connect Services'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnectServicesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
