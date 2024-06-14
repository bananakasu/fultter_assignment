import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'clear.dart';

class TypingApp extends StatefulWidget {
  @override
  _TypingAppState createState() => _TypingAppState();
}

class _TypingAppState extends State<TypingApp> {
  List<Map<String, String>> _prompts = [];
  List<Map<String, String>> _usedPrompts = [];  // 使用されたプロンプトを記録するリスト
  String _currentPrompt = "";
  String _currentRubi = ""; // 追加：現在のプロンプトのルビ
  String _currentImg = ""; // 追加：現在のプロンプトの画像
  String _currentInput = "";
  int _currentCharIndex = 0;
  int _correctCount = 0;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrompts();
    _controller.addListener(_onTextChanged);
  }

  Future<void> _loadPrompts() async {
    final String response = await rootBundle.loadString('assets/typing_prompts.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _prompts = data.map<Map<String, String>>((item) => item.cast<String, String>()).toList();
      _setRandomPrompt();
    });
  }

  void _setRandomPrompt() {
    if (_usedPrompts.length == _prompts.length) {
      _usedPrompts.clear();  // すべてのプロンプトが使用されたらリセット
    }
    final random = Random();
    Map<String, String> newPrompt;
    do {
      newPrompt = _prompts[random.nextInt(_prompts.length)];
    } while (_usedPrompts.contains(newPrompt));
    
    setState(() {
      _currentPrompt = newPrompt["Name"]!;
      _currentRubi = newPrompt["rubi"]!; // 追加：ルビを設定
      _currentImg = newPrompt["img"]!; // 追加：画像を設定
      _currentInput = "";
      _currentCharIndex = 0;
      _usedPrompts.add(newPrompt);  // 使用されたプロンプトを追加
      _controller.clear();
    });
  }

  void _onTextChanged() {
    if (_controller.text.isEmpty) return;
    String inputChar = _controller.text[_controller.text.length - 1];
    if (inputChar == _currentRubi[_currentCharIndex]) { // 変更：現在の入力とルビの比較
      setState(() {
        _currentInput += inputChar;
        _currentCharIndex++;
        _controller.clear();  // 次の文字のために入力フィールドをクリア
      });
      if (_currentCharIndex == _currentRubi.length) { // 変更：ルビの長さで判定
        _correctCount++;
        if (_correctCount >= 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClearScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('正解！')),
          );
          _setRandomPrompt();
        }
      }
    } else {
      _controller.clear();  // 不正確な入力をクリア
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('俺のタイピングやで～'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _currentImg.isNotEmpty
                ? Image.asset('assets/$_currentImg') // 画像の表示
                : Container(),
            SizedBox(height: 10), // 間隔を調整
            Text(
              _currentRubi, // ルビの表示
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 10), // 間隔を調整
            Text(
              _currentPrompt,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 1, color: Colors.transparent), // 目立たないように設定
              cursorColor: Colors.transparent, // カーソルを透明に設定
            ),
            SizedBox(height: 20),
            Text(
              _currentInput,
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
