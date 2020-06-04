import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  NumberTriviaModel numberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('should be a subclass of NumberTrivia', () {
    //* assert
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the number is an integer', () {
      //* arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //* act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //* assert
      expect(result, equals(numberTriviaModel));
    });

    test('should return a valid model when the number is a double', () {
      //* arrange
      final jsonMap = json.decode(fixture('trivia_double.json'));
      //* act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //* assert
      expect(result, equals(numberTriviaModel));
    });
  });

  group('toJson', () {
    test('should return a JSON Map containing the proper data', () {
      //* act
      final result = numberTriviaModel.toJson();
      //* assert
      final expectedJsonMap = {
        "number": 1,
        "text": "Test Text",
      };
      expect(result, equals(expectedJsonMap));
    });
  });
}
