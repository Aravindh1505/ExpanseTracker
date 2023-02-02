import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/route_names.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<Future<DocumentReference<Map<String, dynamic>>>> add() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    var mobileNumber = FirebaseAuth.instance.currentUser?.phoneNumber;

    final data = <String, String>{
      'userId': userId.toString(),
      'bookName': 'January',
      'createdAt': DateTime.now().toString()
    };

    /*return FirebaseFirestore.instance.collection('books').doc(userId).collection('book')
        .set(data).onError((error, stackTrace) {
      Utils.logger(stackTrace.toString());
    });*/

    return FirebaseFirestore.instance.collection('books').doc(userId).collection('userbooks').add(<String, dynamic>{
      'userId': userId.toString(),
      'bookName': 'January',
      'createdAt': DateTime.now().toString(),
      'platform': Platform.isAndroid ? 'Android' : 'iOS'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_HOME),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: Text('Home screen contents available here!'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: add,
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }
}
