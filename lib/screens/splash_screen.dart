import 'dart:async';

import 'package:expanse_tracker/screens/login_screen.dart';

import '../screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'base_screen.dart';

class SplashScreen extends StatelessWidget with BaseScreen {
  SplashScreen({Key? key}) : super(key: key);

  void navigate(BuildContext context) {
    pushAndRemove(context, FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(const Duration(seconds: 2), () => {navigate(context)});
    return Scaffold(body: buildBody());
  }

  Center buildBody() {
    return Center(
      child: Image.asset(
        'assets/images/smartphone.png',
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      ),
    );
  }
}
