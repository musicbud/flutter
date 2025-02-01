import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/user/user_event.dart';
import 'blocs/chat/chat_bloc.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/datasources/user_remote_data_source_impl.dart';
import 'data/network/dio_client.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/chat_repository.dart';
import 'app.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  const baseUrl = 'http://84.235.170.234';
  final dioClient = DioClient(baseUrl: baseUrl);
  final client = http.Client();

  // Initialize repositories and data sources
  final authRepo = AuthRepositoryImpl(dioClient: dioClient);
  final userRemoteDataSource = UserRemoteDataSourceImpl(
    client: client,
    token: '', // Initialize with empty string
  );

  // Initialize repositories
  final AuthRepository authRepository = authRepo;
  final UserRepository userRepository =
      UserRepositoryImpl(remoteDataSource: userRemoteDataSource);
  final ChatRepository chatRepository = ChatRepositoryImpl(baseUrl: baseUrl);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
        BlocProvider<AuthBloc>(
          create: (context) {
            final authBloc = AuthBloc(authRepository: authRepository);
            authBloc.stream.listen((state) {
              if (state is Authenticated) {
                context.read<UserBloc>().add(UpdateToken(token: state.token));
              }
            });
            return authBloc;
          },
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(chatRepository: chatRepository),
        ),
      ],
      child: const App(),
    ),
  );
}
