import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../business_logic/models/user_model.dart';
import 'package:badges/badges.dart' as badges;
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;

  HomePage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseAuth.instance.currentUser!.reload();
      print('Email verification Status: ' + user.emailVerified.toString());
    }

    WidgetsBinding.instance.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // TODO: can be useful to refresh user's data when he comes back
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        String greeting = "Welcome";
        switch (widget.userModel.userType) {
          case 1:
            greeting = "Welcome, Doctor";
            break;
          case 2:
            greeting = "Welcome, User";
            break;
          case 3:
            greeting = "Welcome, Admin";
            break;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  style: BorderStyle.solid,
                  strokeAlign: BorderSide.strokeAlignInside,
                  color: Color(0xff858D9D).withOpacity(0.25),
                ),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  spreadRadius: 0,
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: homeController.currentIndex,
              // backgroundColor: colorScheme.surface,
              //selectedItemColor: colorScheme.onSurface,
              // unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: homeController.onBottomNavTap,
              items: homeController.socialPages.map(
                (e) {
                  return _bottomNavigationBarItem(e, homeController);
                },
              ).toList(),
            ),
          ),
          body: homeController.currentPage,
        );
      },
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(CustomNavigator customNavigator, HomeController controller) {
    String imagePath = customNavigator.bottomNavIconPath;
    bool increaseSize = customNavigator.increaseSize;

    return BottomNavigationBarItem(
      label: '',
      icon: StreamBuilder(
        stream: customNavigator.stream,
        initialData: 0,
        builder: (context, snapshot) {
          final data = snapshot.data;
          return badges.Badge(
            badgeStyle: badges.BadgeStyle(
              borderSide: BorderSide(
                color: Color(0xffFDFBF9),
                width: 1.7,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              badgeGradient: badges.BadgeGradient.linear(
                colors: [
                  Color(0xffCD285E),
                  Color(0xffD4365E),
                  Color(0xffDA435E),
                ],
              ),
            ),
            showBadge: data != null && data != 0,
            position: badges.BadgePosition.custom(start: 2.5, end: -25, top: 0),
            child: Transform.scale(
              child: Image.asset(
                imagePath,
                height: 30,
                width: 30,
              ),
              scale: !increaseSize ? 1.2 : 1,
            ),
          );
        },
      ),
      activeIcon: StreamBuilder(
        stream: customNavigator.stream,
        initialData: 0,
        builder: (context, snapshot) {
          final data = snapshot.data;
          return badges.Badge(
            badgeStyle: badges.BadgeStyle(
              borderSide: BorderSide(
                color: Color(0xffFDFBF9),
                width: 1.7,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              badgeGradient: badges.BadgeGradient.linear(
                colors: [
                  Color(0xffCD285E),
                  Color(0xffD4365E),
                  Color(0xffDA435E),
                ],
              ),
            ),
            showBadge: data != null && data != 0,
            position: badges.BadgePosition.custom(start: 2.5, end: -25, top: 0),
            child: Transform.scale(
              child: Image.asset(
                imagePath,
                height: 30,
                width: 30,
                color: Color(0xffD32961),
              ),
              scale: !increaseSize ? 1.2 : 1,
            ),
          );
        },
      ),
    );
  }
}
