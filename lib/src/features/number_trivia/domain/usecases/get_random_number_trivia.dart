import 'package:dartz/dartz.dart';
import 'package:trivia_app/src/core/errors/failures.dart';
import 'package:trivia_app/src/core/usecase/usecase.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
