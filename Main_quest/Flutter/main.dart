// 사진을 등록하면 해당 사진이 어떤 사진이고 정확도는 얼마인지 예측해주는 갤러리 앱 만들기
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;   // 애셋 이미지 파일을 FastAPI 서버로 업로드할 때 asUint8List 메소드가 필요해서 추가
import 'dart:typed_data';   // 애셋 이미지 파일을 FastAPI 서버로 업로드할 때 asUint8List 메소드가 필요해서 추가
import 'package:permission_handler/permission_handler.dart';    // 권한 허용 때문에 추가했는데 아직 원하는 결과를 얻지 못함. 
// [추가] 카메라로 찍은 이미지를 갤러리에 저장하기 위해 필요한 패키지
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // MyAppState 객체에서 현재 앱의 상태를 관리함. 
  // 이 객체에서 MyRouterDelegate 객체와 MyRouteInformationParser 객체를 멤버 변수로 저장하고 있음.
  // 결과적으로 매번 화면이 전환될 때마다 MyRouteInformationParser의 restoreRouteInformation() 메소드에 의해 앱의 현재 경로 정보 역시 상태값으로 저장하고 있게 됨! 
  final MyRouterDelegate _routerDelegate = MyRouterDelegate();
  final MyRouteInformationParser _routeInformationParser = MyRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    // seed용 메인 컬러
    const Color primaryColor = Color(0xFFF3F3F3);
    // const Color primaryColor = Colors.blue;
    // 자주 사용하는 컬러
    const Color textColor = Color(0xFFF3F3F3);
    const Color textLightColor = Color(0xFFAEAEAE);
    const Color iconColor = Color(0xFFF3F3F3);
    const Color buttonBackgroundColor = Color(0xFF272727);

    // ButtonStyle을 재사용하기 위해 미리 지정
    final ButtonStyle buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(textLightColor),
      backgroundColor: WidgetStateProperty.all(buttonBackgroundColor),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,    // DEBUG 배너 표시 없애기
      title: '동화책 읽어줘!',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      // 라이트 모드 테마 설정
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Material 3 사용을 명시
      ),
      // 다크 모드 테마 설정
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true, // Material 3 사용을 명시
        // iconTheme: const IconThemeData(
        //   color: iconColor,
        // ),
        // buttonTheme: const ButtonThemeData(
        //   textTheme: ButtonTextTheme.normal,
        //   buttonColor: buttonBackgroundColor,
        // ),
        // textButtonTheme: TextButtonThemeData(
        //   style: buttonStyle,
        // ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: buttonStyle,
        // ),
        // floatingActionButtonTheme: const FloatingActionButtonThemeData(
        //   foregroundColor: textLightColor,
        //   backgroundColor: buttonBackgroundColor,
        // ),
      ),
      themeMode:ThemeMode.dark,   // 테마 모드는 다크 모드로 고정
    );
  }
}

class MyRoutePath {
  final int? id;
  final bool isGalleryPage;
  // final bool isShortsPage;
  final bool isCameraPage;
  final bool isAssetPage;
  // final bool isProfilePage;
  final bool isImageDetailsPage;
  final bool isAssetImageDetailsPage;

  // 명명된 생성자(Named Constructor) 방식을 활용해 여러 개의 생성자를 정의해 사용함. 
  MyRoutePath.gallery()
      : id = null,
        isGalleryPage = true,
        // isShortsPage = false,
        isCameraPage = false,
        isAssetPage = false,
        // isProfilePage = false,
        isImageDetailsPage = false,
        isAssetImageDetailsPage = false;

  // MyRoutePath.shorts()
  //     : id = null,
  //       isGalleryPage = false,
  //       isShortsPage = true,
  //       isCameraPage = false,
  //       isAssetPage = false,
  //       isProfilePage = false,
  //       isImageDetailsPage = false,
  //       isAssetImageDetailsPage = false;
  
  MyRoutePath.camera()
      : id = null,
        isGalleryPage = false,
        // isShortsPage = false,
        isCameraPage = true,
        isAssetPage = false,
        // isProfilePage = false,
        isImageDetailsPage = false,
        isAssetImageDetailsPage = false;

  MyRoutePath.assets()
      : id = null,
        isGalleryPage = false,
        // isShortsPage = false,
        isCameraPage = false,
        isAssetPage = true,
        // isProfilePage = false,
        isImageDetailsPage = false,
        isAssetImageDetailsPage = false;

  // MyRoutePath.profile()
  //     : id = null,
  //       isGalleryPage = false,
  //       isShortsPage = false,
  //       isCameraPage = false,
  //       isAssetPage = false,
  //       isProfilePage = true,
  //       isImageDetailsPage = false,
  //       isAssetImageDetailsPage = false;
  
  MyRoutePath.imageDetails(this.id)
      : isGalleryPage = false,
        // isShortsPage = false,
        isCameraPage = false,
        isAssetPage = false,
        // isProfilePage = false,
        isImageDetailsPage = true,
        isAssetImageDetailsPage = false;

  MyRoutePath.assetImageDetails(this.id)
      : isGalleryPage = false,
        // isShortsPage = false,
        isCameraPage = false,
        isAssetPage = false,
        // isProfilePage = false,
        isImageDetailsPage = false,
        isAssetImageDetailsPage = true;
}

class MyRouteInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    // final uri = Uri.parse(routeInformation.location);
    final uri = routeInformation.uri;
    if (uri.pathSegments.isEmpty) {
      return MyRoutePath.gallery();
    }
    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'gallery':
          return MyRoutePath.gallery();
        // case 'shorts':
        //   return MyRoutePath.shorts();
        case 'camera':
          return MyRoutePath.camera();
        case 'assets':
          return MyRoutePath.assets();
        // case 'profile':
        //   return MyRoutePath.profile();
      }
    }
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'images') {
      return MyRoutePath.imageDetails(int.parse(uri.pathSegments[1]));
    }
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'assets') {
      return MyRoutePath.assetImageDetails(int.parse(uri.pathSegments[1]));
    }

    // 미리 정의된 경로 유형이 아닌 경우에는 기본값으로 '/gallery' 경로를 사용
    return MyRoutePath.gallery();
  }

  // [중요] 필수로 재정의하지 않아도 되지만, 플러터 내비게이션 시스템에서 앱의 현재 경로 상태를 파악하는데 사용되므로 가급적 재정의해서 사용하는 것을 추천함!
  // 특히, 웹앱을 개발하는 경우, 이 메소드에서 리턴한 RouteInformation 객체 내용이 브라우저의 주소 표시줄에 자동으로 연동되어 반영되므로 더욱 필요한 메소드임!
  @override
  RouteInformation restoreRouteInformation(MyRoutePath configuration) {
    if (configuration.isGalleryPage) {
      // return const RouteInformation(location: '/home');
      return RouteInformation(uri: Uri.parse('/gallery'));
    }
    // if (configuration.isShortsPage) {
    //   // return const RouteInformation(location: '/shorts');
    //   return RouteInformation(uri: Uri.parse('/shorts'));
    // }
    if (configuration.isCameraPage) {
      // return const RouteInformation(location: '/camera');
      return RouteInformation(uri: Uri.parse('/camera'));
    }
    if (configuration.isAssetPage) {
      // return const RouteInformation(location: '/assets');
      return RouteInformation(uri: Uri.parse('/assets'));
    }
    // if (configuration.isProfilePage) {
    //   // return const RouteInformation(location: '/profile');
    //   return RouteInformation(uri: Uri.parse('/profile'));
    // }
    if (configuration.isImageDetailsPage) {
      // return RouteInformation(location: '/images/${configuration.id}');
      return RouteInformation(uri: Uri.parse('/images/${configuration.id}'));
    }
    if (configuration.isAssetImageDetailsPage) {
      // return RouteInformation(location: '/assets/${configuration.id}');
      return RouteInformation(uri: Uri.parse('/assets/${configuration.id}'));
    }

    // 그 외의 경우에는 모두 홈페이지 경로를 기본값으로 사용
    // return const RouteInformation(location: '/gallery');
    return RouteInformation(uri: Uri.parse('/gallery'));
  }
}

