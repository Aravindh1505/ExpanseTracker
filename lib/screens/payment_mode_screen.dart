import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/payment_mode.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class PaymentModeScreen extends StatelessWidget {
  PaymentModeScreen({Key? key}) : super(key: key);

  final List<PaymentMode> paymentModeList = [];

  Future<void> fetchPaymentModes() async {
    paymentModeList.clear();
    List<PaymentMode> list = [];

    var collection = FirebaseFirestore.instance.collection('paymodes').where('is_active', isEqualTo: true);
    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      var documentId = snapshot.id;
      var payId = snapshot.data()['pay_id'] as int;
      var payName = snapshot.data()['pay_name'] as String;
      var sequence = snapshot.data()['sequence'] as int;

      PaymentMode paymentMode = PaymentMode(
        documentId: documentId,
        payId: payId,
        payName: payName,
        sequence: sequence,
        isActive: true,
      );

      list.add(paymentMode);
      list.sort((a, b) {
        return b.sequence.compareTo(a.sequence);
      });
    }

    paymentModeList.addAll(list.reversed);
    Utils.logger(paymentModeList.length.toString());
  }

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
        child: ElevatedButton(
          onPressed: fetchPaymentModes,
          child: const Text('Choose/Add Category'),
        ),
      ),
    );
  }
}
