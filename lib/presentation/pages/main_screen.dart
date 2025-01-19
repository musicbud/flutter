import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/main/main_screen_bloc.dart';
import '../../blocs/main/main_screen_event.dart';
import '../../blocs/main/main_screen_state.dart';
import '../widgets/loading_indicator.dart';
import 'login_page.dart';
import 'profile_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenBloc, MainScreenState>(
      listener: (context, state) {
        if (state is MainScreenFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        } else if (state is MainScreenUnauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      },
      builder: (context, state) {
        if (state is MainScreenLoading) {
          return const Scaffold(
            body: Center(child: LoadingIndicator()),
          );
        }

        if (state is MainScreenAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Welcome, ${state.username}'),
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
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context
                        .read<MainScreenBloc>()
                        .add(MainScreenRefreshRequested());
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to MusicBud!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connected Services: ${state.userProfile['connected_services']?.length ?? 0}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }

        // Initial state or any other state
        return const Scaffold(
          body: Center(
            child: Text('Loading...'),
          ),
        );
      },
    );
  }
}
