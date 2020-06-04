import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumberEvent(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {}
