import 'package:dartz/dartz.dart';
import 'package:trivia_app/src/core/errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    if (str != null) {
      try {
        int number = int.parse(str);
        if (number < 0) throw FormatException();
        return Right(int.parse(str));
      } on FormatException {
        return Left(InvalidInputFailure());
      }
    } else {
      return Left(InvalidInputFailure());
    }
  }
}
