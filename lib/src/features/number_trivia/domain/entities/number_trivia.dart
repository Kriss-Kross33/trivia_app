import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NumberTrivia extends Equatable {
  final int number;
  final String text;

  NumberTrivia({
    @required this.number,
    @required this.text,
  }) : super([number, text]);
}
