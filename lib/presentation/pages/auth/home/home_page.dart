import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../business_logic/models/user_model.dart';
import '../auth_controller.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return StreamBuilder<DocumentSnapshot>(
          stream: homeController.userDataStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Scaffold(
                body: Center(child: Text('No data found')),
              );
            } else {
              UserModel user = UserModel.fromFirestore(snapshot.data!);
              String greeting = "Welcome";
              if (user.userType == 1) {
                greeting = "Welcome, Doctor";
              } else if (user.userType == 2) {
                greeting = "Welcome, User";
              } else if (user.userType == 3) {
                greeting = "Welcome, Admin";
              }
              return Scaffold(
                appBar: AppBar(
                  title: Text(greeting),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        homeController.logout(); // Call logout method
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Text(greeting),
                ),
              );
            }
          },
        );
      },
    );
  }
}
