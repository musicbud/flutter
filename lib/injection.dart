import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/network/dio_client.dart';
import 'blocs/main/main_screen_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Network
  sl.registerLazySingleton(() => Dio()); // Base Dio instance
  sl.registerLazySingleton(() => DioClient(
        baseUrl: 'http://127.0.0.1:8000', // Add your actual API base URL here
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
