import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// Network
import 'data/network/dio_client.dart';
import 'data/network/dio_client_adapter.dart';

// Providers
import 'data/providers/token_provider.dart';

// Data Sources
import 'data/data_sources/remote/content_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source_impl.dart';
import 'data/data_sources/remote/bud_remote_data_source.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/data_sources/remote/chat_remote_data_source.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/bud_repository_impl.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';

// Domain Interfaces
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/repositories/content_repository.dart';
import 'domain/repositories/bud_repository.dart';
import 'domain/repositories/chat_repository.dart';

// BLoCs
import 'blocs/user/user_bloc.dart';
import 'blocs/auth/auth_bloc.dart';

import 'blocs/profile/profile_bloc.dart';
import 'blocs/main/main_screen_bloc.dart';
import 'blocs/chat/chat_bloc.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/bud/bud_bloc.dart';

// Configuration
import 'config/api_config.dart';

/// Global GetIt instance for dependency injection
final sl = GetIt.instance;

/// Initializes all dependencies for the application
Future<void> init() async {
  await _registerExternalDependencies();
  await _registerNetworkDependencies();
  await _registerDataSources();
  await _registerRepositories();
  await _registerBlocs();

  if (kDebugMode) {
    _logDependencyRegistration();
  }
}

/// Registers external dependencies (HTTP clients, etc.)
Future<void> _registerExternalDependencies() async {
  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Dio HTTP Client
  sl.registerLazySingleton<Dio>(() => _createDioInstance());

  // Token Provider
  sl.registerLazySingleton<TokenProvider>(() => TokenProvider());
}

/// Creates and configures the Dio instance with interceptors
Dio _createDioInstance() {
  final dio = Dio();

  // Add logging interceptors in debug mode
  if (kDebugMode) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('🌐 [${options.method}] Request: ${options.uri}');
        if (options.data != null) {
          debugPrint('Body: ${options.data}');
        }
        if (options.headers.isNotEmpty) {
          debugPrint('Headers: ${options.headers}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('✅ [${response.statusCode}] Response: ${response.requestOptions.uri}');
        debugPrint('Body: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint('❌ [${error.response?.statusCode}] Error: ${error.requestOptions.uri}');
        debugPrint('Message: ${error.message}');
        if (error.response?.data != null) {
          debugPrint('Body: ${error.response?.data}');
        }
        return handler.next(error);
      },
    ));
  }

  return dio;
}

/// Registers network-related dependencies
Future<void> _registerNetworkDependencies() async {
  // DioClient - Main HTTP client wrapper
  sl.registerLazySingleton<DioClient>(() => DioClient(
    baseUrl: ApiConfig.baseUrl,
    dio: sl<Dio>(),
    tokenProvider: sl<TokenProvider>(),
  ));

  // DioClientAdapter - HTTP client adapter for compatibility
  sl.registerLazySingleton<DioClientAdapter>(() => DioClientAdapter(
    dioClient: sl<DioClient>(),
    tokenProvider: sl<TokenProvider>(),
  ));
}

/// Registers data source dependencies
Future<void> _registerDataSources() async {
  // Content Data Source
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // User Data Source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      tokenProvider: sl<TokenProvider>(),
    ),
  );

  // Bud Data Source
  sl.registerLazySingleton<BudRemoteDataSource>(
    () => BudRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Auth Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Chat Data Source
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );
}

/// Registers repository dependencies
Future<void> _registerRepositories() async {
  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
    ),
  );

  // Content Repository
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      remoteDataSource: sl<ContentRemoteDataSource>(),
    ),
  );

  // Bud Repository
  sl.registerLazySingleton<BudRepository>(
    () => BudRepositoryImpl(
      budRemoteDataSource: sl<BudRemoteDataSource>(),
    ),
  );

  // User Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserRemoteDataSource>(),
    ),
  );

  // Profile Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // Chat Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatRemoteDataSource: sl<ChatRemoteDataSource>(),
    ),
  );
}

/// Registers BLoC dependencies
Future<void> _registerBlocs() async {
  // User BLoC
  sl.registerFactory<UserBloc>(() => UserBloc(
    userRepository: sl<UserRepository>(),
  ));

  // Auth BLoC
  sl.registerFactory<AuthBloc>(() => AuthBloc(
    authRepository: sl<AuthRepository>(),
  ));



  // Profile BLoC
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(
    profileRepository: sl<ProfileRepository>(),
    contentRepository: sl<ContentRepository>(),
    budRepository: sl<BudRepository>(),
  ));

  // Main Screen BLoC
  sl.registerFactory<MainScreenBloc>(() => MainScreenBloc(
    profileRepository: sl<ProfileRepository>(),
  ));

  // Chat BLoC
  sl.registerFactory<ChatBloc>(() => ChatBloc(
    chatRepository: sl<ChatRepository>(),
  ));

  // Content BLoC
  sl.registerFactory<ContentBloc>(() => ContentBloc(
    contentRepository: sl<ContentRepository>(),
  ));

  // Bud BLoC
  sl.registerFactory<BudBloc>(() => BudBloc(
    budRepository: sl<BudRepository>(),
  ));
}

/// Logs dependency registration for debugging
void _logDependencyRegistration() {
  debugPrint('🔧 Dependency Injection Registration Complete');
  debugPrint('📡 Network: DioClient, DioClientAdapter');
  debugPrint('💾 Data Sources: Content, User, Bud');
  debugPrint('🏗️ Repositories: Auth, Content, Bud, User, Profile');
  debugPrint('🧠 BLoCs: User, Auth, Services, Profile, Chat, Content, Bud');
}

/// Dependency injection utilities
class DependencyInjection {
  /// Gets a dependency by type
  static T get<T extends Object>() => sl<T>();

  /// Checks if a dependency is registered
  static bool isRegistered<T extends Object>() => sl.isRegistered<T>();

  /// Resets all dependencies (useful for testing)
  static void reset() => sl.reset();
}