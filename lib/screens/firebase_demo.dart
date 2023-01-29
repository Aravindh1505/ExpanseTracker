import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDemoScreen extends StatelessWidget {
  const FirebaseDemoScreen({Key? key}) : super(key: key);

  Future<DocumentReference> addMessageToGuestBook(String message) async {
    return FirebaseFirestore.instance.collection('guestbook').add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now(),
      'name': 'Aravindh Samidurai',
      'userId': DateTime.now().millisecondsSinceEpoch,
      'platform': Platform.isAndroid ? 'Android' : 'iOS'
    });
  }

  Future<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> getMessages() async {
    return FirebaseFirestore.instance.collection('guestbook').snapshots().listen((data) {
      //print(data);
      for (final document in data.docs) {
        var name = document.data()['name'] as String;
        var platform = document.data()['platform'] as String;

        print('$name - $platform');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Submit'),
          // onPressed: () => addMessageToGuestBook('Testing purpose'),
          onPressed: () => getMessages(),
        ),
      ),
    );
  }
}
