import 'package:flutter/material.dart'; // FlutterのMaterialデザインパッケージをインポート
import 'dart:convert'; // JSON処理のためのパッケージをインポート
import 'dart:math'; // 乱数生成のためのパッケージをインポート
import 'package:flutter/services.dart' show rootBundle; // アセットファイルを読み込むためのパッケージをインポート
import 'clear.dart'; // clear.dartファイルからClearScreenクラスをインポート

// TypingAppという名前のStatefulWidgetを定義
class TypingApp extends StatefulWidget {
  @override
  _TypingAppState createState() => _TypingAppState();
}

// TypingAppの状態を管理するクラス
class _TypingAppState extends State<TypingApp> {
  List<Map<String, String>> _prompts = []; // JSONから読み込んだプロンプトを格納するリスト
  List<Map<String, String>> _usedPrompts = []; // 使用されたプロンプトを記録するリスト
  String _currentPrompt = ""; // 現在のプロンプトの文字列
  String _currentRubi = ""; // 現在のプロンプトのルビ（ふりがな）
  String _currentImg = ""; // 現在のプロンプトの画像ファイル名
  String _currentInput = ""; // ユーザーが入力した文字列
  int _currentCharIndex = 0; // 現在のプロンプトの何文字目を入力中かを示すインデックス
  int _correctCount = 0; // 正解したプロンプトの数
  TextEditingController _controller = TextEditingController(); // テキストフィールドのコントローラー

  @override
  void initState() {
    super.initState();
    _loadPrompts(); // 初期化時にプロンプトを読み込む
    _controller.addListener(_onTextChanged); // テキストフィールドの変更を監視
  }

  // プロンプトをJSONファイルから読み込む非同期関数
  Future<void> _loadPrompts() async {
    final String response = await rootBundle.loadString('assets/typing_prompts.json'); // JSONファイルを読み込む
    final List<dynamic> data = json.decode(response); // JSONデータをデコード
    setState(() {
      _prompts = data.map<Map<String, String>>((item) => item.cast<String, String>()).toList(); // プロンプトをリストに変換して保存
      _setRandomPrompt(); // ランダムなプロンプトを設定
    });
  }

  // ランダムなプロンプトを設定する関数
  void _setRandomPrompt() {
    if (_usedPrompts.length == _prompts.length) {
      _usedPrompts.clear(); // すべてのプロンプトが使用されたらリセット
    }
    final random = Random(); // 乱数生成器を作成
    Map<String, String> newPrompt;
    do {
      newPrompt = _prompts[random.nextInt(_prompts.length)]; // ランダムにプロンプトを選択
    } while (_usedPrompts.contains(newPrompt)); // すでに使用されたプロンプトでないか確認
    
    setState(() {
      _currentPrompt = newPrompt["Name"]!; // 新しいプロンプトを設定
      _currentRubi = newPrompt["rubi"]!; // 新しいプロンプトのルビを設定
      _currentImg = newPrompt["img"]!; // 新しいプロンプトの画像を設定
      _currentInput = ""; // 現在の入力をリセット
      _currentCharIndex = 0; // インデックスをリセット
      _usedPrompts.add(newPrompt); // 使用されたプロンプトを記録
      _controller.clear(); // テキストフィールドをクリア
    });
  }

  // テキストフィールドの変更を処理する関数
  void _onTextChanged() {
    if (_controller.text.isEmpty) return; // テキストフィールドが空なら何もしない
    String inputChar = _controller.text[_controller.text.length - 1]; // 入力された最新の文字を取得
    if (inputChar == _currentRubi[_currentCharIndex]) { // 現在の入力とルビの文字を比較
      setState(() {
        _currentInput += inputChar; // 入力された文字を現在の入力に追加
        _currentCharIndex++; // インデックスを進める
        _controller.clear(); // テキストフィールドをクリア
      });
      if (_currentCharIndex == _currentRubi.length) { // すべての文字が正しく入力された場合
        _correctCount++; // 正解カウントを増やす
        if (_correctCount >= 5) { // 正解数が5以上ならクリア画面に遷移
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClearScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('正解！')), // 正解メッセージを表示
          );
          _setRandomPrompt(); // 新しいプロンプトを設定
        }
      }
    } else {
      _controller.clear(); // 不正確な入力をクリア
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('俺のタイピングやで～'), // アプリバーのタイトルを設定
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 画面の周囲にパディングを追加
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 子ウィジェットを縦方向の中央に配置
          children: [
            // 画像が設定されている場合に表示
            _currentImg.isNotEmpty
                ? Image.asset(
                    'assets/$_currentImg', // アセット画像のパスを指定
                    width: 500, // 画像の横幅を設定
                    height: 300, // 画像の縦幅を設定
                  )
                : Container(), // 画像が設定されていない場合は空のコンテナを表示
            SizedBox(height: 10), // 間隔を調整
            /*Text(
              _currentRubi, // ルビを表示
              style: TextStyle(fontSize: 20, color: Colors.grey), // ルビのスタイルを設定
            ),*/
            SizedBox(height: 10), // 間隔を調整
            // 現在のプロンプトの表示
            Text(
              _currentPrompt, // プロンプトの文字列を表示
              style: TextStyle(fontSize: 24), // フォントサイズを設定
            ),
            SizedBox(height: 20), // 間隔を調整
            // テキストフィールドの設定
            TextField(
              controller: _controller, // テキストコントローラーを設定
              autofocus: true, // 自動的にフォーカスを当てる
              decoration: InputDecoration(
                border: InputBorder.none, // 入力フィールドのボーダーを無くす
              ),
              style: TextStyle(fontSize: 1, color: Colors.transparent), // フォントサイズを小さく、色を透明に設定
              cursorColor: Colors.transparent, // カーソルを透明に設定
            ),
            SizedBox(height: 20), // 間隔を調整
            // 現在の入力の表示
            Text(
              _currentInput, // 現在の入力を表示
              style: TextStyle(fontSize: 24, color: Colors.green), // フォントサイズと色を設定
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // テキストコントローラーを破棄
    super.dispose();
  }
}
