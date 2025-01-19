import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/launcher/launcher_bloc.dart';
import '../../blocs/launcher/launcher_event.dart';
import '../../blocs/launcher/launcher_state.dart';
import '../widgets/loading_indicator.dart';

class LauncherPage extends StatefulWidget {
  final String title;

  const LauncherPage({Key? key, required this.title}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    super.initState();
    context.read<LauncherBloc>().add(LauncherAuthStatusChecked());
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LauncherBloc, LauncherState>(
      listener: (context, state) {
        if (state is LauncherFailure) {
          _showErrorSnackBar(state.error);
        } else if (state is LauncherNavigatingToSignup) {
          Navigator.pushNamed(context, '/signup');
        } else if (state is LauncherNavigatingToLogin) {
          Navigator.pushNamed(context, '/login');
        } else if (state is LauncherNavigatingToHome) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: state is LauncherLoading
                ? const LoadingIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Welcome to MusicBud',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {
                          context
                              .read<LauncherBloc>()
                              .add(LauncherNavigateToSignup());
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: const Text('Signup'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          context
                              .read<LauncherBloc>()
                              .add(LauncherNavigateToLogin());
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
