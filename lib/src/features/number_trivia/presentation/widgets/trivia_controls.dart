import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_app/src/features/number_trivia/presentation/bloc/bloc/bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final textFieldController = new TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        controller: textFieldController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Input a number',
        ),
        onChanged: (value) {
          inputStr = value;
        },
        onSubmitted: (_) {
          dispatchConcrete();
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text('Search'),
              textTheme: ButtonTextTheme.primary,
              color: Theme.of(context).accentColor,
              onPressed: dispatchConcrete,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: RaisedButton(
              child: Text('Get random trivia'),
              textTheme: ButtonTextTheme.primary,
              onPressed: dispatchRandom,
            ),
          ),
        ],
      ),
    ]);
  }

  void dispatchConcrete() {
    textFieldController.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForConcreteNumberEvent(inputStr));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForRandomNumberEvent());
  }
}
