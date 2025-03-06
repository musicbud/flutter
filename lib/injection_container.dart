import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'data/network/dio_client.dart';
import 'data/providers/token_provider.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/bud_repository_impl.dart';
import 'data/datasources/remote/user_remote_data_source.dart';
import 'data/datasources/remote/user_remote_data_source_impl.dart';
import 'data/datasources/remote/profile_remote_data_source.dart';
import 'data/datasources/remote/profile_remote_data_source_impl.dart';
import 'data/datasources/remote/reference/content_remote_data_source.dart';
import 'data/datasources/remote/reference/content_remote_data_source_impl.dart';
import 'data/datasources/remote/reference/bud_remote_data_source.dart';
import 'data/datasources/remote/reference/bud_remote_data_source_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/repositories/content_repository.dart';
import 'domain/repositories/bud_repository.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/services/services_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
// Import other necessary dependencies

final sl = GetIt.instance;

void init() {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => TokenProvider());
  
  // Network
  sl.registerLazySingleton(() => DioClient(
    baseUrl: 'http://84.235.170.234',
    dio: sl<Dio>(),
    tokenProvider: sl<TokenProvider>(),
  ));

  // Data sources
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(sl<DioClient>()),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      client: sl<http.Client>(),
      token: sl<TokenProvider>().token ?? '',
    ),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  sl.registerLazySingleton<BudRemoteDataSource>(
    () => BudRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dioClient: sl<DioClient>(),
      tokenProvider: sl<TokenProvider>(),
    ),
  );

  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      dioClient: sl<DioClient>(),
      remoteDataSource: sl<ContentRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<BudRepository>(
    () => BudRepositoryImpl(
      budRemoteDataSource: sl<BudRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserRemoteDataSource>(),
    ),
  );

  // Add ProfileRepository registration
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      dioClient: sl<DioClient>(),
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  // Blocs
  sl.registerFactory(() => UserBloc(
    userRepository: sl<UserRepository>(),
  ));

  sl.registerFactory(() => AuthBloc(
    authRepository: sl<AuthRepository>(),
  ));

  sl.registerFactory(() => ServicesBloc(
    authRepository: sl<AuthRepository>(),
  ));

  // Add ProfileBloc registration
  sl.registerFactory(() => ProfileBloc(
    profileRepository: sl<ProfileRepository>(),
    contentRepository: sl<ContentRepository>(),
    budRepository: sl<BudRepository>(),
  ));

  // Add other bloc registrations

  // Add other repository registrations

  // Add other data source registrations

  // Add other external dependencies
} 