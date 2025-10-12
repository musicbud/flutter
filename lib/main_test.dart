import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/discover/discover_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'data/data_sources/remote/content_remote_data_source_impl.dart';
import 'data/data_sources/remote/user_remote_data_source_impl.dart';
import 'data/data_sources/local/auth_local_data_source_impl.dart';
import 'data/data_sources/local/content_local_data_source_impl.dart';
import 'data/data_sources/local/user_local_data_source_impl.dart';
import 'data/providers/token_provider.dart';
import 'data/providers/network_provider.dart';
import 'presentation/screens/home/dynamic_home_screen.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final tokenProvider = TokenProvider();
    final networkProvider = NetworkProvider();
    
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(
              tokenProvider: tokenProvider,
              networkProvider: networkProvider,
            ),
            localDataSource: AuthLocalDataSourceImpl(),
            tokenProvider: tokenProvider,
          ),
        ),
        RepositoryProvider<ContentRepositoryImpl>(
          create: (context) => ContentRepositoryImpl(
            remoteDataSource: ContentRemoteDataSourceImpl(
              tokenProvider: tokenProvider,
              networkProvider: networkProvider,
            ),
            localDataSource: ContentLocalDataSourceImpl(),
          ),
        ),
        RepositoryProvider<UserRepositoryImpl>(
          create: (context) => UserRepositoryImpl(
            remoteDataSource: UserRemoteDataSourceImpl(
              tokenProvider: tokenProvider,
              networkProvider: networkProvider,
            ),
            localDataSource: UserLocalDataSourceImpl(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepositoryImpl>(),
              tokenProvider: tokenProvider,
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: context.read<UserRepositoryImpl>(),
            ),
          ),
          BlocProvider<ContentBloc>(
            create: (context) => ContentBloc(
              contentRepository: context.read<ContentRepositoryImpl>(),
            ),
          ),
          BlocProvider<DiscoverBloc>(
            create: (context) => DiscoverBloc(
              contentRepository: context.read<ContentRepositoryImpl>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'MusicBud Test',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const DynamicHomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}