class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRoutePath _currentPath = MyRoutePath.gallery();

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(MyRoutePath configuration) async {
    _currentPath = configuration;
  }

  @override
  MyRoutePath get currentConfiguration => _currentPath;

  // 이 함수는 '_'(언더스코어)로 시작하는 private 메소드인데, 실제로는 아래 HomePage 클래스를 비롯해 다른 스크린 클래스들 내부에서 사용하는 onNavigate 클로저의 내부 함수로 동작하도록 구성되어 있음. 
  // 즉, 아래 다른 위젯 클래스의 BottomNavigationBar에서 특정 아이콘이 눌려지면, 'onNavigate(MyRoutePath 타입)' 형식으로 호출하는데, 이 때 onNavigate가 클로저인 것이고, 실제로는 내부 함수인 _handlePathChanged 함수가 호출되는 방식임. 이 때, onNavigate의 파라미터로 지정한 MyRoutePath 타입 객체는 _handlePathChanged 내부 함수의 파라미터인 path로 전달됨. 
  // 이 함수는 클로저의 내부 함수이기 때문에 이 함수에서 파라미터로 받아서 변경한 MyRouteDelegate 객체의 내부 멤버 변수인 _currentPath의 최종 변경된 값을 '포획해서 유지'하고 있게 됨. (클로저의 특징)
  // [정리] 이 함수의 주요 역할은 딱 두 가지임!
  // 1. 파리머터로 넘어온 MyRoutePath 타입 객체를 이용해 MyRouteDelegate의 내부 멤버 변수인 _currentPath 변수를 변경함. (결과적으로, 앱의 현재 경로를 이 변수를 통해 계속 유지함)
  // 2. notifyListeners() 호출
  void _handlePathChanged(MyRoutePath path) {
    _currentPath = path;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // [중요] 네비게이션 스택에는 항상 최소로 GalleryPage 하나만 포함되거나, 최대로는 GalleryPage와 조건문에 따라 추가되는 페이지까지 해서 총 2개만 포함되도록 함. 
        // 물론, 나중에 ShortsScreen 같은 곳에서도 또 상세 페이지로 넘어가거나 하면 최대 3개 이상이 스택에 포함되도록 구성할 수도 있음. 
        // 하지만, 이런 경우에도 굳이 홈페이지-쇼츠페이지-쇼츠상세페이지 이렇게 3단계로 스택을 관리할 필요 없고, 그냥 홈페이지-쇼츠상세페이지 이렇게 2단계로만 스택을 관리하는 방식을 사용할 수도 있음!
        MaterialPage(
          child: GalleryPage(
            onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
            currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
          ),
        ),
        // if (_currentPath.isShortsPage)
        //   MaterialPage(
        //     child: ShortsScreen(
        //       onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
        //       currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
        //     ),
        //   ),
        if (_currentPath.isCameraPage)
          MaterialPage(
            child: CameraScreen(
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              // CameraScreen에는 하단 네비게이션바가 필요 없어서 _currentPath 전달하지 않음.
              // currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
        if (_currentPath.isAssetPage)
          MaterialPage(
            child: AssetsScreen(
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
        // if (_currentPath.isProfilePage)
        //   MaterialPage(
        //     child: ProfileScreen(
        //       onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
        //       currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
        //     ),
        //   ),
        if (_currentPath.isImageDetailsPage)
          MaterialPage(
            child: ImageDetailScreen(
              id: _currentPath.id!,
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              // ImageDetailScreen에는 하단 네비게이션바가 필요 없어서 _currentPath 전달하지 않음. 
              // currentPath: _currentPath,   // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
        if (_currentPath.isAssetImageDetailsPage)
          MaterialPage(
            child: AssetImageDetailScreen(
              id: _currentPath.id!,
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              // ImageDetailScreen에는 하단 네비게이션바가 필요 없어서 _currentPath 전달하지 않음. 
              // currentPath: _currentPath,   // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        // [주의] 하단 내비게이션 버튼이 여러개 있는 경우에는, 이 곳 onPopPage에서도 각 버튼 종류에 따라 조건문으로 _handlePathChanged 메소드를 호출해야 함. 
        // 조건문을 구성하지 않으면 화면 중앙의 'ElevatedButton' 누른 경우 말고, '뒤로 가기' 버튼 누른 경우 화면 전환은 되지만 브라우저 주소창의 주소는 정상적으로 변경되지 않음. 
        // 이유는 Delegate의 _currentPath가 제대로 업데이트되지 않고, notifyListener()도 실행되지 않기 때문임!
        if (_currentPath.isImageDetailsPage) {
          _handlePathChanged(MyRoutePath.gallery());
        }
        if (_currentPath.isCameraPage) {
          _handlePathChanged(MyRoutePath.gallery());
        }
        if (_currentPath.isAssetPage) {
          _handlePathChanged(MyRoutePath.gallery());
        }
        if (_currentPath.isAssetImageDetailsPage) {
          _handlePathChanged(MyRoutePath.assets());
        }
        return true;
      },
    );
  }
}

class GalleryPage extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;
  final MyRoutePath currentPath;

  const GalleryPage({super.key, required this.onNavigate, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar 전체에 대해 패딩을 주기 위해 먼저 PreferredSize 위젯으로 감싸기
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.1),   // 전체 높이
        child: Padding(   // appBar 전체에 대한 패딩 설정
          padding: const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 15, right: 15),
          child: AppBar(
            // title: const Text('Youtube'),
            // leading: Align(
            //   alignment: Alignment.centerLeft,
            //   child: Image.asset(
            //     'assets/logos/youtube.png',
            //   ),
            // ),
            // leadingWidth: 130,  // leadingWidth 지정하지 않으면 기본값인 56으로 고정됨.
            title: const Text('동화책 읽어줘!'),
            // actions: [
            //   IconButton(
            //     icon: Image.asset(
            //       'assets/icons/connect_device.png',
            //       height: 24,
            //     ),
            //     onPressed: () {
          
            //     },
            //   ),
            //   IconButton(
            //     icon: const Icon(
            //       Icons.notifications_outlined,
            //       // size: 30.0,
            //     ),
            //     onPressed: () {
          
            //     },
            //   ),
            //   IconButton(
            //     icon: const Icon(
            //       Icons.search,
            //       // size: 30.0,
            //     ),
            //     onPressed: () {
          
            //     },
            //   ),
            // ],
          ),
        ),
      ),
      // [수정] BottomNavigationBar의 아이콘이 눌려질 때 보여줄 스크린을 IndexedStack 위젯을 사용해서 표시하던 방식에서 MyRouteDelegate가 관리하는 네비게이션 스택 방식으로 수정함. 
      // 결론적으로, MyRouteDelegate 클래스 build() 메소드의 pages 속성에서 if 조건문을 통해 꼭 필요한 페이지만 스택에 포함되도록 하는 방식으로 변경함. 
      // body: IndexedStack(
      //   index: _getCurrentIndex(currentPath),
      //   children: [
      //     GalleryScreen(onNavigate: onNavigate),
      //     ShortsScreen(onNavigate: onNavigate),
      //     CameraScreen(onNavigate: onNavigate),
      //     AssetsScreen(onNavigate: onNavigate),
      //     ProfileScreen(onNavigate: onNavigate),
      //   ],
      // ),
      body: GalleryScreen(onNavigate: onNavigate),
      // [참고] BottomNavigationBar 위젯을 다른 스크린 위젯에서도 필요한 경우 재사용할 수 있도록 하기 위해 MyBottomNavBar 라는 별도의 클래스로 정의함. 
      bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),
    );
  }
}

// BottomNavigationBar 위젯을 재사용하기 위해 별도로 정의한 클래스
// (VS Code의 전구 모양 아이콘 기능 중 'Extract Widget' 기능을 통해 자동으로 생성함) 
// 추가로, _getCurrentIndex 함수 역시 이 클래스 내부로 가져왔고, currentPath 파라미터 역시 필요해서 추가해 코드를 완성함. 
class MyBottomNavBar extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;
  final MyRoutePath currentPath;

  const MyBottomNavBar({
    super.key,
    required this.onNavigate,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // 하단 네비게이션바의 개수가 3개 이하까지는 BottomNavigationBar 위젯의 type 속성의 기본값이 'fixed' 모드로 지정되고, 4개 이상일 때는 자동으로 'shifting' 모드로 지정된다고 함. 
      // 참고로, 'fixed' 모드는 아이콘과 레이블이 무조건 함께 표시되는 방식이고, 'shifting' 모드는 선택된 항목만 아이콘과 레이블이 함께 표시되고, 나머지 항목은 아이콘만 표시되는 방식임. 
      // 그런데, 'shifting' 모드에서 아이콘 색상과 레이블이 제대로 설정되지 않으면 하단 네비게이션바 전체가 하얀색으로 표시되는 현상이 생김. 
      // [해결책] 
      // 1. 명시적으로 type 속성을 fixed 모드로 지정하면 해결됨. 
      // 2. type 속성을 명시적으로 지정하고 싶지 않은 경우에는 BottomNavigationBarItem에 명시적으로 backgroundColor 속성을 지정하면 해결됨. 
      type: BottomNavigationBarType.fixed,    // 명시적으로 type 속성을 fixed로 설정
      currentIndex: _getCurrentIndex(currentPath),
      onTap: (index) {
        switch (index) {
          case 0:
            onNavigate(MyRoutePath.gallery());
            break;
          // case 1:
          //   onNavigate(MyRoutePath.shorts());
          //   break;
          case 1:
            onNavigate(MyRoutePath.camera());
            break;
          case 2:
            onNavigate(MyRoutePath.assets());
            break;
          // case 4:
          //   onNavigate(MyRoutePath.profile());
          //   break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: '갤러리'),
        // BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'shorts'),
        BottomNavigationBarItem(icon: Icon(Icons.camera), label: '카메라'),
        BottomNavigationBarItem(icon: Icon(Icons.folder_open), label: '애셋'),
        // BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        // [참고] 하단 내비게이션바 항목이 4개 이상인데, BottomNavigationBar 위젯의 type 속성을 명시적으로 지정하지 않은 경웅에는 다음 코드처럼 BottomNavigationBarItem에 backgroundColor 속성을 명시적으로 지정해 주어야 함. 
        // BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'shorts', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.add), label: '만들기', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.assets), label: '애셋', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필', backgroundColor: Colors.blue),
      ],
    );
  }

  int _getCurrentIndex(MyRoutePath path) {
    if (path.isGalleryPage) return 0;
    // if (path.isShortsPage) return 1;
    if (path.isCameraPage) return 1;
    if (path.isAssetPage) return 2;
    // if (path.isProfilePage) return 4;
    return 0;   // 기본값으로 홈페이지 반환
  }
}

