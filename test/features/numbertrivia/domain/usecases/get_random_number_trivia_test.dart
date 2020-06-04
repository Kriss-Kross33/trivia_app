import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/src/core/usecase/usecase.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test text');
  test('should get NumberTrivia from the repository', () async {
    //* arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async => Right(tNumberTrivia));
    //* act
    final result = await usecase(NoParams());
    //* assert
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    expect(result, equals(Right(tNumberTrivia)));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
