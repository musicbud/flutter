import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Network
import 'data/network/dio_client.dart';
import 'data/network/dio_client_adapter.dart';
import 'data/network/enhanced_logging_interceptor.dart';
import 'core/network/network_info.dart';

// Services
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/endpoint_config_service.dart';

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
import 'data/data_sources/remote/spotify_remote_data_source.dart';
import 'data/data_sources/remote/spotify_remote_data_source_impl.dart';
import 'presentation/screens/discover/discover_content_manager.dart';
import 'data/data_sources/local/tracking_local_data_source.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/bud_repository_impl.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/user_repository_imp.dart';
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
import 'data/repositories/spotify_repository_impl.dart';
import 'data/repositories/discover_repository_impl.dart';
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
import 'domain/repositories/spotify_repository.dart';
import 'domain/repositories/bud_matching_repository.dart';
import 'domain/repositories/discover_repository.dart';
import 'data/repositories/bud_matching_repository_impl.dart';

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
import 'blocs/user_profile/simple_user_profile_bloc.dart';
import 'blocs/profile/simple_profile_bloc.dart';
import 'blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import 'blocs/chat/chat_bloc.dart';
import 'blocs/library/library_bloc.dart';
import 'blocs/bud/bud_bloc.dart';
import 'blocs/bud/common_items/bud_common_items_bloc.dart';
import 'blocs/artist/artist_bloc.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/spotify/spotify_bloc.dart';
import 'blocs/bud_matching/bud_matching_bloc.dart';
import 'blocs/discover/discover_bloc.dart';

/// Global GetIt instance for dependency injection
final sl = GetIt.instance;

/// Initializes all dependencies for the application
Future<void> init() async {
  await _registerExternalDependencies();
  await _registerNetworkDependencies();
  await _registerDataSources();
  await _registerRepositories();
  await _registerBlocs();

  // Initialize services that require async setup
  await sl<EndpointConfigService>().initialize();

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
  await sl<TokenProvider>().initialize();

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    InternetConnectionChecker.createInstance(),
    connectivity: Connectivity(),
  ));
}

/// Creates and configures the Dio instance with interceptors
Dio _createDioInstance() {
  final dio = Dio();

  // Add enhanced logging interceptor in debug mode
  if (kDebugMode) {
    dio.interceptors.add(EnhancedLoggingInterceptor(
      logRequests: true,
      logResponses: true,
      logErrors: true,
      logPerformance: true,
      maxBodyLength: 2000,
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

  // ApiService - Main API service
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // AuthService - Authentication service
  sl.registerLazySingleton<AuthService>(() => AuthService());

  // EndpointConfigService - Dynamic endpoint configuration
  sl.registerLazySingleton<EndpointConfigService>(() => EndpointConfigService());
}

/// Registers data source dependencies
Future<void> _registerDataSources() async {
  // Content Data Source
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      endpointConfigService: sl<EndpointConfigService>(),
    ),
  );

  // User Data Source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      tokenProvider: sl<TokenProvider>(),
      endpointConfigService: sl<EndpointConfigService>(),
    ),
  );

  // Bud Data Source
  sl.registerLazySingleton<BudRemoteDataSource>(
    () => BudRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      endpointConfigService: sl<EndpointConfigService>(),
    ),
  );

  // Auth Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      endpointConfigService: sl<EndpointConfigService>(),
    ),
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
    () => BudMatchingRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      endpointConfigService: sl<EndpointConfigService>(),
    ),
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
    () => SearchRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Common Items Data Source
  sl.registerLazySingleton<CommonItemsRemoteDataSource>(
    () => CommonItemsRemoteDataSourceImpl(
      client: sl<http.Client>(),
      token: '', // TODO: Get token from token provider
    ),
  );

  // Spotify Data Source
  sl.registerLazySingleton<SpotifyRemoteDataSource>(
    () => SpotifyRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Tracking Local Data Source
  sl.registerLazySingleton<TrackingLocalDataSource>(
    () => TrackingLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
}

/// Registers repository dependencies
Future<void> _registerRepositories() async {
  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
      tokenProvider: sl<TokenProvider>(),
    ),
  );

  // Content Repository
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      remoteDataSource: sl<ContentRemoteDataSource>(),
      trackingLocalDataSource: sl<TrackingLocalDataSource>(),
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
    () => UserRepositoryImp(
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
    () => LibraryRepositoryImpl(),
  );

  // Common Items Repository
  sl.registerLazySingleton<CommonItemsRepository>(
    () => CommonItemsRepositoryImpl(
      remoteDataSource: sl<CommonItemsRemoteDataSource>(),
    ),
  );

  // Spotify Repository
  sl.registerLazySingleton<SpotifyRepository>(
    () => SpotifyRepositoryImpl(
      remoteDataSource: sl<SpotifyRemoteDataSource>(),
    ),
  );

  // Bud Matching Repository
  sl.registerLazySingleton<BudMatchingRepository>(
    () => BudMatchingRepositoryImpl(
      remoteDataSource: sl<BudMatchingRemoteDataSource>(),
    ),
  );

  // Discover Repository
  sl.registerLazySingleton<DiscoverRepository>(
    () => DiscoverRepositoryImpl(
      userProfileRepository: sl<UserProfileRepository>(),
      contentRemoteDataSource: sl<ContentRemoteDataSource>(),
    ),
  );

  // Discover Content Manager
  sl.registerLazySingleton<DiscoverContentManager>(
    () => DiscoverContentManager(repository: sl<DiscoverRepository>()),
  );
}

