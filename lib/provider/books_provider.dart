import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/book.dart';
import '../screens/base_screen.dart';
import '../utils/firestore_constants.dart';
import '../utils/utils.dart';
import 'categories_provider.dart';
import 'paymode_provider.dart';

class BooksProvider extends ChangeNotifier with BaseScreen {
  final List<Book> _bookList = [];
  bool _isLoading = true;

  List<Book> get bookList => _bookList;

  bool get isLoading => _isLoading;

  Future<void> getBooks() async {
    _bookList.clear();
    _isLoading = true;
    notifyListeners();

    var collection =
        FirebaseFirestore.instance.collection(FirestoreConstants.GETUSERBOOKS()).orderBy('createdAt', descending: true);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      var id = snapshot.id;
      var bookName = snapshot.data()['bookName'] as String;
      Utils.logger('bookName : $bookName');

      Book book = Book(id: id, bookName: bookName);
      _bookList.add(book);
    }

    Utils.logger('book size : ${_bookList.length}');
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBook(String bookName) async {
    FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERBOOKS)
        .add(<String, dynamic>{
      'userId': currentUserId,
      'bookName': bookName,
      'createdAt': DateTime.now().toString(),
      'platform': getPlatform(),
    });

    getBooks();
  }

  void deleteBook(int index) async {
    var documentId = _bookList[index].id;
    FirebaseFirestore.instance.collection(FirestoreConstants.GETUSERBOOKS()).doc(documentId).delete();

    var query = FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERENTRIES)
        .where('bookId', isEqualTo: documentId);

    query.get().then((querySnapshot) {
      for (var snapshot in querySnapshot.docs) {
        snapshot.reference.delete();
      }
    });

    _bookList.removeAt(index);
    notifyListeners();
  }

  void getData(BuildContext context) {
    var payModeProvider = Provider.of<PayModeProvider>(context, listen: false);
    var categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);

    if (categoriesProvider.list.isEmpty) {
      categoriesProvider.getCategories();
      categoriesProvider.getUserCategories();
    }

    if (payModeProvider.list.isEmpty) {
      payModeProvider.getPayModes();
      payModeProvider.getUserPayModes();
    }
  }
}
