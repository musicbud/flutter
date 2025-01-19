import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/main/main_screen_bloc.dart';
import '../../blocs/main/main_screen_event.dart';
import '../../blocs/main/main_screen_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../widgets/loading_indicator.dart';
import 'login_page.dart';
import 'profile_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: BlocConsumer<MainScreenBloc, MainScreenState>(
        listener: (context, state) {
          if (state is MainScreenFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is MainScreenUnauthenticated) {
            context.read<AuthBloc>().add(LogoutRequested());
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
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<MainScreenBloc>()
                      .add(MainScreenRefreshRequested());
                },
                child: ListView(
                  children: [
                    // Your main screen content here
                  ],
                ),
              ),
            );
          }

          // Handle initial state
          return const Scaffold(
            body: Center(child: LoadingIndicator()),
          );
        },
      ),
    );
  }
}
