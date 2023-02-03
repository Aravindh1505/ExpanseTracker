import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import '../widgets/custom_widgets.dart';

class AddDataScreen extends StatelessWidget {
  AddDataScreen({Key? key}) : super(key: key);

  TextEditingController textEditingController = TextEditingController();
  TextEditingController sequenceEditingController = TextEditingController();

  void add() {
    //Utils.logger('add triggered...');

    String name = textEditingController.text.toString();
    String sequence = sequenceEditingController.text.toString();

    Utils.logger('$name - $sequence');

    addMessage(name, sequence);
  }

  Future<DocumentReference> addMessage(String name, String sequence) async {
    const String pattern = 'dd-MM-yyyy hh:mm:ss';
    final String formatted = DateFormat(pattern).format(DateTime.now());
    Utils.logger(formatted);

    return FirebaseFirestore.instance.collection('paymodes').add(<String, dynamic>{
      'pay_id': DateTime.now().millisecondsSinceEpoch,
      'pay_name': name,
      'sequence': sequence,
      'is_active': true,
      'timestamp': formatted,
    });

    /*
    * return FirebaseFirestore.instance.collection('paymodes').add(<String, dynamic>{
      'category_id': DateTime.now().millisecondsSinceEpoch,
      'category_name': name,
      'sequence': sequence,
      'is_active': true,
      'timestamp': formatted,
    });
    * */
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
                labelText: 'Enter message',
                border: OutlineInputBorder(),
              ),
            ),
            CustomSizedBox(),
            TextField(
              keyboardType: TextInputType.number,
              controller: sequenceEditingController,
              decoration: const InputDecoration(
                labelText: 'Enter sequence',
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
