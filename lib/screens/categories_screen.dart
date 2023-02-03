import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/categories.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  final List<Categories> categoriesList = [];

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

      Categories categories = Categories(
        documentId: documentID,
        payId: payId,
        payName: payName,
        sequence: sequence,
        isActive: isActive,
      );

      categoriesList.add(categories);
      //Utils.logger('$documentID - $payName - $sequence');
    }

    Utils.logger(categoriesList.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_CATEGORY),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: fetchCategories,
          child: const Text('Fetch Categories'),
        ),
      ),
    );
  }
}
