import 'package:meta/meta.dart';
import 'package:trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  final int number;
  final String text;

  NumberTriviaModel({@required this.number, @required this.text}) : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> parsedJson) {
    return NumberTriviaModel(
      number: (parsedJson["number"] as num).toInt(),
      text: parsedJson["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "number": this.number,
      "text": this.text,
    };
  }
}
