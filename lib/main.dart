import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/user/user_event.dart';
import 'blocs/services/services_bloc.dart';
import 'data/providers/token_provider.dart';
import 'domain/repositories/auth_repository.dart';
import 'app.dart';
import 'injection_container.dart' as di;
import 'blocs/profile/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();  // Initialize GetIt dependencies

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => di.sl<UserBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => di.sl<ProfileBloc>(),
        ),
        BlocProvider<ServicesBloc>(
          create: (context) => di.sl<ServicesBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) {
            final authBloc = AuthBloc(authRepository: di.sl<AuthRepository>());
            authBloc.stream.listen((state) {
              if (state is Authenticated) {
                if (context.mounted) {
                  di.sl<TokenProvider>().updateToken(state.token);
                  context.read<UserBloc>().add(UpdateToken(token: state.token));
                }
              }
            });
            return authBloc;
          },
        ),
      ],
      child: const App(),
    ),
  );
}
