import 'package:flutter/material.dart';
import 'start.dart';

class ClearScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('クリア！'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'おめでとうございます！全ての問題に正解しました！',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                  (route) => false,
                );
              },
              child: Text('スタート画面に戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
