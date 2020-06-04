import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/src/core/network/network_info.dart';
import 'package:trivia_app/src/core/utils/input_converter.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_app/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/presentation/bloc/bloc/bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc

  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      concrete: serviceLocator(),
      random: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  // repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
        localDataSource: serviceLocator(),
        remoteDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
      ));

  // Data Sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serviceLocator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
