import 'package:docare/presentation/pages/auth/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _selectedType = 2;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GetBuilder<AuthController>(
          init: AuthController(), // Initialize AuthController
          builder: (authController) => Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Doctor'),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _selectedType,
                      onChanged: (int? value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('User'),
                    leading: Radio<int>(
                      value: 2,
                      groupValue: _selectedType,
                      onChanged: (int? value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                  ),
                  // Your existing sign-up button
                  ElevatedButton(
                    onPressed: () {
                      authController.signUp(emailController.text, passwordController.text, _selectedType);
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => Get.off(() => SignInPage()),
                child: Text("Go to Sign in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
