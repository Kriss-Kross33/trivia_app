import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository;
  GetConcreteNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = new MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: tNumber, text: 'text test');

  test('Should get NumberTrivia for a number from the repository ', () async {
    //* arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
    //* act
    final result = await usecase(Params(number: tNumber));
    //* assert
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    expect(result, equals(Right(tNumberTrivia)));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
