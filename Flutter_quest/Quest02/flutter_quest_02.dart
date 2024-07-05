import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Quest 2',
      home: MyHomePage(title: '플러터 앱 만들기'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Text 버튼이 눌렸을 때 동작할 내부 함수
  _print() {
    print('버튼이 눌렸습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(   // Stack 위젯을 활용해 아이콘과 제목을 겹치게 한 뒤 정렬
          children: [
            const Align(
              alignment: Alignment.centerLeft,  // 아이콘은 왼쪽 정렬
              child: Icon(Icons.alarm),
            ),
            Center(   // 제목은 가운데 정렬
              child: Text(widget.title),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(  // 버튼 하단에 바깥 여백을 주기 위해 컨테이너 위젯으로 버튼을 감쌈. 
              margin: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(onPressed: _print, child: const Text('Text')),
            ),
            Stack(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.red,
                ),
                Container(
                  width: 240,
                  height: 240,
                  color: Colors.green,
                ),
                Container(
                  width: 180,
                  height: 180,
                  color: Colors.blue,
                ),
                Container(
                  width: 120,
                  height: 120,
                  color: Colors.orange,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.yellow,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
