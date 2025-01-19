import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/chat/chat_bloc.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/data_sources/remote/user_remote_data_source.dart';
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

  const baseUrl = 'http://127.0.0.1:8000'; // Replace with your actual API URL
  final client = http.Client();
  const token = ''; // Replace with actual token handling

  // Initialize network client
  final dioClient = DioClient(baseUrl: baseUrl);

  // Initialize data sources
  final userRemoteDataSource = UserRemoteDataSourceImpl(
    client: client,
    token: token,
  );

  // Initialize repositories
  final AuthRepository authRepository =
      AuthRepositoryImpl(dioClient: dioClient);
  final UserRepository userRepository =
      UserRepositoryImpl(remoteDataSource: userRemoteDataSource);
  final ChatRepository chatRepository = ChatRepositoryImpl(baseUrl: baseUrl);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(chatRepository: chatRepository),
        ),
      ],
      child: const App(),
    ),
  );
}