/// Registers BLoC dependencies
Future<void> _registerBlocs() async {
  // User BLoC
  sl.registerFactory<UserBloc>(() => UserBloc(userRepository: sl<UserRepository>()));

  // Auth BLoC
  sl.registerFactory<AuthBloc>(() => AuthBloc(
    authRepository: sl<AuthRepository>(),
    tokenProvider: sl<TokenProvider>(),
  ));

  // Profile BLoC
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(
    userProfileRepository: sl<UserProfileRepository>(),
    contentRepository: sl<ContentRepository>(),
    userRepository: sl<UserRepository>(),
  ));

  // Simple Profile BLoC
  sl.registerFactory<SimpleProfileBloc>(() => SimpleProfileBloc(
    sl<UserRepository>(),
  ));

  // Analytics BLoC
  sl.registerFactory<AnalyticsBloc>(() => AnalyticsBloc(
    analyticsRepository: sl<AnalyticsRepository>(),
  ));

  // Main Screen BLoC
  sl.registerFactory<MainScreenBloc>(() => MainScreenBloc(
    profileRepository: sl<ProfileRepository>(),
    contentRepository: sl<ContentRepository>(),
    discoverRepository: sl<DiscoverRepository>(),
  ));

  // Settings BLoC
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(
    settingsRepository: sl<SettingsRepository>(),
    authRepository: sl<AuthRepository>(),
    userProfileRepository: sl<UserProfileRepository>(),
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

  // Simple User Profile BLoC
  sl.registerFactory<SimpleUserProfileBloc>(() => SimpleUserProfileBloc(
    sl<UserRepository>(),
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

  // Spotify BLoC
  sl.registerFactory<SpotifyBloc>(() => SpotifyBloc(
    sl<SpotifyRepository>(),
  ));

  // Bud Matching BLoC
  sl.registerFactory<BudMatchingBloc>(() => BudMatchingBloc(
    budMatchingRepository: sl<BudMatchingRepository>(),
  ));

  // Discover BLoC
  sl.registerFactory<DiscoverBloc>(() => DiscoverBloc(
    repository: sl<DiscoverRepository>(),
  ));
}

/// Logs dependency registration for debugging
void _logDependencyRegistration() {
  debugPrint('🔧 Dependency Injection Registration Complete');
  debugPrint('📡 Network: DioClient, DioClientAdapter');
  debugPrint('💾 Data Sources: Content, User, Bud, UserProfile, BudMatching, ChatManagement, Settings, Event, Admin, Channel, Search');
  debugPrint('🏗️ Repositories: Auth, Content, Bud, User, Profile, UserProfile, BudMatching, ChatManagement, Settings, Event, Admin, Channel, Search, CommonItems, Spotify, Discover');
  debugPrint('🧠 BLoCs: User, Auth, Profile, SimpleProfile, MainScreen, Chat, Content, Bud, UserProfile, SimpleUserProfile, BudMatching, ChatManagement, Settings, Event, Analytics, Admin, Channel, Search, Bud, Artist, BudCommonItems, Spotify, Discover');
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