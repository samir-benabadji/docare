import 'package:docare/core/constants/theme.dart';
import 'package:docare/l10n/l10n.dart';
import 'package:docare/presentation/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      supportedLocales: L10n.all,
      locale: const Locale('nl'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      title: 'DoCare',
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
