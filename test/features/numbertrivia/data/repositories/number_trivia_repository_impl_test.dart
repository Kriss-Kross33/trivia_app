import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/src/core/errors/exceptions.dart';
import 'package:trivia_app/src/core/errors/failures.dart';
import 'package:trivia_app/src/core/network/network_info.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_app/src/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetWorkInfo mockNetWorkInfo;

  setUp(() {
    mockRemoteDataSource = new MockRemoteDataSource();
    mockLocalDataSource = new MockLocalDataSource();
    mockNetWorkInfo = new MockNetWorkInfo();
    repository = new NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetWorkInfo,
    );
  });

  void runDeviceOnline(Function body) {
    group('device is online', () {
      // This setup only applies to the 'device is online group.
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runDeviceOffline(Function body) {
    group('device is offline', () {
      // This setup only applies to the 'device is online group.
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'Test Text');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () {
      //* arrange
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      //* act
      repository.getConcreteNumberTrivia(tNumber);
      //* assert
      verify(mockNetWorkInfo.isConnected);
    });

    runDeviceOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        //* arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
        //* act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //* assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should throw ServerException when the call to remote data source is not successful', () async {
        //* arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());
        //* act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //* asssert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Left(ServerFailure())));
      });

      test('should cache the remote data when the call to remote data source is successful', () async {
        //* arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
        //* act
        await repository.getConcreteNumberTrivia(tNumber);
        //* assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    runDeviceOffline(() {
      test('should return last locally cached data when cached data is present', () async {
        //* arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTrivia);
        //* act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //* assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheException when no cached data is present', () async {
        //* arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //* act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //* assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
    final tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      //* arrange
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      //* act
      await repository.getRandomNumberTrivia();
      //* assert
      verify(mockNetWorkInfo.isConnected);
    });

    runDeviceOnline(() {
      test('should fetch remote data if the call to remote data source is successful', () async {
        //* arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        //* act
        final result = await repository.getRandomNumberTrivia();
        //* assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should throw ServerException if the call to remote data source is not successful', () async {
        //* arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
        //* act
        final result = await repository.getRandomNumberTrivia();
        //* assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Left(ServerFailure())));
      });

      test('should cache remote data when the call to remote data is successful', () async {
        //* arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        //* act
        await repository.getRandomNumberTrivia();
        //* assert
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        verify(mockRemoteDataSource.getRandomNumberTrivia());
      });
    });

    runDeviceOffline(() {
      test('should get last cached data when cached data is present', () async {
        //* arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        //* act
        final result = await repository.getRandomNumberTrivia();
        //* assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should throw CacheException when there is no cached data present', () async {
        //* arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //* act
        final result = await repository.getRandomNumberTrivia();
        //* assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
