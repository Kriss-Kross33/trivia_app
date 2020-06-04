import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class EmptyState extends NumberTriviaState {}

class LoadingState extends NumberTriviaState {}

class LoadedState extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  LoadedState({@required this.numberTrivia}) : super([numberTrivia]);
}

class ErrorState extends NumberTriviaState {
  final String errorMessage;

  ErrorState({@required this.errorMessage}) : super([errorMessage]);
}
