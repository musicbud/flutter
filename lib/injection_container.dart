import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Network
import 'data/network/dio_client.dart';
import 'data/network/dio_client_adapter.dart';
import 'core/network/network_info.dart';

// Providers
import 'data/providers/token_provider.dart';

// Data Sources
import 'data/data_sources/remote/content_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source_impl.dart';
import 'data/data_sources/remote/bud_remote_data_source.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/data_sources/remote/chat_remote_data_source.dart';
import 'data/data_sources/remote/user_profile_remote_data_source.dart';
import 'data/data_sources/remote/analytics_remote_data_source.dart';
import 'config/api_config.dart';
import 'data/data_sources/remote/bud_matching_remote_data_source.dart';
import 'data/data_sources/remote/chat_management_remote_data_source.dart';
import 'data/data_sources/remote/settings_remote_data_source.dart';
import 'data/data_sources/remote/event_remote_data_source.dart';
// import 'data/data_sources/remote/admin_remote_data_source.dart'; // Not used - conflicting implementation
import 'data/data_sources/remote/channel_remote_data_source.dart';
import 'data/data_sources/remote/search_remote_data_source.dart';
import 'data/data_sources/remote/common_items_remote_data_source.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/bud_repository_impl.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/user_profile_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/event_repository_impl.dart';
import 'data/repositories/analytics_repository_impl.dart';
import 'data/repositories/admin_repository_impl.dart';
import 'data/repositories/channel_repository_impl.dart';
import 'data/repositories/search_repository_impl.dart';
import 'data/repositories/services_repository_impl.dart';
import 'data/repositories/library_repository_impl.dart';
import 'data/repositories/common_items_repository_impl.dart';
import 'data/data_sources/remote/admin_remote_data_source.dart';

// Domain Interfaces
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/repositories/content_repository.dart';
import 'domain/repositories/bud_repository.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/user_profile_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/event_repository.dart';
import 'domain/repositories/analytics_repository.dart';
import 'domain/repositories/admin_repository.dart';
import 'domain/repositories/channel_repository.dart';
import 'domain/repositories/search_repository.dart';
import 'domain/repositories/services_repository.dart';
import 'domain/repositories/library_repository.dart';
import 'domain/repositories/common_items_repository.dart';

