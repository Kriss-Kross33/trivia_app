import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_app/src/core/errors/exceptions.dart';
import 'package:trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Thtows a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random
  ///
  /// Throws a [ServerException] for all eror codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getTriviaFromURL('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromURL('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromURL(String url) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
