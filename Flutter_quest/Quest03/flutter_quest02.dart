import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : CatScreen(),
    );
  }
}

class CatScreen extends StatelessWidget {
  bool is_cat = true;
  
  CatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.cat),
              ],
            ),
            title: const Text('First Page'),
            centerTitle: true,
          ),
          body: Container(
            color: const Color(0xffFFFF99),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        print('First Page에서의 is_cat: $is_cat');
                        is_cat = !is_cat;
                        
                        final result = await Navigator.push(
                          context, 
                          // DogScreen을 호출하면서 is_cat 변수 데이터를 함께 전달
                          MaterialPageRoute(builder: (context) => DogScreen(is_cat))
                        );

                        // pop() 메소드로부터 전달된 result 값을 not 변환해서 다시 is_cat 변수에 저장
                        if (result != null) {
                          is_cat = !result;
                        }
                      },
                      child : const Text('Next')
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.network(
                        'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
            ),
          ),
        )
    );
  }
}

class DogScreen extends StatelessWidget {
  // CatScreen에서 넘어온 데이터 is_cat을 저장하기 위한 내부 멤버 변수
  final bool is_cat;

  const DogScreen(this.is_cat, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.dog),
              ],
            ),
            title: const Text('Second Page'),
            centerTitle: true,
          ),
          body: Container(
            color: const Color(0xffCCFFCC),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print('Second Page에서의 is_cat: $is_cat');
                        // pop 메소드와 함께 is_cat 데이터를 함께 전달
                        Navigator.pop(context, is_cat);
                      },
                      child : const Text('Back')
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.network(
                        'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L25zODIzMC1pbWFnZS5qcGc.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
            ),
          ),
        )
    );
  }
}

/*
[회고]
강대식
- icon과 print를 통한 출력에 대한 부분을 간과한 상태로 생각했는데 이 부분에 대해 주현님께서 잡아 주셨습니다. 코드 구현이 복잡하게 되어 가독성이 떨어졌는데 이 부분 역시 주현님께서 간결하게 정리하셨고 설명도 해 주셔서 이해에 많은 도움이 되었습니다.  많은 것을 배울 수 있었던 시간이었습니다.

김주현
- [Image.network](http://Image.network) 위젯을 활용해 인터넷에 있는 이미지 파일의 URL 주소를 쉽게 복사해 와 사용할 수 있어서 assets을 사용하는 방식보다 훨씬 편리했습니다.
- pop 메소드에서 전달한 데이터를 final result로 받아서 처리하는 방식을 사용해서 퀘스트의 요구사항을 완료할 수 있었습니다.
*/
