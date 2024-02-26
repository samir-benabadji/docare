import 'package:docare/core/constants/theme.dart';
import 'package:docare/presentation/pages/onboarding/onboarding_symptoms_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initializing Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: Duration(milliseconds: 300),
      theme: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: DocareTheme.apple,
          primary: DocareTheme.apple,
        ),
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: OnboardingSymptomsPage(), //SplashPage(),
    );
  }
}
