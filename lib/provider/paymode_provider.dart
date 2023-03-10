import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../model/payment_mode.dart';
import '../screens/base_screen.dart';
import '../utils/constants.dart';
import '../utils/firestore_constants.dart';
import '../utils/utils.dart';

class PayModeProvider with ChangeNotifier, BaseScreen {
  final List<PaymentMode> _payModeList = [];

  List<PaymentMode> get list => [..._payModeList];

  String _selectedPayMode = '';

  String get selectedPayMode => _selectedPayMode;

  List<PaymentMode> get suggestedPayModeList {
    return _payModeList.where((paymode) => paymode.type == Constants.DEFAULT).toList();
  }

  List<PaymentMode> get userPayModeList {
    return _payModeList.where((paymode) => paymode.type == Constants.USER).toList();
  }

  Future<void> getPayModes() async {
    _payModeList.clear();
    List<PaymentMode> list = [];

    var collection = FirebaseFirestore.instance
        .collection('paymodes')
        .where('is_active', isEqualTo: true)
        .orderBy('sequence', descending: true);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      PaymentMode paymentMode = PaymentMode(
        documentId: snapshot.id,
        payId: snapshot.data()['pay_id'],
        payName: snapshot.data()['pay_name'],
        type: Constants.DEFAULT,
        sequence: snapshot.data()['sequence'],
        isActive: true,
      );

      list.add(paymentMode);
    }
    _payModeList.addAll(list);

    Utils.logger('payModeList size ${_payModeList.length}');
  }

  Future<void> addUserPayMode(String name) async {
    const String pattern = 'dd-MM-yyyy hh:mm:ss';
    final String formatted = DateFormat(pattern).format(DateTime.now());
    Utils.logger(formatted);

    int id = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERPAYMENTMODES)
        .add(<String, dynamic>{
      'userId': currentUserId,
      'pay_id': id,
      'pay_name': name,
      'sequence': 0,
      'is_active': true,
      'timestamp': formatted,
      'platform': getPlatform(),
      'createdAt': DateTime.now().toString(),
    });

    var paymentMode = PaymentMode(
      documentId: '',
      payId: id,
      payName: name,
      type: Constants.USER,
      sequence: 0,
      isActive: true,
    );

    _payModeList.add(paymentMode);
    notifyListeners();
  }

  Future<void> getUserPayModes() async {
    List<PaymentMode> list = [];

    var collection = FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERPAYMENTMODES);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      PaymentMode categories = PaymentMode(
        documentId: snapshot.id,
        payId: snapshot.data()['pay_id'],
        payName: snapshot.data()['pay_name'],
        type: Constants.USER,
        sequence: 0,
        isActive: true,
      );

      list.add(categories);
    }
    _payModeList.addAll(list);
  }

  bool isPayModeAvailable(String payMode) {
    bool isFound = false;
    _payModeList.firstWhereOrNull((paymode) {
      isFound = paymode.payName.toUpperCase().trim() == payMode.toUpperCase().trim();
      return isFound;
    });
    return isFound;
  }

  void userSelectedPayMode(String paymode) {
    _selectedPayMode = paymode;
    notifyListeners();
  }
}
