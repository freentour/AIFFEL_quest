# AIFFEL Campus Code Peer Review Templete
- 코더 : 
- 리뷰어 : 

# PRT(Peer Review Template)
[ ]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
- 문제에서 요구하는 기능이 정상적으로 작동하는지?
  - 퀘스트 문제에서 요구하고 있는 모든 조건에 대해 완벽하게 동작함.
  - 단, AppBar title의 정렬이 iOS 에뮬레이터에서는 기본값이 가운데 정렬인데 반해, 안드로이드 에뮬레이터에서는 기본값이 왼쪽 정렬이어서 에뮬레이터에 따라 다른 정렬 결과가 나타남. 하지만, 이것은 에뮬레이터의 문제이지 코드의 문제라고 볼 수는 없음. 
```Dart
      appBar: AppBar(
	title: const Text(
	  '플러터 앱 만들기',
	  style: TextStyle(
	    color: Colors.white,
	    fontWeight: FontWeight.bold,
	  ),
	),
	backgroundColor: Colors.blue,
	leading: const Icon(
	  Icons.flutter_dash,
	  color: Colors.white,
	  size: 30,
	),
      ),
```
```Dart
      body: Center(
	child: Column(
	  mainAxisAlignment: MainAxisAlignment.center,
	  children: [
	    SizedBox(height: MediaQuery.of(context).size.height * 0.2),    // 텍스트 버튼을 화면 중앙에 배치시키기 위해 추가한 부분
	    GestureDetector(
	      onTap: () => print('버튼이 눌렸습니다.'),
	      child: Container(
		decoration: BoxDecoration(
		  borderRadius: BorderRadius.circular(10),
		  color: Colors.blue,
		),
		width: 100,
		height: 50,
		child: const Center(
		  child: Text(
		    'Text',
		    style: TextStyle(
		      fontWeight: FontWeight.bold,
		      fontSize: 20,
		      color: Colors.white,
		    ),
		  ),
		),
	      ),
	    ),
	    const SizedBox(height: 20),    // 텍스트 버튼과 하단 정사각형 박스 영역의 간격을 위해 추가한 부분
	    Container(
	      width: 300,
	      height: 300,
	      color: Colors.purple,
	      child: Stack(
		children: [
		  Container(width: 240, height: 240, color: Colors.red),
		  Container(width: 180, height: 180, color: Colors.orange),
		  Container(width: 120, height: 120, color: Colors.yellow),
		  Container(width: 60, height: 60, color: Colors.lightGreen),
		],
	      ),
	    ),
	  ],
	),
      ),
```
    
[O]  **2. 핵심적이거나 복잡하고 이해하기 어려운 부분에 작성된 설명을 보고 해당 코드가 잘 이해되었나요?**
- 해당 코드 블럭에 doc string/annotation/markdown이 달려 있는지 확인
- 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
- 주석을 보고 코드 이해가 잘 되었는지 확인
  - 워낙 심플하게 코드가 작성이 되어있어서 별도의 설명이 필요 없을 정도임. 
        
[O]  **3. 에러가 난 부분을 디버깅하여 “문제를 해결한 기록”을 남겼나요? 또는 “새로운 시도 및 추가 실험”을 해봤나요?**
- 문제 원인 및 해결 과정을 잘 기록하였는지 확인
- 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 실험이 기록되어 있는지 확인
  - SizedBox를 사용하지 않은 버전과, SizedBox를 사용한 이후의 버전 두 가지를 비교해 가면서 설명해 주어서 문제를 해결하기 위해 어떤 시도들이 있었는지 잘 이해할 수 있었음.
  - 추가적으로, dart 파일을 두 개로 분리해서 작성한 시도와, 반복되는 위젯을 별도의 클래스로 추출해 재사용하는 방법에 대한 시도까지 다양한 시도를 적용해 보았음을 확인할 수 있었음.
```Dart
import 'package:flutter/material.dart';
import 'package:quest02/my_home_page.dart';    // 별도로 모듈화한 my_home_page.dart 파일을 불러오는 부분

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
```
        
[O]  **4. 회고를 잘 작성했나요?**
- 프로젝트 결과물에 대해 배운점과 아쉬운점, 느낀점 등이 상세히 기록 되어 있나요?
  - 회고 부분에 디바이스 종류와 상관없이 텍스트 버튼을 화면 중앙에 놓기 위한 방법에 대한 고민이 잘 정리되어 있음.
```Dart
/*
회고:
  텍스트 버튼을 화면 중앙으로 놓고 싶은데
  Column 위젯 안에 children으로 텍스트 버튼과 컨테이너 박스 두 개가 있어서
  텍스트 버튼이 정확히 화면의 중앙에 놓기가 어려웠다.
  그래서 Sized박스를 하나 추가해서 텍스트버튼과 컨테이너의 위치를 조금 내려줬다.
  하지만 이런 방법보다는 더 깔끔한 방법이 있을 것 같아서 위젯들을 좀 더 찾아봐야겠다.
 */
```
        
[O]  **5. 코드가 간결하고 효율적인가요?**
- 파이썬 스타일 가이드 (PEP8)를 준수하였는지 확인
- 코드 중복을 최소화하고 범용적으로 사용할 수 있도록 모듈화(함수화) 했는지
  - 3번 질문에 대해 적은 내용처럼 dart 파일을 두 개로 분리해서 작성하였고, 코드에는 드러나있지 않지만 피어 리뷰 과정에서 반복되는 위젯을 별도의 클래스로 추출해 재사용하는 방법에 대해 직접 보여주는 등 모듈화에 대한 시도가 특히 인상적이었음!
```Dart
import 'package:flutter/material.dart';
import 'package:quest02/my_home_page.dart';    // 별도로 모듈화한 my_home_page.dart 파일을 불러오는 부분

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
```


# 참고 링크 및 코드 개선
```

```