// 나머지 화면들을 정의합니다 
// (GalleryScreen, ShortsScreen, CameraScreen, AssetsScreen, ProfileScreen, ImageDetailScreen).

// Photo 클래스 정의
class Photo {
  // id 속성을 1씩 증가시켜서 자동으로 할당하기 위해 사용하는 클래스 변수(static으로 선언)
  static int _idCounter = 1;

  final int id;
  final String url;
  String title;

  Photo({required this.url, required this.title}) : id = _idCounter++;

  // _idCounter를 초기값으로 리셋하기 위한 메소드(테스트 목적)
  static void resetIdCounter() {
    _idCounter = 1;
  }
}

// 플러터에서는 꼭 필요한 경우가 아니면 이렇게 global scope에 변수 저장하는 것을 지양해야 한다고 함. 
// 가급적 State 객체 내에서 선언하고 사용하는 것을 추천한다고. 
// 하지만, 일단 여러 위젯에서 접근해야 해 테스트에 용이하도록 global scope에서 선언함. 
// 빈 리스트로 초기화하고, 나중에 카메라로 찍은 이미지가 리스트에 추가되도록 함. 
List<Photo> galleryPhotos = [];

final List<Photo> assetPhotos = [
  Photo(url: 'photos/big.jpeg', title: 'Photo 1'),
  Photo(url: 'photos/food_01.jpg', title: 'Photo 2'),
  Photo(url: 'photos/big.jpeg', title: 'Photo 3'),
  Photo(url: 'photos/food_01.jpg', title: 'Photo 4'),
  Photo(url: 'photos/big.jpeg', title: 'Photo 5'),
  Photo(url: 'photos/food_01.jpg', title: 'Photo 6'),
  Photo(url: 'photos/big.jpeg', title: 'Photo 7'),
  Photo(url: 'photos/food_01.jpg', title: 'Photo 8'),
  Photo(url: 'photos/big.jpeg', title: 'Photo 9'),
  Photo(url: 'photos/food_01.jpg', title: 'Photo 10'),
];

class GalleryScreen extends StatefulWidget {
  final ValueChanged<MyRoutePath> onNavigate;

  const GalleryScreen({super.key, required this.onNavigate});

  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryScreen> {
  // final List<Photo> galleryPhotos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  // 권한 허용하기
  // [미해결] AndroidManifest.xml 파일에도 사용자 권한 내용을 등록해 보았지만 결국 if 조건문 안으로 들어가질 못하는 상황임. (에뮬레이터에서는 어쩔 수 없는건지 다른 해결책이 있는건지 아직은 알 수 없음)
  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      _loadImages();
    } else {
      print("Storage permission denied!");
    }
  }

  // 갤러리에서 이미지 가져와 Photo 클래스로 이루어진 리스트에 추가
  // [미해결] 바로 앞에서 _requestPermission 함수에서 조건문이 적용되어야 호출되기 때문에 아직 사용하지 못하고 있음. 
  Future<void> _loadImages() async {
    print("Loading images from gallery...");
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) {
      print("Gallery is empty!");
    }
    setState(() {
      for (int i = 0; i < images.length; i++) {
        galleryPhotos.add(Photo(url: images[i].path, title: 'Photo ${i + 1}'));
      }
    });
    }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // padding: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),   // horizontal, vertical 사용 가능
      // padding: const EdgeInsets.only(left: 5.0),  // left, right, top, bottom 사용 가능
      itemCount: galleryPhotos.length,
      itemBuilder: (context, index) {
        final photo = galleryPhotos[index];
        // 탭 이벤트를 처리할 수 있도록 GestureDetector 위젯 사용
        return GestureDetector(
          onTap: () {
            widget.onNavigate(MyRoutePath.imageDetails(index));
          },
          child: Card(
            // margin: const EdgeInsets.all(10.0),   // Card 위젯 각각에 대해서도 margin 속성을 지정할 수 있음. 
            child: Column(
              children: [
                // Image.asset(photo.url),
                // [중요] 카메라로 찍은 사진은 Image.asset을 사용해서 읽을 수 없음!
                // 따라서, 아래처럼 Image.file 메소드를 사용해야 함. 
                // [추가] 이미지 파일의 크기가 너무 넘쳐나지 않도록 Expanded 위젯으로 감쌈. 
                Expanded(
                  child: Image.file(
                    File(photo.url),
                    // width: 300,  // 원하는 크기를 설정할 수 있습니다.
                    // height: 300, // 원하는 크기를 설정할 수 있습니다.
                    fit: BoxFit.cover, // 이미지 크기 조절 방식을 설정할 수 있습니다.
                  ),
                ),
                Text(photo.title), 
              ],
            ),
          ),
        );
      },
      scrollDirection: Axis.vertical,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}

