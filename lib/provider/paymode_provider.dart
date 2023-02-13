import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';

class PayModeProvider with ChangeNotifier {
  final List _payModeList = [];

  List get list => [..._payModeList];

  Future<void> fetchPayModes() async {
    _payModeList.clear();

    var collection = FirebaseFirestore.instance
        .collection('paymodes')
        .where('is_active', isEqualTo: true)
        .orderBy('sequence', descending: true);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      _payModeList.add({
        "documentId": snapshot.id,
        "payId": snapshot.data()['pay_id'],
        "payName": snapshot.data()['pay_name'],
        "display": snapshot.data()['pay_name'],
        "value": snapshot.data()['pay_name'],
        "sequence": snapshot.data()['sequence']
      });
    }

    Utils.logger('payModeList size ${_payModeList.length}');
    notifyListeners();
  }

  Future<DocumentReference> addPayMode(String name) async {
    const String pattern = 'dd-MM-yyyy hh:mm:ss';
    final String formatted = DateFormat(pattern).format(DateTime.now());
    Utils.logger(formatted);

    return FirebaseFirestore.instance.collection('paymodes').add(<String, dynamic>{
      'pay_id': DateTime.now().millisecondsSinceEpoch,
      'pay_name': name,
      'sequence': 1,
      'is_active': true,
      'timestamp': formatted,
    });
  }
}
