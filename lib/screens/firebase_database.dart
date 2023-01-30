import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebaseDatabaseTestingScreen extends StatelessWidget {
  const FirebaseDatabaseTestingScreen({Key? key}) : super(key: key);

  //static const URL = 'https://expanse-tracker-9cf44-default-rtdb.firebaseio.com/paymentmode.json';
  static const URL = 'https://expanse-tracker-9cf44.firebaseio.com/paymentmode.json';

  Future<void> hitServer() async {

    try {
      var url = Uri.parse(URL);
      var response = await http.post(
        url,
        body: json.encode(
          [
            {'mode': 'Cash'},
            {'mode': 'Credit Card'},
            {'mode': 'Debit Card'},
            {'mode': 'EMI'},
          ],
        ),
      );

      print(response.statusCode);
      print(response.body);
    } on Exception catch (error) {
      print(error);
    } finally {
      print('finally triggered...');
    }
  }

  Future<void> getData() async {
    var response = await http.get(Uri.parse(URL));

    print(response.statusCode);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Database Testing'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Hit Server'),
          onPressed: hitServer,
        ),
      ),
    );
  }
}
