import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/src/core/errors/failures.dart';
import 'package:trivia_app/src/core/usecase/usecase.dart';
import 'package:trivia_app/src/core/utils/input_converter.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/presentation/bloc/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = new MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = new MockGetRandomNumberTrivia();
    mockInputConverter = new MockInputConverter();
    bloc = new NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('InitialState should be empty', () {
    //* assert
    expect(bloc.initialState, equals(EmptyState()));
  });

  group('GetTriviaForConcreteNumberEvent', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = new NumberTrivia(number: tNumberParsed, text: 'test text');

    void setUpMockInputConverterSuccess() => when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));

    test('should call the InputConverter to validate and convert numberString to int', () async {
      //* arrange
      setUpMockInputConverterSuccess();
      //* act
      bloc.dispatch(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //* assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [ErrorState] when the input is invalid', () {
      //* arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
      //* assert later
      final expected = [
        EmptyState(),
        ErrorState(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //* act
      bloc.dispatch(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should get data from the GetConcreteTrivia usecase', () async {
      //* arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //* act
      bloc.dispatch(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //* assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [LoadingState, LoadedState] when the data is gotten successfully', () async {
      //* arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //* assert later
      final expectedStates = <NumberTriviaState>[
        EmptyState(),
        LoadingState(),
        LoadedState(numberTrivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expectedStates));
      //* act
      bloc.dispatch(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [LoadingState, ErrorState] when [ServerFailure] is returned', () async {
      //* arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      //* assert later
      final expectedStates = <NumberTriviaState>[
        EmptyState(),
        LoadingState(),
        ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expectedStates));
      //* act
      bloc.dispatch(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [LoadingState, ErrorState] with appropriate error when getting data fails', () async {
      //* arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      //* assert later
      final expectedStates = <NumberTriviaState>[
        EmptyState(),
        LoadingState(),
        ErrorState(errorMessage: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expectedStates));
      //*act
      bloc.dispatch(GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group('GetTriviaForRandomEvent', () {
    final tNumberTrivia = new NumberTrivia(number: 1, text: 'test text');
    test('should get data from the GetRandomNumberTrivia usecase', () async {
      //* arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //* act
      bloc.dispatch(GetTriviaForRandomNumberEvent());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //* assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [LoadingState, LoadedState] when data is gotten successfully', () async {
      //* arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //* assert later
      final expectedStates = <NumberTriviaState>[
        EmptyState(),
        LoadingState(),
        LoadedState(numberTrivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expectedStates));
      //* act
      bloc.dispatch(GetTriviaForRandomNumberEvent());
    });

    test('should emit [LoadingState, ErrorState] when a [ServerFailure] is returned', () async {
      //* arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      //* assert later
      final expectedStates = <NumberTriviaState>[
        EmptyState(),
        LoadingState(),
        ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expectedStates));
      //* act
      bloc.dispatch(GetTriviaForRandomNumberEvent());
    });

    test('should emit [LoadingState, ErrorState] with appropriate error when fetching data fails', () async {
      //* arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      //* assert later
      final expectedStates = <NumberTriviaState>[
        EmptyState(),
        LoadingState(),
        ErrorState(errorMessage: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expectedStates));
      //* act
      bloc.dispatch(GetTriviaForRandomNumberEvent());
    });
  });
}
