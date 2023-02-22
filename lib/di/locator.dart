import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/util/input_converter.dart';
// import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_sourc.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/number_trivia/data/datasources/number_trivia_local_data_source copy.dart';
import '../features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final sl = GetIt.instance;

FutureOr<void> init() async {
  // bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

// usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            localDataSource: sl(),
            remoteDataSource: sl(),
            networkInfo: sl(),
          ));

// data sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(hive: sl()));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  // core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InputConverter());

// External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // final hiveInterface = HiveInterface();
  // sl.registerLazySingleton(
  //   () => sharedPreferences,
  // );
  sl.registerLazySingleton(() => HiveInterface);
  // sl.registerLazySingleton<HiveInterface>(() => HiveInterface as HiveInterface);

  sl.registerLazySingleton(() => Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
