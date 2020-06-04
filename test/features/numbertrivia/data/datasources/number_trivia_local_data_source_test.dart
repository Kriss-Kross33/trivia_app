import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/src/core/errors/exceptions.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl localDataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia_cached.json')),
    );

    test('should return NumberTriviaModel from SharedPreferences when there is one in the cache', () async {
      //* arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));
      //* act
      final result = await localDataSource.getLastNumberTrivia();
      //* assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is no cached value', () async {
      //* arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //* act
      final call = localDataSource.getLastNumberTrivia;
      //* assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumbertrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should call SharedPreferences to cache the data', () {
      //* act
      localDataSource.cacheNumberTrivia(tNumberTriviaModel);
      //* assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
