// MyRoutePath를 활용하는 방식
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
  final bool isFeedsPage;
  final bool isProfilePage;
  // final bool isNotificationsPage;
  final bool isFeedDetailsPage;

  // named constructor 방식을 활용해 여러 개의 생성자를 정의해 사용함. 
  MyRoutePath.feeds()
      : id = null,
        isFeedsPage = true,
        isProfilePage = false,
        // isNotificationsPage = false,
        isFeedDetailsPage = false;

  MyRoutePath.profile()
      : id = null,
        isFeedsPage = false,
        isProfilePage = true,
        // isNotificationsPage = false,
        isFeedDetailsPage = false;

  // MyRoutePath.notifications()
  //     : id = null,
  //       isFeedsPage = false,
  //       isProfilePage = false,
  //       // isNotificationsPage = true,
  //       isFeedDetailsPage = false;

  MyRoutePath.feedDetails(this.id)
      : isFeedsPage = false,
        isProfilePage = false,
        // isNotificationsPage = false,
        isFeedDetailsPage = true;
}

class MyRouteInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    // final uri = Uri.parse(routeInformation.location);
    final uri = routeInformation.uri;
    if (uri.pathSegments.isEmpty) {
      return MyRoutePath.feeds();
    }
    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'feeds':
          return MyRoutePath.feeds();
        case 'profile':
          return MyRoutePath.profile();
        // case 'notifications':
        //   return MyRoutePath.notifications();
      }
    }
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'feeds') {
      return MyRoutePath.feedDetails(int.parse(uri.pathSegments[1]));
    }

    // 미리 정의된 경로 유형이 아닌 경우에는 기본값으로 '/feeds' 경로를 사용
    return MyRoutePath.feeds();
  }

  @override
  RouteInformation restoreRouteInformation(MyRoutePath configuration) {
    if (configuration.isFeedsPage) {
      // return const RouteInformation(location: '/feeds');
      return RouteInformation(uri: Uri.parse('/feeds'));
    }
    if (configuration.isProfilePage) {
      // return const RouteInformation(location: '/profile');
      return RouteInformation(uri: Uri.parse('/profile'));
    }
    // if (configuration.isNotificationsPage) {
    //   // return const RouteInformation(location: '/notifications');
    //   return RouteInformation(uri: Uri.parse('/notifications'));
    // }
    if (configuration.isFeedDetailsPage) {
      // return RouteInformation(location: '/feeds/${configuration.id}');
      return RouteInformation(uri: Uri.parse('/feeds/${configuration.id}'));
    }
    // return const RouteInformation(location: '/feeds');
    return RouteInformation(uri: Uri.parse('/feeds'));
  }
}

class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRoutePath _currentPath = MyRoutePath.feeds();

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(MyRoutePath configuration) async {
    _currentPath = configuration;
  }

  @override
  MyRoutePath get currentConfiguration => _currentPath;

  void _handlePathChanged(MyRoutePath path) {
    _currentPath = path;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: MyHomePage(
            onNavigate: _handlePathChanged,
            currentPath: _currentPath,
          ),
        ),
        if (_currentPath.isFeedDetailsPage)
          MaterialPage(
            child: FeedDetailScreen(
              id: _currentPath.id!,
              onNavigate: _handlePathChanged,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (_currentPath.isFeedDetailsPage) {
          _handlePathChanged(MyRoutePath.feeds());
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
      body: IndexedStack(
        index: _getCurrentIndex(currentPath),
        children: [
          FeedScreen(onNavigate: onNavigate),
          ProfileScreen(onNavigate: onNavigate),
          // const NotificationsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(currentPath),
        onTap: (index) {
          switch (index) {
            case 0:
              onNavigate(MyRoutePath.feeds());
              break;
            case 1:
              onNavigate(MyRoutePath.profile());
              break;
            // case 2:
            //   onNavigate(MyRoutePath.notifications());
            //   break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
          // BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '알림'),
        ],
      ),
    );
  }

  int _getCurrentIndex(MyRoutePath path) {
    if (path.isFeedsPage) return 0;
    if (path.isProfilePage) return 1;
    // if (path.isNotificationsPage) return 2;
    return 0;
  }
}

class FeedScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;

  const FeedScreen({super.key, required this.onNavigate});

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
              onNavigate(MyRoutePath.feedDetails(index));
            },
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final ValueChanged<MyRoutePath> onNavigate;

  const ProfileScreen({super.key, required this.onNavigate});

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
                onNavigate(MyRoutePath.feeds());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}

// class NotificationsScreen extends StatelessWidget {
//   const NotificationsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('알림')),
//       body: const Center(
//         child: Text('알림 화면'),
//       ),
//     );
//   }
// }

class FeedDetailScreen extends StatelessWidget {
  final int id;
  final ValueChanged<MyRoutePath> onNavigate;

  const FeedDetailScreen({super.key, required this.id, required this.onNavigate});

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
                onNavigate(MyRoutePath.feeds());
              },
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
