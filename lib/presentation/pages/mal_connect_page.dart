import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/auth/mal/mal_bloc.dart';
import '../../blocs/auth/mal/mal_event.dart';
import '../../blocs/auth/mal/mal_state.dart';

class MALConnectPage extends StatefulWidget {
  const MALConnectPage({super.key});

  @override
  State<MALConnectPage> createState() => _MALConnectPageState();
}

class _MALConnectPageState extends State<MALConnectPage> {
  @override
  void initState() {
    super.initState();
    context.read<MALBloc>().add(MALAuthUrlRequested());
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch MAL auth')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MALBloc, MALState>(
      listener: (context, state) {
        if (state is MALAuthUrlLoaded) {
          _launchUrl(state.url);
        } else if (state is MALFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Connect to MAL'),
          ),
          body: Center(
            child: state is MALLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      context.read<MALBloc>().add(MALAuthUrlRequested());
                    },
                    child: const Text('Connect to MAL'),
                  ),
          ),
        );
      },
    );
  }
}
