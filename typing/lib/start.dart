import 'package:flutter/material.dart';
import 'typing.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fultterタイピング'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TypingApp()),
            );
          },
          child: Text('押せば始まる'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // ボタンの背景色
            foregroundColor: Colors.white, // ボタンのテキスト色
            elevation: 4, // 通常のエレベーション
            minimumSize: Size(200, 50), // ボタンの最小サイズ
          ).copyWith(
            elevation: MaterialStateProperty.resolveWith<double>(
              // ボタンが押されたときのエレベーション
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return 16;
                }
                return 4;
              },
            ),
          ),
        ),
      ),
    );
  }
}
