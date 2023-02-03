import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PaymentModeScreen extends StatelessWidget {
  const PaymentModeScreen({Key? key}) : super(key: key);

  //final List<Categories> paymentModeList = [];

  Future<void> fetchCategories() async {
    var collection = FirebaseFirestore.instance
        .collection('paymodes')
        .where('is_active', isEqualTo: true);

    var querySnapshots = await collection.get();


    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id;
      var payId = snapshot.data()['pay_id'] as int;
      var payName = snapshot.data()['pay_name'] as String;
      var sequence = snapshot.data()['sequence'] as int;
      var isActive = snapshot.data()['is_active'] as bool;


    }

   // Utils.logger(categoriesList.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_PAYMENT_MODE),
      ),
      body: Center(
        child: Text('Choose/Add Category'),
      ),
    );
  }
}
