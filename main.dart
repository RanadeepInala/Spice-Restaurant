import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/splash/splash_screen.dart';

import 'utils/firebase_helper.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // getdata();
  runApp(MaterialApp(
    theme: ThemeData(
      //   brightness: Brightness.light,
      primaryColor: Colors.blue,
      // accentColor: Colors.cyan[600],
    ),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    navigatorKey: navigatorKey,
  ));
}