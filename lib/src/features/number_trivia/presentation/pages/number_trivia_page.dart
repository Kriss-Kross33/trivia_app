import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_app/injection_container.dart';
import 'package:trivia_app/src/features/number_trivia/presentation/bloc/bloc/bloc.dart';
import 'package:trivia_app/src/features/number_trivia/presentation/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              // Top Half of the screen

              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is EmptyState) {
                    return MessageDisplay(
                      message: 'Start Searching!',
                    );
                  } else if (state is LoadingState) {
                    return LoadingWidget();
                  } else if (state is LoadedState) {
                    return TriviaDisplay(
                      numberTrivia: state.numberTrivia,
                    );
                  } else if (state is ErrorState) {
                    return MessageDisplay(
                      message: state.errorMessage,
                    );
                  } else {
                    return MessageDisplay(
                      message: 'Unknown State',
                    );
                  }
                },
              ),

              SizedBox(height: 20.0),
              // Bottom half
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
