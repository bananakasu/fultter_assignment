import 'package:flutter/material.dart';
import 'typing.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('タイピングゲームへようこそ'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TypingApp()),
            );
          },
          child: Text('スタート'),
        ),
      ),
    );
  }
}
