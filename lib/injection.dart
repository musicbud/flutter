import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/network/dio_client.dart';
import 'blocs/main/main_screen_bloc.dart';

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

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(dioClient: sl()),
  );

  // Bloc
  sl.registerFactory(() => MainScreenBloc(
        profileRepository: sl(),
      ));
}
