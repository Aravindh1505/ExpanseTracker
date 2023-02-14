import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/book.dart';
import '../model/entries.dart';
import '../screens/base_screen.dart';
import '../utils/firestore_constants.dart';
import '../utils/utils.dart';

class EntriesProvider with ChangeNotifier, BaseScreen {
  final List<Entries> _entriesList = [];
  bool _isLoading = true;

  //UnmodifiableListView<Entries> get list => UnmodifiableListView(_entriesList);

  List<Entries> get list {
    return [..._entriesList];
  }

  bool get isLoading => _isLoading;

  Future<List<Entries>> fetchEntries(Book book) async {
    _entriesList.clear();
    _isLoading = true;

    var collection = FirebaseFirestore.instance
        .collection(FirestoreConstants.USERENTRIES)
        .doc(book.id)
        .collection(book.bookName)
        .orderBy('createdAt', descending: true);

    var querySnapshots = await collection.get();

    for (var snapshots in querySnapshots.docs) {
      Entries entries = Entries(
        id: snapshots.id,
        type: snapshots.data()['type'],
        bookName: snapshots.data()['bookName'],
        amount: snapshots.data()['amount'],
        remark: snapshots.data()['remark'],
        category: snapshots.data()['category'],
        paymentMode: snapshots.data()['paymentMode'],
        date: snapshots.data()['date'],
        createdAt: snapshots.data()['createdAt'],
      );
      _entriesList.add(entries);
    }

    _isLoading = false;
    Utils.logger('entries length : ${_entriesList.length}');
    notifyListeners();
    return _entriesList;
  }

  Future<void> save(Book book, String amount, String remark, String category, String payMode) async {
    Map<String, dynamic> data = {
      'userId': currentUserId,
      'bookName': book.bookName,
      'type': book.type.name,
      'amount': amount,
      'remark': remark,
      'category': category,
      'paymentMode': payMode,
      'date': getCurrentDateAndTime(),
      'platform': getPlatform(),
      'createdAt': getCurrentDateAndTime(),
    };

    FirebaseFirestore.instance
        .collection(FirestoreConstants.USERENTRIES)
        .doc(book.id)
        .collection(book.bookName)
        .doc()
        .set(data);

    _entriesList.clear();
    fetchEntries(book);
  }
}
