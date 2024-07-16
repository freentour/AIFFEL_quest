import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,    // DEBUG 배너 표시 여부
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String result = "";
  
  // REST API 호출과 JSON 응답 데이터 처리 전용 메소드(비동기)
  Future<void> fetchData(String type) async {
    try {
      final response = await http.get(
        // REST API 주소
        Uri.parse("https://c5cd-222-109-252-183.ngrok-free.app/sample"),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420',
        },
      );
      if (response.statusCode == 200) {   // 정상 응답인 경우
        final data = jsonDecode(response.body);
        // 화면 다시 표시
        setState(() {
          if (type == 'label') {
            print("predicted_label: ${data['predicted_label']}");
            result = "종류: ${data['predicted_label']}";
          } else if (type == 'score') {
            print("prediction_score: ${data['prediction_score']}");
            result = "확률: ${data['prediction_score']}";
          }
        });
      } else {    // 정상 응답이 아닌 경우
        setState(() {
          result = "Failed to fetch data. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/icons/jellyfish.png',
                    // height: 24,
                  ),
                  onPressed: () {
            
                  },
                ),
              ],
            ),
            title: const Text('Jellyfish Classifier'),
            centerTitle: true,
          ),
          body: Container(
            color: const Color(0xFFFFFF99),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.asset(
                        'images/jellyfish.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          // 이 코드처럼 하면 오류 발생함. 콜백을 호출하는 거여서 '() {}' 형식 또는 '() =>' 형식을 사용해야 함. 
                          // onPressed: fetchData('label'),
                          onPressed: () => fetchData('label'),
                          child : const Text('종류')
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          // 이 코드처럼 하면 오류 발생함. 콜백을 호출하는 거여서 '() {}' 형식 또는 '() =>' 형식을 사용해야 함. 
                          // onPressed: fetchData('score'),
                          onPressed: () => fetchData('score'),
                          child : const Text('확률')
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // 결과를 보여주기 위한 텍스트 위젯
                    Text(
                      result,
                      style: const TextStyle(fontSize: 18),
                    ),                  ],
                )
            ),
          ),
        )
    );
  }
}

/*
[회고]
서은재
-  flutter, fastAPI를 둘 다 꼼꼼하게 점검해야겠다는 생각이 들었다. 

김주현
- 학습 템플릿에 있던 코드와 지난 번 고양이, 강아지 전환하는 퀘스트에서 사용했던 코드를 대부분 재사용할 수 있어서 크게 어려움은 없었습니다. 다만, 버튼이 눌리웠을 때 호춣되는 콜백 함수 작성 방식에서 실수가 있어서 오류가 발생했으나 간단히 수정할 수 있었습니다. 
*/
