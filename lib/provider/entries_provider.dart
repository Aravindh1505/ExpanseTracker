import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';
import '../model/entries.dart';
import '../utils/firestore_constants.dart';
import '../utils/utils.dart';

class EntriesProvider with ChangeNotifier {
  final List<Entries> _entriesList = [];
  bool _isLoading = true;

  List<Entries> get entries {
    return [..._entriesList];
  }

  bool get isLoading => _isLoading;

  Future<void> fetchEntries(Book book) async {
    _entriesList.clear();
    _isLoading = true;

    var collection =
        FirebaseFirestore.instance.collection(FirestoreConstants.USERENTRIES).doc(book.id).collection(book.bookName);

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
    Utils.logger(_entriesList.length);
    notifyListeners();
  }
}
