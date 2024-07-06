// [수정판] Scaffold 위젯의 body 속성 영역을 먼저 Expanded 위젯으로 분리한 후 각 영역에 텍스트 버튼과 정사각형 영역을 재배치하는 버전.  
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Stack(   // Stack 위젯을 활용해 아이콘과 제목을 겹치게 한 뒤 정렬
            children: [
              Align(
                alignment: Alignment.centerLeft,  // 아이콘은 왼쪽 정렬
                child: Icon(Icons.alarm),
              ),
              Center(   // 제목은 가운데 정렬
                child: Text('플러터 앱 만들기'),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,   // 하단 중앙에 위치하도록 정렬
                  child: ElevatedButton(
                    onPressed: () {
                      print('버튼이 눌렸습니다.');
                    }, 
                    child: const Text('Text'),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: const Alignment(0.0, 0.5),   // 하단 중앙에서 약간 올라오도록 정렬
                  child: Stack(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}