import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../business_logic/models/user_model.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;

  HomePage({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(userModel: userModel),
      builder: (homeController) {
        String greeting = "Welcome";
        switch (userModel.userType) {
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
          appBar: AppBar(
            title: Text(greeting),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  homeController.logout();
                },
              ),
            ],
          ),
          body: Center(child: Text(greeting)),
        );
      },
    );
  }
}