// [수정] ShortsScreen은 DropDownButton 위젯 테스트를 위해 StatelessWidget에서 StatefulWidget으로 변경함. 
// class ShortsScreen extends StatefulWidget {
//   final ValueChanged<MyRoutePath> onNavigate;
//   final MyRoutePath currentPath;

//   const ShortsScreen({super.key, required this.onNavigate, required this.currentPath});

//   @override
//   ShortsScreenState createState() => ShortsScreenState();
// }

// class ShortsScreenState extends State<ShortsScreen> {
//   String selectedValue = 'One';   // DropDownButton 초기값

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Shorts')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Shorts 화면',
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // onNavigate(MyRoutePath.gallery());  // 오류 발생 --> 맨 앞에 widget. 붙여줘야 함! 
//                 // [참고] StatefulWidget의 State 클래스에서 자신이 포함된 StatefulWidget 클래스에서 정의된 멤버 변수에 접근하려면 widget 프로퍼티를 사용해야 함. 
//                 // 이 때 widget 프로퍼티는 State 클래스가 포함된 StatefulWidget 클래스의 인스턴스를 의미함. 
//                 widget.onNavigate(MyRoutePath.gallery());
//               },
//               child: const Text('돌아가기'),
//             ),
//             // 테마 테스트용 위젯들
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () {},
//               child: const Text('Text Button'),
//             ),
//             const SizedBox(height: 20),
//             OutlinedButton(
//               onPressed: () {},
//               child: const Text('Outlined Button'),
//             ),
//             const SizedBox(height: 20),
//             const Icon(Icons.home),
//             const SizedBox(height: 20),
//             IconButton(
//               onPressed: () {}, 
//               icon: const Icon(Icons.home),
//             ),
//             const SizedBox(height: 20),
//             DropdownButton<String>(
//               value: selectedValue,
//               items: <String>['One', 'Two', 'Three'].map<DropdownMenuItem<String>>(
//                 (String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }
//               ).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedValue = newValue!;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//       // 테마 테스트용 플로팅 액션 버튼
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.add),
//       ),
//       // BottomNavigationBar 위젯을 다른 스크린 위젯에서도 재사용할 수 있도록 하기 위해 별도의 클래스로 정의함. 
//       // bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),   // 오류 발생 --> 맨 앞에 widget. 붙여줘야 함!
//       // [참고] StatefulWidget의 State 클래스에서 자신이 포함된 StatefulWidget 클래스에서 정의된 멤버 변수에 접근하려면 widget 프로퍼티를 사용해야 함. 
//       // 이 때 widget 프로퍼티는 State 클래스가 포함된 StatefulWidget 클래스의 인스턴스를 의미함. 
//       bottomNavigationBar: MyBottomNavBar(onNavigate: widget.onNavigate, currentPath: widget.currentPath),
//     );
//   }
// }

class CameraScreen extends StatefulWidget {
  final ValueChanged<MyRoutePath> onNavigate;

  const CameraScreen({super.key, required this.onNavigate});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  XFile? _image;

  Future getGalleryImage() async {
    // 갤러리에서 이미지 선택하기
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future getCameraImage() async {
    // 카메라로 직접 찍은 이미지 선택하기
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    // [추가] 이미지가 촬영된 후 갤러리에 저장
    if (image != null) {
      print("Camera Image's image.path: ${image.path}");
      await GallerySaver.saveImage(image.path);
      // galleryPhotos 리스트에도 추가
      // 카메라로 찍은 사진이 저장되는 위치는 /data/user/0/com.example.aiffel_gallery/cache/
      galleryPhotos.add(Photo(url: image.path, title: 'Photo by Camera'));
    }
    
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카메라')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: getGalleryImage,
              child: const Text('Gallery'),
            ),
            Center(
              child: _image == null
                  ? const Text(
                      'No image selected.',
                      style: TextStyle(color: Colors.white),
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(File(_image!.path)),
                      radius: 100,
                    ),
            ),
            ElevatedButton(
              onPressed: getCameraImage,
              child: const Text('Camera'),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onNavigate(MyRoutePath.gallery());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}

class AssetsScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;
  final MyRoutePath currentPath;

  const AssetsScreen({super.key, required this.onNavigate, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('애셋')),
      body: GridView.builder(
        // padding: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.symmetric(horizontal: 5.0),   // horizontal, vertical 사용 가능
        // padding: const EdgeInsets.only(left: 5.0),  // left, right, top, bottom 사용 가능
        itemCount: assetPhotos.length,
        itemBuilder: (context, index) {
          final photo = assetPhotos[index];
          // 탭 이벤트를 처리할 수 있도록 GestureDetector 위젯 사용
          return GestureDetector(
            onTap: () {
              onNavigate(MyRoutePath.assetImageDetails(index));
            },
            child: Card(
              // margin: const EdgeInsets.all(10.0),   // Card 위젯 각각에 대해서도 margin 속성을 지정할 수 있음. 
              child: Column(
                children: [
                  Image.asset(photo.url),
                  Text(photo.title), 
                ],
              ),
            ),
          );
        },
        scrollDirection: Axis.vertical,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
      // BottomNavigationBar 위젯을 다른 스크린 위젯에서도 재사용할 수 있도록 하기 위해 별도의 클래스로 정의함. 
      bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),
    );
  }
}

