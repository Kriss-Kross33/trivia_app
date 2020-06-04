import 'package:meta/meta.dart';
import 'package:trivia_app/src/core/errors/exceptions.dart';
import 'package:trivia_app/src/core/network/network_info.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/src/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_app/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomTriviaChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomTriviaChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
