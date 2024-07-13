// Flutter Quest04로 제출한 '유튜브 앱 구현하기'를 하단 아이콘 5개 모두 동작하도록 수정한 버전
import 'package:flutter/material.dart';

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Youtube App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class MyRoutePath {
  final int? id;
  final bool isHomePage;
  final bool isShortsPage;
  final bool isAddPage;
  final bool isSubscriptionsPage;
  final bool isProfilePage;
  final bool isVideoDetailsPage;

  // named constructor 방식을 활용해 여러 개의 생성자를 정의해 사용함. 
  MyRoutePath.home()
      : id = null,
        isHomePage = true,
        isShortsPage = false,
        isAddPage = false,
        isSubscriptionsPage = false,
        isProfilePage = false,
        isVideoDetailsPage = false;

  MyRoutePath.shorts()
      : id = null,
        isHomePage = false,
        isShortsPage = true,
        isAddPage = false,
        isSubscriptionsPage = false,
        isProfilePage = false,
        isVideoDetailsPage = false;

  MyRoutePath.add()
      : id = null,
        isHomePage = false,
        isShortsPage = false,
        isAddPage = true,
        isSubscriptionsPage = false,
        isProfilePage = false,
        isVideoDetailsPage = false;

  MyRoutePath.subscriptions()
      : id = null,
        isHomePage = false,
        isShortsPage = false,
        isAddPage = false,
        isSubscriptionsPage = true,
        isProfilePage = false,
        isVideoDetailsPage = false;

  MyRoutePath.profile()
      : id = null,
        isHomePage = false,
        isShortsPage = false,
        isAddPage = false,
        isSubscriptionsPage = false,
        isProfilePage = true,
        isVideoDetailsPage = false;

  MyRoutePath.videoDetails(this.id)
      : isHomePage = false,
        isShortsPage = false,
        isAddPage = false,
        isSubscriptionsPage = false,
        isProfilePage = false,
        isVideoDetailsPage = true;
}

class MyRouteInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    // final uri = Uri.parse(routeInformation.location);
    final uri = routeInformation.uri;
    if (uri.pathSegments.isEmpty) {
      return MyRoutePath.home();
    }
    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'home':
          return MyRoutePath.home();
        case 'shorts':
          return MyRoutePath.shorts();
        case 'add':
          return MyRoutePath.add();
        case 'subscriptions':
          return MyRoutePath.subscriptions();
        case 'profile':
          return MyRoutePath.profile();
      }
    }
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'videos') {
      return MyRoutePath.videoDetails(int.parse(uri.pathSegments[1]));
    }

    // 미리 정의된 경로 유형이 아닌 경우에는 기본값으로 '/feeds' 경로를 사용
    return MyRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(MyRoutePath configuration) {
    if (configuration.isHomePage) {
      // return const RouteInformation(location: '/home');
      return RouteInformation(uri: Uri.parse('/home'));
    }
    if (configuration.isShortsPage) {
      // return const RouteInformation(location: '/shorts');
      return RouteInformation(uri: Uri.parse('/shorts'));
    }
    if (configuration.isAddPage) {
      // return const RouteInformation(location: '/add');
      return RouteInformation(uri: Uri.parse('/add'));
    }
    if (configuration.isSubscriptionsPage) {
      // return const RouteInformation(location: '/subscriptions');
      return RouteInformation(uri: Uri.parse('/subscriptions'));
    }
    if (configuration.isProfilePage) {
      // return const RouteInformation(location: '/profile');
      return RouteInformation(uri: Uri.parse('/profile'));
    }
    if (configuration.isVideoDetailsPage) {
      // return RouteInformation(location: '/videos/${configuration.id}');
      return RouteInformation(uri: Uri.parse('/videos/${configuration.id}'));
    }
    // return const RouteInformation(location: '/feeds');
    return RouteInformation(uri: Uri.parse('/home'));
  }
}