// class ProfileScreen extends StatelessWidget {
//   final ValueChanged<MyRoutePath> onNavigate;
//   final MyRoutePath currentPath;

//   const ProfileScreen({super.key, required this.onNavigate, required this.currentPath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('프로필')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               '프로필 화면',
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 onNavigate(MyRoutePath.gallery());
//               },
//               child: const Text('돌아가기'),
//             ),
//           ],
//         ),
//       ),
//       // BottomNavigationBar 위젯을 다른 스크린 위젯에서도 재사용할 수 있도록 하기 위해 별도의 클래스로 정의함. 
//       bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),
//     );
//   }
// }

class ImageDetailScreen extends StatefulWidget {
  final int id;
  final ValueChanged<MyRoutePath> onNavigate;

  const ImageDetailScreen({super.key, required this.id, required this.onNavigate});

  @override
  ImageDetailPageState createState() => ImageDetailPageState();
}

class ImageDetailPageState extends State<ImageDetailScreen> {
  // [중요] 한 번 초기화 후 상태가 변하지 않는 변수들은 모두 StatefulWidet의 멤버 변수로 선언! 
  // 그래서, Widget의 멤버 변수는 모두 final로 선언되어야 하는 것임! 
  // 또한, StatelessWidget이나 StatefulWidget 모두 위젯 자체는 불변(Immutable)임!!
  // StatefulWidget에서도 위젯은 불변이고, State 객체 내에 선언된 멤버 변수들만 값이 변하는 상태를 가지고 State 라이프 사이클에 의해 상태가 관리되는 것임!!!
  // 따라서, State 클래스의 멤버 변수는 모두 값이 변하는 변수만 선언해야 함. 
  // - 사용자 상호 작용에 의해 변하는 데이터 (예: 사용자 입력, 네트워크 요청 결과 등)
  // - 동적으로 업데이트되는 UI 상태 데이터

  // [TODO] 여기에 선언된 것들이 모두 값이 변하는 것들인지 확인할 것!!!
  File? _image;
  late Photo _photo;
  final picker = ImagePicker();
  String result_caption = "";
  String result_story = "";
  bool _isLoading_caption = false;  // 로딩 상태 변수
  bool _isLoading_story = false;  // 로딩 상태 변수

  // State 객체가 생성될 때 최초 한 번만 호출되는 메소드
  @override
  void initState() {
    super.initState();
    _photo = galleryPhotos[widget.id];
    // _image = File(_photo.url);
  }

