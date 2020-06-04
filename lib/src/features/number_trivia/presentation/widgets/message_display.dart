import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  const MessageDisplay({
    @required this.message,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            this.message,
            style: const TextStyle(fontSize: 25.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
