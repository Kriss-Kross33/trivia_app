import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class Failure extends Equatable {
  //* If the subclasses have some properties , they will get passed to
  //* this constructor so that Equatable can perform value comparison.
  Failure([List props = const <dynamic>[]]) : super(props);
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}


class InvalidInputFailure extends Failure{}