  // '이미지 선택' 버튼이 눌렸을 때 동작할 콜백 함수
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // '이미지 업로드' 버튼이 눌렸을 때 동작할 콜백 함수
  Future<void> uploadImage(File imageFile) async {
    try {
      setState(() {
        _isLoading_caption = true;  // 로딩중 표시 시작
        }
      );

      final request = http.MultipartRequest(
        'POST',
        // Uri.parse('https://bold-renewed-macaw.ngrok-free.app/predict'),
        Uri.parse('https://bold-renewed-macaw.ngrok-free.app/caption/'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      // Add the secret_key to the request headers
      request.headers.addAll({
        'secret_key': 'p2C9kROdFYHU1U-cZYInCgyk30A2QvDtwvARfRlCFEQ',
      });

      // [참고] MultipartRequest.send() 메소드의 리턴 타입은 http.StreamResponse 타입임. 
      // 이 타입의 객체는 HTTP 응답의 body를 직접 접근할 수 없음. 
      // 대신, http.Response.fromStream 메소드를 사용하면 완전한 응답으로 변환 가능!
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {   // 정상 응답인 경우
        // 한글이 깨지지 않게 UTF-8로 디코딩하여 응답 본문을 처리
        final decodedData = utf8.decode(response.bodyBytes);
        // final data = jsonDecode(response.body);
        final data = jsonDecode(decodedData);
        // 사진의 제목을 자동으로 변경
        // _photo.title = data['caption'];
        // 화면 다시 표시
        setState(() {
          // print("predicted_label: ${data['predicted_label']}");
          // print("predicted_score: ${data['prediction_score']}");
          // result = "종류: ${data['predicted_label']}\n정확도: ${data['prediction_score']}";
          print("caption: ${data['caption']}");
          result_caption = "${data['caption']}";
          _isLoading_caption = false;  // 로딩 완료
        });
      } else {    // 정상 응답이 아닌 경우
        setState(() {
          result_caption = "데이터를 가져오는데 실패했습니다. Status Code: ${response.statusCode}";
          _isLoading_caption = false;  // 로딩 완료
        });
      }
    } catch (e) {
      setState(() {
        result_caption = "예외 발생: $e";
        _isLoading_caption = false;  // 로딩 완료
      });
    }
  }

  // // assets 디렉토리에 저장된 이미지 파일을 서버에 업로드하고 예측 결과를 받기 위한 콜백 함수
  // Future<void> uploadImageFromAssets() async {
  //   try {
  //     // [참고] assets 디렉토리에 저장되어 있는 이미지 파일을 FastAPI 서버로 업로드 하는 경우에는 스마트폰의 갤러리나 내장 디스크의 특정 디렉토리에 있는 파일을 업로드하는 경우와 달리 다음처럼 처리해야 함. 
  //     // 1. 애셋 파일을 ByteData로 로드. 
  //     // 2. ByteData를 바이트 배열로 변환하여 HTTP 요청에 포함.

  //     // Load the image as ByteData
  //     ByteData byteData = await rootBundle.load(_photo.url);
  //     // Convert ByteData to Uint8List
  //     // Uint8List 타입: 부호 없는 8비트 정수 리스트로, 각 요소는 0부터 255까지의 값을 가짐. 이는 바이너리 데이터를 표현하기에 적합함. 
  //     Uint8List imageData = byteData.buffer.asUint8List();

  //     // Create a MultipartRequest
  //     final request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('https://bold-renewed-macaw.ngrok-free.app/predict'),
  //     );
  //     // Add the image file as a MultipartFile
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'file', 
  //         imageData, 
  //         filename: 'image1.jpg'
  //       ));

  //     // [참고] MultipartRequest.send() 메소드의 리턴 타입은 http.StreamResponse 타입임. 
  //     // 이 타입의 객체는 HTTP 응답의 body를 직접 접근할 수 없음. 
  //     // 대신, http.Response.fromStream 메소드를 사용하면 완전한 응답으로 변환 가능!
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode == 200) {   // 정상 응답인 경우
  //       final data = jsonDecode(response.body);
  //       // 화면 다시 표시
  //       setState(() {
  //         print("predicted_label: ${data['predicted_label']}");
  //         print("predicted_score: ${data['prediction_score']}");
  //         result = "종류: ${data['predicted_label']}\n정확도: ${data['prediction_score']}";
  //       });
  //     } else {    // 정상 응답이 아닌 경우
  //       setState(() {
  //         result = "Failed to fetch data. Status Code: ${response.statusCode}";
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       result = "Error: $e";
  //     });
  //   }
  // }

  // 갤러리에 저장된 이미지 파일에 대한 캡션을 주제로 동화 이야기 생성하는 콜백 함수
  Future<void> generateStory(String caption) async {
    try {
      setState(() {
        _isLoading_story = true;  // 로딩중 표시 시작
        }
      );

      final url = Uri.https(
        'bold-renewed-macaw.ngrok-free.app',   // 서버 주소(주의: https:// 제외하고 적어야 함!)
        '/story/',
        {'caption': result_caption},  // 쿼리 파라미터 설정
      );
      // 헤더 설정
      final headers = {
        'Content-Type': 'application/json',
        'secret_key': 'p2C9kROdFYHU1U-cZYInCgyk30A2QvDtwvARfRlCFEQ',
      };

      // GET 요청 보내기
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {   // 정상 응답인 경우
        // final data = jsonDecode(response.body);
        // 한글이 깨지지 않게 UTF-8로 디코딩하여 응답 본문을 처리
        final decodedData = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedData);
        // 화면 다시 표시
        setState(() {
          print("story: ${data['story']}");
          result_story = "${data['story']}";
          _isLoading_story = false;  // 로딩 완료
        });
      } else {    // 정상 응답이 아닌 경우
        setState(() {
          result_story = "데이터를 가져오는데 실패했습니다. Status Code: ${response.statusCode}";
          _isLoading_story = false;  // 로딩 완료
        });
      }
    } catch (e) {
      setState(() {
        result_story = "예외 발생: $e";
        _isLoading_story = false;  // 로딩 완료
      });
    }
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "사진 설명을 먼저 눌러 주세요.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_photo.title)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(_photo.url),
              // 카메라로 찍은 사진은 Image.asset을 사용해서 읽을 수 없음!
              // 따라서, 아래처럼 Image.file 메소드를 사용해야 함. 
              Image.file(
                File(_photo.url),
                // width: 100,  // 원하는 크기를 설정할 수 있습니다.
                // height: 100, // 원하는 크기를 설정할 수 있습니다.
                fit: BoxFit.cover, // 이미지 크기 조절 방식을 설정할 수 있습니다.
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                _photo.title,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    // onPressed: _image == null ? null : () => uploadImage(_image!),
                    // child: const Text('이미지 업로드와 예측'),
                    // onPressed: () => uploadImageFromAssets(),
                    onPressed: () => uploadImage(File(_photo.url)),
                    child: const Text('사진 설명'),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // result_caption이 비어있지 않은 경우에만 스토리 생성
                      if (result_caption != "") {
                        generateStory(result_caption);
                      } else {
                        _showToast();
                      }
                    },
                    // child: const Text('Assets 이미지 업로드와 예측'),
                    child: const Text('동화 이야기'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 결과를 보여주기 위한 텍스트 위젯
              // 로딩 스피너를 표시하기 위해 별도 클래스로 정의해서 재사용
              Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      // 결과를 보여주기 위한 텍스트 위젯
                      // 로딩 스피너를 표시하기 위해 별도 클래스로 정의해서 재사용
                      child: TextWithLoading(
                        result: result_caption, 
                        isLoading: _isLoading_caption,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 결과를 보여주기 위한 텍스트 위젯
                    // 로딩 스피너를 표시하기 위해 별도 클래스로 정의해서 재사용
                    TextWithLoading(
                      result: result_story, 
                      isLoading: _isLoading_story,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssetImageDetailScreen extends StatefulWidget {
  final int id;
  final ValueChanged<MyRoutePath> onNavigate;

  const AssetImageDetailScreen({super.key, required this.id, required this.onNavigate});

  @override
  AssetImageDetailPageState createState() => AssetImageDetailPageState();
}

class AssetImageDetailPageState extends State<AssetImageDetailScreen> {
  late Photo _photo;
  String result_caption = "";
  String result_story = "";
  bool _isLoading_caption = false;  // 로딩 상태 변수
  bool _isLoading_story = false;  // 로딩 상태 변수

  // State 객체가 생성될 때 최초 한 번만 호출되는 메소드
  @override
  void initState() {
    super.initState();
    _photo = assetPhotos[widget.id];
  }

  // assets 디렉토리에 저장된 이미지 파일을 서버에 업로드하고 예측 결과를 받기 위한 콜백 함수
  Future<void> uploadImageFromAssets() async {
    try {
      setState(() {
        _isLoading_caption = true;  // 로딩중 표시 시작
        }
      );

      // [참고] assets 디렉토리에 저장되어 있는 이미지 파일을 FastAPI 서버로 업로드 하는 경우에는 스마트폰의 갤러리나 내장 디스크의 특정 디렉토리에 있는 파일을 업로드하는 경우와 달리 다음처럼 처리해야 함. 
      // 1. 애셋 파일을 ByteData로 로드. 
      // 2. ByteData를 바이트 배열로 변환하여 HTTP 요청에 포함.

      // Load the image as ByteData
      ByteData byteData = await rootBundle.load(_photo.url);
      // Convert ByteData to Uint8List
      // Uint8List 타입: 부호 없는 8비트 정수 리스트로, 각 요소는 0부터 255까지의 값을 가짐. 이는 바이너리 데이터를 표현하기에 적합함. 
      Uint8List imageData = byteData.buffer.asUint8List();

      // Create a MultipartRequest
      final request = http.MultipartRequest(
        'POST',
        // Uri.parse('https://bold-renewed-macaw.ngrok-free.app/predict'),
        Uri.parse('https://bold-renewed-macaw.ngrok-free.app/caption/'),
      );
      // Add the image file as a MultipartFile
      request.files.add(
        http.MultipartFile.fromBytes(
          'file', 
          imageData, 
          filename: 'image1.jpg'
        ));

      // Add the secret_key to the request headers
      request.headers.addAll({
        'secret_key': 'p2C9kROdFYHU1U-cZYInCgyk30A2QvDtwvARfRlCFEQ',
      });

      // [참고] MultipartRequest.send() 메소드의 리턴 타입은 http.StreamResponse 타입임. 
      // 이 타입의 객체는 HTTP 응답의 body를 직접 접근할 수 없음. 
      // 대신, http.Response.fromStream 메소드를 사용하면 완전한 응답으로 변환 가능!
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {   // 정상 응답인 경우
        // final data = jsonDecode(response.body);
        // 한글이 깨지지 않게 UTF-8로 디코딩하여 응답 본문을 처리
        final decodedData = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedData);
        // 사진의 제목을 자동으로 변경
        // _photo.title = data['caption'];
        // 화면 다시 표시
        setState(() {
          // print("predicted_label: ${data['predicted_label']}");
          // print("predicted_score: ${data['prediction_score']}");
          // result = "종류: ${data['predicted_label']}\n정확도: ${data['prediction_score']}";
          print("caption: ${data['caption']}");
          result_caption = "${data['caption']}";
          _isLoading_caption = false;  // 로딩 완료
        });
      } else {    // 정상 응답이 아닌 경우
        setState(() {
          result_caption = "데이터를 가져오는데 실패했습니다. Status Code: ${response.statusCode}";
          _isLoading_caption = false;  // 로딩 완료
        });
      }
    } catch (e) {
      setState(() {
        result_caption = "예외 발생: $e";
        _isLoading_caption = false;  // 로딩 완료
      });
    }
  }

  // assets 디렉토리에 저장된 이미지 파일에 대한 캡션을 주제로 동화 이야기 생성하는 콜백 함수
  Future<void> generateStoryFromAssets(String caption) async {
    try {
      setState(() {
        _isLoading_story = true;  // 로딩중 표시 시작
        }
      );

      final url = Uri.https(
        'bold-renewed-macaw.ngrok-free.app',   // 서버 주소(주의: https:// 제외하고 적어야 함!)
        '/story/',
        {'caption': result_caption},  // 쿼리 파라미터 설정
      );
      // 헤더 설정
      final headers = {
        'Content-Type': 'application/json',
        'secret_key': 'p2C9kROdFYHU1U-cZYInCgyk30A2QvDtwvARfRlCFEQ',
      };

      // GET 요청 보내기
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {   // 정상 응답인 경우
        // final data = jsonDecode(response.body);
        // 한글이 깨지지 않게 UTF-8로 디코딩하여 응답 본문을 처리
        final decodedData = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedData);
        // 화면 다시 표시
        setState(() {
          print("story: ${data['story']}");
          result_story = "${data['story']}";
          _isLoading_story = false;  // 로딩 완료
        });
      } else {    // 정상 응답이 아닌 경우
        setState(() {
          result_story = "데이터를 가져오는데 실패했습니다. Status Code: ${response.statusCode}";
          _isLoading_story = false;  // 로딩 완료
        });
      }
    } catch (e) {
      setState(() {
        result_story = "예외 발생: $e";
        _isLoading_story = false;  // 로딩 완료
      });
    }
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "사진 설명을 먼저 눌러 주세요.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_photo.title)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(_photo.url),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                _photo.title,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => uploadImageFromAssets(),
                    // child: const Text('Assets 이미지 업로드와 예측'),
                    child: const Text('사진 설명'),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // result_caption이 비어있지 않은 경우에만 스토리 생성
                      if (result_caption != "") {
                        generateStoryFromAssets(result_caption);
                      } else {
                        _showToast();
                      }
                    },
                    // child: const Text('Assets 이미지 업로드와 예측'),
                    child: const Text('동화 이야기'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 결과를 보여주기 위한 텍스트 위젯
              // 로딩 스피너를 표시하기 위해 별도 클래스로 정의해서 재사용
              Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      // 결과를 보여주기 위한 텍스트 위젯
                      // 로딩 스피너를 표시하기 위해 별도 클래스로 정의해서 재사용
                      child: TextWithLoading(
                        result: result_caption, 
                        isLoading: _isLoading_caption,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 결과를 보여주기 위한 텍스트 위젯
                    // 로딩 스피너를 표시하기 위해 별도 클래스로 정의해서 재사용
                    TextWithLoading(
                      result: result_story, 
                      isLoading: _isLoading_story,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextWithLoading extends StatelessWidget {
  const TextWithLoading({
    super.key,
    required this.result,
    required this.isLoading,
  });

  final String result;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),  // 로딩 스피너
            SizedBox(height: 20),  // 스피너와 텍스트 사이에 여백 추가
            Text(
              '작업 중...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        )
      : Text(
          result,
          style: const TextStyle(fontSize: 18),
        );
  }
}
