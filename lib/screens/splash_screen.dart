import 'dart:async';

import 'package:expanse_tracker/screens/login_screen.dart';

import '../screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void navigate(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) =>
            FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const HomeScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () => {navigate(context)});

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/smartphone.png',
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
