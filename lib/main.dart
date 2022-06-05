import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:famistory/card/card_page.dart';
import 'package:famistory/info/info_page.dart';
import 'package:famistory/post/post_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (child) {
        return MaterialApp(
          title: 'Famistroy',
          home: const MainPage(),
          routes: {
            '/info': (context) => const InfoPage(),
            '/post': (context) => const PostPage(),
            '/card': (context) => const CardPage(),
          },
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  
  List<Widget> _buildScreens() {
    return [
      const CardPage(),
      const PostPage(),
      const InfoPage(),
    ];
  }
  
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          const AssetImage("assets/images/picture-polaroid.png"),
          size: 42.w,
        ),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          const AssetImage("assets/images/conversation-chat-1-alternate.png"),
          size: 58.w,
        ),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          const AssetImage("assets/images/single-neutral.png"),
          size: 42.w,
        ),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: '/info',
        ),
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarHeight: 86.h,
      confineInSafeArea: true,
      backgroundColor: const Color(0xFFFFD66B),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style14,
    );
  }

}