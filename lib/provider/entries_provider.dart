import '../model/cash_type.dart';
import '../model/expense.dart';
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
  Expense? _expense;

  //UnmodifiableListView<Entries> get list => UnmodifiableListView(_entriesList);

  List<Entries> get list {
    return [..._entriesList.reversed];
  }

  bool get isLoading => _isLoading;

  Expense? get expense => _expense;

  Future<List<Entries>> fetchEntries(Book book) async {
    _entriesList.clear();
    _isLoading = true;
    notifyListeners();

    var collection = FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERENTRIES)
        .where('bookId', isEqualTo: book.id);

    var querySnapshots = await collection.get();

    for (var snapshots in querySnapshots.docs) {
      Entries entries = Entries(
        id: snapshots.id,
        type: snapshots.data()['type'],
        bookId: snapshots.data()['bookId'],
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

    _compareList();
    processExpense();
    notifyListeners();
    return _entriesList;
  }

  Future<void> save(
      Book book, String amount, String remark, String category, String payMode, String selectedDate) async {
    var date = getCurrentDateAndTime();

    Map<String, dynamic> data = {
      'userId': currentUserId,
      'bookId': book.id,
      'bookName': book.bookName,
      'type': book.type.name,
      'amount': amount,
      'remark': remark,
      'category': category,
      'paymentMode': payMode,
      'date': selectedDate,
      'platform': getPlatform(),
      'createdAt': date,
    };

    FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERENTRIES)
        .add(data);

    Entries entries = Entries(
      id: '',
      bookId: book.id,
      type: book.type.name,
      bookName: book.bookName,
      amount: amount,
      remark: remark,
      category: category,
      paymentMode: payMode,
      date: selectedDate,
      createdAt: date,
    );
    //_entriesList[0] = entries;
    _entriesList.add(entries);

    _compareList();
    processExpense();
    notifyListeners();
  }

  void _compareList() {
    _entriesList.sort((a, b) {
      int aDate = DateTime.parse(a.date ?? '').microsecondsSinceEpoch;
      int bDate = DateTime.parse(b.date ?? '').microsecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });
  }

  void processExpense() {
    int cashIn = 0;
    int cashOut = 0;
    int total = 0;

    for (var entries in _entriesList) {
      if (entries.type == CashType.CASH_IN.name) {
        cashIn = cashIn + int.parse(entries.amount);
      }
      if (entries.type == CashType.CASH_OUT.name) {
        cashOut = cashOut + int.parse(entries.amount);
      }

      total = cashIn - cashOut;

      _expense = Expense(cashIn: cashIn, cashOut: cashOut, total: total);
    }

    Utils.logger('cashIn $cashIn | cashOut $cashOut');
  }

  void resetExpense() {
    _expense = Expense(cashIn: 0, cashOut: 0, total: 0);
  }
}
