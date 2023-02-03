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
    categoriesList.clear();
    List<Categories> list = [];

    var collection = FirebaseFirestore.instance.collection('categories').where('is_active', isEqualTo: true);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id;
      var categoryId = snapshot.data()['category_id'] as int;
      var categoryName = snapshot.data()['category_name'] as String;
      var sequence = snapshot.data()['sequence'] as int;

      Categories categories = Categories(
        documentId: documentID,
        categoryId: categoryId,
        categoryName: categoryName,
        sequence: sequence,
        isActive: true,
      );

      list.add(categories);
      list.sort((a, b) {
        return b.sequence.compareTo(a.sequence);
      });
    }

    categoriesList.addAll(list.reversed);
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

