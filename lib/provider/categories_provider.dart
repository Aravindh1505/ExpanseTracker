import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/categories.dart';
import '../utils/utils.dart';

class CategoriesProvider with ChangeNotifier {
  final List _categoriesList = [];

  List get list => _categoriesList;

  Future<void> fetchCategories() async {
    _categoriesList.clear();

    var collection = FirebaseFirestore.instance
        .collection('categories')
        .where('is_active', isEqualTo: true)
        .orderBy('sequence', descending: true);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      _categoriesList.add({
        "documentId": snapshot.id,
        "categoryId": snapshot.data()['category_id'],
        "display": snapshot.data()['category_name'],
        "value": snapshot.data()['category_name'],
        "sequence": snapshot.data()['sequence']
      });
    }

    Utils.logger('categoriesList size ${_categoriesList.length}');
    notifyListeners();
  }
}