// BLoCs
import 'blocs/user/user_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/main/main_screen_bloc.dart';
import 'blocs/settings/settings_bloc.dart';
import 'blocs/event/event_bloc.dart';
import 'blocs/analytics/analytics_bloc.dart';
import 'presentation/blocs/admin/admin_bloc.dart';
import 'presentation/blocs/channel/channel_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'blocs/user_profile/user_profile_bloc.dart';
import 'blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import 'blocs/chat/chat_bloc.dart';
import 'blocs/library/library_bloc.dart';
import 'blocs/bud/bud_bloc.dart';
import 'blocs/bud/common_items/bud_common_items_bloc.dart';
import 'blocs/artist/artist_bloc.dart';
import 'blocs/content/content_bloc.dart';

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

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    InternetConnectionChecker(),
    connectivity: Connectivity(),
  ));
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

  // User Profile Data Source
  sl.registerLazySingleton<UserProfileRemoteDataSource>(
    () => UserProfileRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Analytics Data Source
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSource(dio: sl<Dio>()),
  );

  // Bud Matching Data Source
  sl.registerLazySingleton<BudMatchingRemoteDataSource>(
    () => BudMatchingRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Chat Management Data Source
  sl.registerLazySingleton<ChatManagementRemoteDataSource>(
    () => ChatManagementRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Settings Data Source
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(dioClient: sl<Dio>()),
  );

  // Event Data Source
  sl.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(dioClient: sl<Dio>()),
  );

  // Admin Data Source
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Channel Data Source
  sl.registerLazySingleton<ChannelRemoteDataSource>(
    () => ChannelRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  // Search Data Source
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(client: sl<Dio>()),
  );

  // Common Items Data Source
  sl.registerLazySingleton<CommonItemsRemoteDataSource>(
    () => CommonItemsRemoteDataSourceImpl(
      client: sl<http.Client>(),
      token: '', // TODO: Get token from token provider
    ),
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

  // Analytics Repository
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      remoteDataSource: sl<AnalyticsRemoteDataSource>(),
    ),
  );

  // Chat Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatRemoteDataSource: sl<ChatRemoteDataSource>(),
    ),
  );

  // User Profile Repository
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(
      remoteDataSource: sl<UserProfileRemoteDataSource>(),
    ),
  );

  // Settings Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: sl<SettingsRemoteDataSource>(),
    ),
  );

  // Event Repository
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      remoteDataSource: sl<EventRemoteDataSource>(),
    ),
  );

  // Admin Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(
      remoteDataSource: sl<AdminRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Channel Repository
  sl.registerLazySingleton<ChannelRepository>(
    () => ChannelRepositoryImpl(
      remoteDataSource: sl<ChannelRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Search Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: sl<SearchRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Services Repository
  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(
      userRepository: sl<UserRepository>(),
    ),
  );

  // Library Repository
  sl.registerLazySingleton<LibraryRepository>(
    () => LibraryRepositoryImpl(
      contentRepository: sl<ContentRepository>(),
      userRepository: sl<UserRepository>(),
    ),
  );

  // Common Items Repository
  sl.registerLazySingleton<CommonItemsRepository>(
    () => CommonItemsRepositoryImpl(
      remoteDataSource: sl<CommonItemsRemoteDataSource>(),
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
    userProfileRepository: sl<UserProfileRepository>(),
    contentRepository: sl<ContentRepository>(),
    userRepository: sl<UserRepository>(),
  ));

  // Analytics BLoC
  sl.registerFactory<AnalyticsBloc>(() => AnalyticsBloc(
    analyticsRepository: sl<AnalyticsRepository>(),
  ));

  // Main Screen BLoC
  sl.registerFactory<MainScreenBloc>(() => MainScreenBloc(
    profileRepository: sl<ProfileRepository>(),
  ));

  // Settings BLoC
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(
    settingsRepository: sl<SettingsRepository>(),
  ));

  // Event BLoC
  sl.registerFactory<EventBloc>(() => EventBloc(
    eventRepository: sl<EventRepository>(),
  ));

  // Admin BLoC
  sl.registerFactory<AdminBloc>(() => AdminBloc(
    repository: sl<AdminRepository>(),
  ));

  // Channel BLoC
  sl.registerFactory<ChannelBloc>(() => ChannelBloc(
    repository: sl<ChannelRepository>(),
  ));

  // Search BLoC
  sl.registerFactory<SearchBloc>(() => SearchBloc(
    repository: sl<SearchRepository>(),
  ));

  // User Profile BLoC
  sl.registerFactory<UserProfileBloc>(() => UserProfileBloc(
    userProfileRepository: sl<UserProfileRepository>(),
  ));

  // Comprehensive Chat BLoC
  sl.registerFactory<ComprehensiveChatBloc>(() => ComprehensiveChatBloc(
    chatRepository: sl<ChatRepository>(),
    userRepository: sl<UserRepository>(),
    servicesRepository: sl<ServicesRepository>(),
    authRepository: sl<AuthRepository>(),
  ));

  // Chat BLoC
  sl.registerFactory<ChatBloc>(() => ChatBloc(
    chatRepository: sl<ChatRepository>(),
  ));

  // Library BLoC
  sl.registerFactory<LibraryBloc>(() => LibraryBloc(
    contentRepository: sl<ContentRepository>(),
    userRepository: sl<UserRepository>(),
  ));

  // Content BLoC
  sl.registerFactory<ContentBloc>(() => ContentBloc(
    contentRepository: sl<ContentRepository>(),
  ));

  // Bud BLoC
  sl.registerFactory<BudBloc>(() => BudBloc(
    budRepository: sl<BudRepository>(),
    commonItemsRepository: sl<CommonItemsRepository>(),
  ));

  // Artist BLoC
  sl.registerFactory<ArtistBloc>(() => ArtistBloc(
    contentRepository: sl<ContentRepository>(),
    budRepository: sl<BudRepository>(),
  ));

  // Bud Common Items BLoC
  sl.registerFactory<BudCommonItemsBloc>(() => BudCommonItemsBloc(
    budRepository: sl<BudRepository>(),
  ));
}

/// Logs dependency registration for debugging
void _logDependencyRegistration() {
  debugPrint('🔧 Dependency Injection Registration Complete');
  debugPrint('📡 Network: DioClient, DioClientAdapter');
  debugPrint('💾 Data Sources: Content, User, Bud, UserProfile, BudMatching, ChatManagement, Settings, Event, Admin, Channel, Search');
  debugPrint('🏗️ Repositories: Auth, Content, Bud, User, Profile, UserProfile, BudMatching, ChatManagement, Settings, Event, Admin, Channel, Search, CommonItems');
  debugPrint('🧠 BLoCs: User, Auth, Profile, MainScreen, Chat, Content, Bud, UserProfile, BudMatching, ChatManagement, Settings, Event, Analytics, Admin, Channel, Search, Bud, Artist, BudCommonItems');
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