import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/DOCARE.svg",
                  fit: BoxFit.cover,
                  color: Colors.white,
                ),
                SizedBox(height: 40),
                FutureBuilder<bool>(
                  future: controller.isUserLoggedIn(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) return CircularProgressIndicator.adaptive();
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
