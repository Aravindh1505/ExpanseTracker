

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import '../widgets/custom_widgets.dart';

class AddDataScreen extends StatelessWidget {
  AddDataScreen({Key? key}) : super(key: key);

  TextEditingController textEditingController = TextEditingController();

  void add() {
    Utils.logger('add triggered...');

    String message = textEditingController.text.toString();

    //addMessage(message);
  }

  Future<DocumentReference> addMessage(String message) async {
    return FirebaseFirestore.instance.collection('categories').add(<String, dynamic>{
      'category_id': DateTime.now().millisecondsSinceEpoch,
      'category_name': message,
      'is_active': true,
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data to Firestore'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: 'Enter message here',
                border: OutlineInputBorder(),
              ),
            ),
            CustomSizedBox(),
            ElevatedButton(
              onPressed: add,
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
