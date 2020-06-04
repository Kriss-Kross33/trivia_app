import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/src/core/errors/exceptions.dart';
import 'package:trivia_app/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl remoteDataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = new MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setupMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setupMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture('trivia.json'),
      ),
    );
    test('should perform a GET request on a URL with number being the endpoint' + ' and with application/json header', () async {
      //* arrange
      setupMockHttpClientSuccess();
      //* act
      await remoteDataSource.getConcreteNumberTrivia(tNumber);
      //* assert
      final headers = {'Content-Type': 'application/json'};
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: headers));
    });

    test('should return a NumberTriviaModel when the response code is 200', () async {
      //* arrange
      setupMockHttpClientSuccess();
      //* act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
      //* assert
      final headers = {'Content-Type': 'application/json'};
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: headers));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      //* arrange
      setupMockHttpClientFailure();
      //* act
      final call = remoteDataSource.getConcreteNumberTrivia;
      //* assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture('trivia.json'),
      ),
    );
    test('should perform a GET request with random as endpoint and with application/json header', () async {
      //* arrange
      setupMockHttpClientSuccess();
      //* act
      await remoteDataSource.getRandomNumberTrivia();
      //* assert
      final headers = {'Content-Type': 'application/json'};
      verify(mockHttpClient.get('http://numbersapi.com/random', headers: headers));
    });

    test('should return a NumberTriviaModel when the response code is 200', () async {
      //* arrange
      setupMockHttpClientSuccess();
      //* act
      final NumberTriviaModel result = await remoteDataSource.getRandomNumberTrivia();
      //* assert
      final headers = {'Content-Type': 'application/json'};
      verify(mockHttpClient.get('http://numbersapi.com/random', headers: headers));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      //* arrange
      setupMockHttpClientFailure();
      //* act
      final call = remoteDataSource.getRandomNumberTrivia;
      //* assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