class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRoutePath _currentPath = MyRoutePath.home();

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(MyRoutePath configuration) async {
    _currentPath = configuration;
  }

  @override
  MyRoutePath get currentConfiguration => _currentPath;

  // 이 함수는 아래 HomePage 클래스를 비롯해 다른 스크린 클래스들 내부에서 사용하는 onNavigate 클로저의 내부 함수에 해당. 
  // 즉, 아래 다른 위젯 클래스의 BottomNavigationBar에서 특정 아이콘이 눌려지면, 'onNavigate(MyRoutePath 타입)' 형식으로 호출하는데, 이 때 onNavigate는 클로저인 것이고, 실제로는 내부 함수인 _handlePathChanged 함수가 호출되는 것임. onNavigate의 파라미터로 지정한 MyRoutePath 타입 객체는 _handlePathChanged 내부 함수의 파라미터인 path로 전달됨. 
  // 이 함수는 클로저의 내부 함수이기 때문에 이 함수에서 파라미터로 받아서 변경한 MyRouteDelegate 객체의 내부 멤버 변수인 _currentPath의 최종 변경된 값을 포획해서 유지하고 있게 됨. (클로저의 특징)
  // 이 함수의 주요 역할은 딱 두 가지임!
  // 1. 파리머터로 넘어온 MyRoutePath 타입 객체를 이용해 MyRouteDelegate의 내부 멤버 변수인 _currentPath 변수를 계속 변경함. (결과적으로, 앱의 현재 경로를 이 변수를 통해 계속 유지함)
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
        // [중요] 네비게이션 스택에서는 항상 최소 MyHomePage 하나, 최대로는 MyHomePage와 조건문에 따라 추가되는 페이지까지 해서 총 2개를 유지하게 됨. 
        // 물론, 나중에 ShortsScreen에서도 또 상세 페이지로 넘어가거나 하면 최대 3개가 되도록 구성할 수도 있긴 함. 
        // 하지만, 이런 경우에도 굳이 홈페이지-쇼츠페이지-쇼츠상세페이지 이렇게 3단계로 스택을 관리할 필요 없이, 그냥 홈페이지-쇼츠상세페이지 이렇게 2단계로 계속 스택을 관리하는 방식을 사용할 수도 있음. 
        MaterialPage(
          child: MyHomePage(
            onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
            currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
          ),
        ),
        if (_currentPath.isShortsPage)
          MaterialPage(
            child: ShortsScreen(
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
        if (_currentPath.isAddPage)
          MaterialPage(
            child: AddScreen(
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              // AddScreen에는 하단 네비게이션바가 필요 없음. 
              // currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
        if (_currentPath.isSubscriptionsPage)
          MaterialPage(
            child: SubscriptionsScreen(
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
        if (_currentPath.isProfilePage)
          MaterialPage(
            child: ProfileScreen(
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              currentPath: _currentPath,    // 하단 네비게이션바에서 사용할 앱의 현재 경로 전달
            ),
          ),
        if (_currentPath.isVideoDetailsPage)
          MaterialPage(
            child: VideoDetailScreen(
              id: _currentPath.id!,
              onNavigate: _handlePathChanged,   // 클로저로 사용될 내부 함수 전달
              // VideoDetailScreen에는 하단 네비게이션바가 필요 없음. 
              // currentPath: _currentPath,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (_currentPath.isVideoDetailsPage) {
          _handlePathChanged(MyRoutePath.home());
        }
        return true;
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;
  final MyRoutePath currentPath;

  const MyHomePage({super.key, required this.onNavigate, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [수정] BottomNavigationBar의 아이콘이 눌려질 때 보여줄 스크린을 IndexedStack 위젯을 사용해서 표시하던 방식에서 MyRouteDelegate가 관리하는 네비게이션 스택 방식으로 수정함. 
      // 결론적으로, MyRouteDelegate 클래스의 build() 메소드의 pages 속성에서 if 조건문을 통해 관리하는 방식으로 변경함. 
      // body: IndexedStack(
      //   index: _getCurrentIndex(currentPath),
      //   children: [
      //     HomeScreen(onNavigate: onNavigate),
      //     ShortsScreen(onNavigate: onNavigate),
      //     AddScreen(onNavigate: onNavigate),
      //     SubscriptionsScreen(onNavigate: onNavigate),
      //     ProfileScreen(onNavigate: onNavigate),
      //   ],
      // ),
      body: HomeScreen(onNavigate: onNavigate),
      // BottomNavigationBar 위젯을 다른 스크린 위젯에서도 재사용할 수 있도록 하기 위해 별도의 클래스로 정의함. 
      bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),
    );
  }
}

// BottomNavigationBar 위젯을 재사용하기 위해 별도로 정의한 클래스
// (VS Code의 'Extract Widget' 기능을 통해 자동으로 생성함. 추가로, _getCurrentIndex 함수 역시 이 클래스 내부로 가져왔고, currentPath 파라미터 역시 필요해서 추가해서 완료함)
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
      // 하단 네비게이션바의 개수가 3개 이하까지는 BottomNavigationBar 위젯의 type 속성의 기본값이 'fixed' 모드로 지정되고, 4개 이상일 때는 자동으로 'shifting' 모드로 지정됨. 
      // 참고로, 'shifting' 모드에서는 선택된 항목만 레이블과 아이콘이 표시되고, 나머지 항목은 아이콘만 표시되는 방식임. 
      // 그런데, shifting 모드에서 아이콘 색상과 레이블이 제대로 설정되지 않으면 전체 하단 네비게이션바가 하얀색으로 표시되는 현상이 생김. 
      // [해결책] 
      // 1. 명시적으로 type 속성을 fixed 모드로 지정하면 해결됨. 
      // 2. BottomNavigationBarItem에 명시적으로 backgroundColor 속성을 지정하면 해결됨. 
      type: BottomNavigationBarType.fixed,    // 명시적으로 type을 fixed로 설정
      currentIndex: _getCurrentIndex(currentPath),
      onTap: (index) {
        switch (index) {
          case 0:
            onNavigate(MyRoutePath.home());
            break;
          case 1:
            onNavigate(MyRoutePath.shorts());
            break;
          case 2:
            onNavigate(MyRoutePath.add());
            break;
          case 3:
            onNavigate(MyRoutePath.subscriptions());
            break;
          case 4:
            onNavigate(MyRoutePath.profile());
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'shorts'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: '만들기'),
        BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: '구독'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        // BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'shorts', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.add), label: '만들기', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: '구독', backgroundColor: Colors.blue),
        // BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필', backgroundColor: Colors.blue),
      ],
    );
  }

  int _getCurrentIndex(MyRoutePath path) {
    if (path.isHomePage) return 0;
    if (path.isShortsPage) return 1;
    if (path.isAddPage) return 2;
    if (path.isSubscriptionsPage) return 3;
    if (path.isProfilePage) return 4;
    return 0;
  }
}

class HomeScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Youtube')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('영상 아이템 $index'),
            onTap: () {
              onNavigate(MyRoutePath.videoDetails(index));
            },
          );
        },
      ),
    );
  }
}

class ShortsScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;
  final MyRoutePath currentPath;

  const ShortsScreen({super.key, required this.onNavigate, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shorts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Shorts 화면',
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                onNavigate(MyRoutePath.home());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
      // BottomNavigationBar 위젯을 다른 스크린 위젯에서도 재사용할 수 있도록 하기 위해 별도의 클래스로 정의함. 
      bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),
    );
  }
}

class AddScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;

  const AddScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('만들기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '만들기 화면',
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                onNavigate(MyRoutePath.home());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionsScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;
  final MyRoutePath currentPath;

  const SubscriptionsScreen({super.key, required this.onNavigate, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('구독')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '구독 화면',
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                onNavigate(MyRoutePath.home());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
      // BottomNavigationBar 위젯을 다른 스크린 위젯에서도 재사용할 수 있도록 하기 위해 별도의 클래스로 정의함. 
      bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;
  final MyRoutePath currentPath;

  const ProfileScreen({super.key, required this.onNavigate, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '프로필 화면',
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                onNavigate(MyRoutePath.home());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
      // BottomNavigationBar 위젯을 다른 스크린 위젯에서도 재사용할 수 있도록 하기 위해 별도의 클래스로 정의함. 
      bottomNavigationBar: MyBottomNavBar(onNavigate: onNavigate, currentPath: currentPath),
    );
  }
}

class VideoDetailScreen extends StatelessWidget {
  final int id;
  final ValueChanged<MyRoutePath> onNavigate;

  const VideoDetailScreen({super.key, required this.id, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('영상 상세 $id')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '영상 상세 $id',
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                onNavigate(MyRoutePath.home());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
