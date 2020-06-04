import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/src/core/errors/failures.dart';
import 'package:trivia_app/src/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = new InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test('should return an integer when the string represents an unsigned integer', () {
      //* arrange
      String str = '123';
      //* act
      final result = inputConverter.stringToUnsignedInteger(str);
      //* assert
      expect(result, equals(Right(123)));
    });

    test('should return an InvalidInputFailure when the string is not an integer', () {
      //* arrange
      final str = 'abc';
      //* act
      final result = inputConverter.stringToUnsignedInteger(str);
      //* assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return an InvaludInputFailure when the string is null', () {
      //* arrange
      final str = null;
      //* act
      final result = inputConverter.stringToUnsignedInteger(str);
      //* assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return an InvalidInputFailure when the string is a negative integer', () {
      //* arrange
      String str = '-123';
      //* act
      final result = inputConverter.stringToUnsignedInteger(str);
      //* assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
