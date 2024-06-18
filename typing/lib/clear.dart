import 'package:flutter/material.dart'; // FlutterのMaterialデザインパッケージをインポート
import 'start.dart'; // start.dartファイルからStartScreenクラスをインポート

// ClearScreenという名前のStatelessWidgetを定義
class ClearScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // アプリバーの設定
      appBar: AppBar(
        title: Text('クリア！'), // アプリバーのタイトルを設定
      ),
      // 画面の本体部分の設定
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 子ウィジェットを縦方向の中央に配置
          children: [
            // テキストウィジェットの設定
            Text(
              '全問クリアだよ!(^^)!', // 表示するテキスト
              style: TextStyle(fontSize: 24), // テキストのスタイルを設定（フォントサイズ24）
              textAlign: TextAlign.center, // テキストを中央揃えに設定
            ),
            SizedBox(height: 20), // 垂直方向に20のスペースを追加
            // ElevatedButtonをRaisedButton風にカスタマイズして設定
            ElevatedButton(
              onPressed: () {
                // ボタンが押されたときの処理を設定
                Navigator.pushAndRemoveUntil(
                  context, // 現在のビルドコンテキストを指定
                  MaterialPageRoute(
                      builder: (context) =>
                          StartScreen()), // StartScreenへのルートを作成
                  (route) => false, // すべての既存のルートを削除して新しいルートに置き換える
                );
              },
              child: const Text('スタート画面に戻れるよ'), // ボタンに表示するテキスト
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
          ],
        ),
      ),
    );
  }
}
