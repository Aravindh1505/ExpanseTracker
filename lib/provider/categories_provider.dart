import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import '../model/categories.dart';
import '../utils/firestore_constants.dart';
import '../utils/utils.dart';
import '../screens/base_screen.dart';
import '../utils/constants.dart';

class CategoriesProvider with ChangeNotifier, BaseScreen {
  final List<Categories> _categoriesList = [];

  List<Categories> get list => [..._categoriesList];

  String _selectedCategory = '';

  String get selectedCategory => _selectedCategory;

  List<Categories> get suggestedCategories {
    return _categoriesList.where((categories) => categories.type == Constants.DEFAULT).toList();
  }

  List<Categories> get userCategories {
    return _categoriesList.where((categories) => categories.type == Constants.USER).toList();
  }

  Future<void> getCategories() async {
    _categoriesList.clear();
    List<Categories> list = [];

    var collection = FirebaseFirestore.instance.collection('categories').where('is_active', isEqualTo: true);
    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      Categories categories = Categories(
        documentId: snapshot.id,
        categoryId: snapshot.data()['category_id'],
        categoryName: snapshot.data()['category_name'],
        type: Constants.DEFAULT,
        sequence: snapshot.data()['sequence'],
        isActive: true,
      );

      list.add(categories);
      list.sort((a, b) {
        return b.sequence.compareTo(a.sequence);
      });
    }
    _categoriesList.addAll(list);

    Utils.logger('categoriesList size ${_categoriesList.length}');
  }

  Future<void> addUserCategory(String categoryName) async {
    var categoryId = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERCATEGORY)
        .add(<String, dynamic>{
      'userId': currentUserId,
      'category_id': categoryId,
      'category_name': categoryName,
      'sequence': 0,
      'is_active': true,
      'platform': getPlatform(),
      'createdAt': DateTime.now().toString(),
    });

    var category = Categories(
      documentId: '',
      categoryId: categoryId,
      categoryName: categoryName,
      type: Constants.USER,
      sequence: 0,
      isActive: true,
    );

    _categoriesList.add(category);
    notifyListeners();
  }

  Future<void> getUserCategories() async {
    List<Categories> list = [];

    //var collection = FirebaseFirestore.instance.collection('categories').where('is_active', isEqualTo: true);
    var collection = FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERCATEGORY);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      Categories categories = Categories(
        documentId: snapshot.id,
        categoryId: snapshot.data()['category_id'],
        categoryName: snapshot.data()['category_name'],
        type: Constants.USER,
        sequence: 0,
        isActive: true,
      );

      list.add(categories);
    }

    _categoriesList.addAll(list);
  }

  bool isCategoryAvailable(String categoryName) {
    bool isFound = false;
    _categoriesList.firstWhereOrNull((categories) {
      isFound = categories.categoryName.toUpperCase().trim() == categoryName.toUpperCase().trim();
      return isFound;
    });
    return isFound;
  }

  void userSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
