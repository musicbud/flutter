import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data/network/dio_client.dart';
import 'data/providers/token_provider.dart';
import 'core/network/network_info.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/repositories/bud_repository.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/common_items_repository.dart';
import 'domain/repositories/content_repository.dart';
import 'domain/repositories/discover_repository.dart';
import 'domain/repositories/user_profile_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/bud_matching_repository.dart';
import 'domain/repositories/services_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/bud_matching_repository_impl.dart';
import 'data/repositories/services_repository_impl.dart';
import 'data/repositories/user_profile_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/repositories/bud_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/common_items_repository_impl.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/discover_repository_impl.dart';
import 'data/repositories/user_repository_imp.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/data_sources/remote/bud_remote_data_source.dart';
import 'data/data_sources/remote/chat_remote_data_source.dart';
import 'data/data_sources/remote/common_items_remote_data_source.dart';
import 'data/data_sources/remote/content_remote_data_source.dart';
import 'data/data_sources/remote/user_profile_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source_impl.dart';
import 'data/data_sources/remote/bud_matching_remote_data_source.dart';
import 'data/data_sources/local/tracking_local_data_source.dart';
import 'services/endpoint_config_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/login/login_bloc.dart';
import 'blocs/auth/register/register_bloc.dart';
import 'blocs/bud/bud_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/main/main_screen_bloc.dart';
import 'blocs/discover/discover_bloc.dart';
import 'blocs/library/library_bloc.dart';
import 'blocs/bud_matching/bud_matching_bloc.dart';
import 'blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import 'blocs/simple_content_bloc.dart';
import 'blocs/content/content_bloc.dart';
import 'debug/debug_dashboard.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final dio = Dio();
  
  // Add debug interceptor in debug mode
  if (kDebugMode) {
    dio.interceptors.add(DebugDioInterceptor());
  }
  
  // Add comprehensive logging interceptor
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
  
  sl.registerLazySingleton(() => dio);
  
  // Network
  sl.registerLazySingleton(() => DioClient(
    baseUrl: 'http://127.0.0.1:8000/v1',
    dio: sl<Dio>(),
    tokenProvider: sl<TokenProvider>(),
  ));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    InternetConnectionChecker.createInstance(),
  ));
  
  // Data sources
  sl.registerLazySingleton<TokenProvider>(() => TokenProvider());
  
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Register TrackingLocalDataSource
  sl.registerLazySingleton<TrackingLocalDataSource>(() => TrackingLocalDataSourceImpl(
    sharedPreferences: sl(),
  ));
  
  // Services - Initialize EndpointConfigService
  final endpointConfigService = EndpointConfigService();
  await endpointConfigService.initialize();
  sl.registerLazySingleton<EndpointConfigService>(() => endpointConfigService);
  
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
    dioClient: sl(),
    endpointConfigService: sl(),
  ));
  sl.registerLazySingleton<BudRemoteDataSource>(() => BudRemoteDataSourceImpl(
    dioClient: sl(),
    endpointConfigService: sl(),
  ));
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(
    dioClient: sl(),
  ));
  sl.registerLazySingleton<CommonItemsRemoteDataSource>(() => CommonItemsRemoteDataSourceImpl(
    client: http.Client(),
    token: '',
  ));
  // Register ContentRemoteDataSource with proper parameters
  sl.registerLazySingleton<ContentRemoteDataSource>(() => ContentRemoteDataSourceImpl(
    dioClient: sl(),
    endpointConfigService: sl(),
  ));
  
  // Register UserRemoteDataSource with proper parameters
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(
    dioClient: sl(),
    tokenProvider: sl(),
    endpointConfigService: sl(),
  ));
  
  // Register BudMatchingRemoteDataSource with proper parameters
  sl.registerLazySingleton<BudMatchingRemoteDataSource>(() => BudMatchingRemoteDataSourceImpl(
    dioClient: sl(),
    endpointConfigService: sl(),
  ));
  
  // Register UserProfileRepository and its remote data source first
  sl.registerLazySingleton<UserProfileRemoteDataSource>(() => UserProfileRemoteDataSourceImpl(
    dioClient: sl(),
  ));
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Repositories with simplified dependencies
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<BudRepository>(
    () => BudRepositoryImpl(budRemoteDataSource: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(chatRemoteDataSource: sl()),
  );
  sl.registerLazySingleton<CommonItemsRepository>(
    () => CommonItemsRepositoryImpl(remoteDataSource: sl()),
  );
  
  // Register UserRepository using the proper implementation
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImp(remoteDataSource: sl()),
  );
  
  // Now register ContentRepository using the proper implementation
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      remoteDataSource: sl(),
      trackingLocalDataSource: sl(),
    ),
  );
  
  // Register DiscoverRepository using the proper implementation
  sl.registerLazySingleton<DiscoverRepository>(
    () => DiscoverRepositoryImpl(
      userProfileRepository: sl(),
      contentRemoteDataSource: sl(),
    ),
  );
  
  // Register BudMatchingRepository using the proper implementation
  sl.registerLazySingleton<BudMatchingRepository>(
    () => BudMatchingRepositoryImpl(remoteDataSource: sl()),
  );
  
  // Register ServicesRepository using the proper implementation
  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(userRepository: sl()),
  );
  
  // BLoCs - Register as factories so they create new instances each time
  sl.registerFactory(() => AuthBloc(
    authRepository: sl(),
    tokenProvider: sl(),
  ));
  sl.registerFactory(() => LoginBloc(authRepository: sl()));
  sl.registerFactory(() => RegisterBloc(authRepository: sl()));
  sl.registerFactory(() => BudBloc(
    budRepository: sl(),
    commonItemsRepository: sl(),
  ));
  sl.registerFactory(() => UserBloc(userRepository: sl()));
  sl.registerFactory(() => MainScreenBloc(
    profileRepository: sl(),
    contentRepository: sl(),
    discoverRepository: sl(),
  ));
  
  // Register additional BLoCs
  sl.registerFactory(() => DiscoverBloc(repository: sl<DiscoverRepository>()));
  sl.registerFactory(() => LibraryBloc(contentRepository: sl<ContentRepository>()));
  sl.registerFactory(() => BudMatchingBloc(budMatchingRepository: sl<BudMatchingRepository>()));
  sl.registerFactory(() => ComprehensiveChatBloc(
    chatRepository: sl<ChatRepository>(),
    userRepository: sl<UserRepository>(),
    servicesRepository: sl<ServicesRepository>(),
    authRepository: sl<AuthRepository>(),
  ));
  sl.registerFactory(() => SimpleContentBloc());
  sl.registerFactory(() => ContentBloc(contentRepository: sl<ContentRepository>()));
}

