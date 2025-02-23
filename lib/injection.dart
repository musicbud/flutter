import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'data/data_sources/remote/reference/content_remote_data_source.dart';
import 'data/data_sources/remote/reference/bud_remote_data_source.dart';
import 'data/data_sources/remote/reference/content_remote_data_source_impl.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/datasources/user_remote_data_source_impl.dart';
import 'data/repositories/bud_repository_impl.dart';

import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/bud_repository.dart';
import 'domain/repositories/content_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/network/dio_client.dart';
import 'blocs/main/main_screen_bloc.dart';
import 'domain/repositories/user_repository.dart';
import 'data/data_sources/remote/profile_remote_data_source.dart';
import 'package:http/http.dart' show Client;
import 'data/network/dio_client_adapter.dart';
import 'data/providers/token_provider.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Network
  sl.registerLazySingleton(() {
    final dio = Dio();

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
        debugPrint(
            '✅ [${response.statusCode}] Response: ${response.requestOptions.uri}');
        debugPrint('Body: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint(
            '❌ [${error.response?.statusCode}] Error: ${error.requestOptions.uri}');
        debugPrint('Message: ${error.message}');
        if (error.response?.data != null) {
          debugPrint('Body: ${error.response?.data}');
        }
        return handler.next(error);
      },
    ));

    return dio;
  }); // Base Dio instance

  sl.registerLazySingleton(() => DioClient(
        baseUrl: 'http://84.235.170.234',
        dio: sl<Dio>(),
      )); // DioClient

  // Register data sources first
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(sl()),
  );
// Register data sources first
  sl.registerLazySingleton<BudRemoteDataSource>(
    () => BudRemoteDataSourceImpl(dioClient: sl()),
  );

  // Add token provider singleton
  sl.registerLazySingleton(() => TokenProvider());

  sl.registerLazySingleton<Client>(
    () => DioClientAdapter(
      dioClient: sl<DioClient>(),
      tokenProvider: sl<TokenProvider>(),
    ),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(
      client: sl<Client>(),
      baseUrl: 'http://84.235.170.234',
    ),
  );


  // Then register repositories that depend on it
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      remoteDataSource: sl<ContentRemoteDataSource>(),
      dioClient: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dioClient: sl(),
      tokenProvider: sl(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      dioClient: sl(),
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      client: sl(),
      tokenProvider: sl<TokenProvider>(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl<UserRemoteDataSource>()),
  );
  sl.registerLazySingleton<BudRepository>(
    () => BudRepositoryImpl(budRemoteDataSource: sl<BudRemoteDataSource>()),
  );

  // Bloc
  sl.registerFactory(() => MainScreenBloc(
        profileRepository: sl(),
      ));
}
