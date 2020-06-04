import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:trivia_app/src/core/errors/failures.dart';
import 'package:trivia_app/src/core/usecase/usecase.dart';
import 'package:trivia_app/src/core/utils/input_converter.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_app/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => EmptyState();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumberEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield ErrorState(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield LoadingState();
        final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumberEvent) {
      yield LoadingState();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> either) async* {
    yield either.fold(
      (failure) => ErrorState(errorMessage: _mapFailureToMessage(failure)),
      (trivia) => LoadedState(numberTrivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'UnExpected Error';
    }
  }
}
