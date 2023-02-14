import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanse_tracker/provider/paymode_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/bottom_sheet.dart';
import '../provider/categories_provider.dart';
import '../utils/firestore_constants.dart';
import '../utils/route_names.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widgets/custom_floating_button.dart';
import 'login_screen.dart';
import '../model/book.dart';
import '../widgets/custom_widgets.dart';
import '../screens/base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with BaseScreen {
  final TextEditingController _bookController = TextEditingController();

  final List<Book> _bookList = [];
  bool _isLoading = true;

  @override
  void initState() {
    _getBooks();

    Provider.of<PayModeProvider>(context, listen: false).fetchPayModes();
    var categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    categoriesProvider.fetchCategories();
    categoriesProvider.fetchUserCategories();

    super.initState();
  }

  Future<void> _logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    pushAndRemove(context, const LoginScreen());
  }

  void _addBook() async {
    const String pattern = 'dd-MM-yyyy hh:mm:ss';
    final String formatted = DateFormat(pattern).format(DateTime.now());
    Utils.logger(formatted);

    var userId = FirebaseAuth.instance.currentUser?.uid;
    String bookName = _bookController.text.toString();

    FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(userId)
        .collection(FirestoreConstants.USERBOOKS)
        .add(<String, dynamic>{
      'userId': userId.toString(),
      'bookName': bookName,
      'createdAt': DateTime.now().toString(),
      'platform': Platform.isAndroid ? 'Android' : 'iOS'
    }).whenComplete(() => _getBooks());

    Navigator.of(context).pop();

    /*return FirebaseFirestore.instance.collection('books').doc(userId).collection('userCategory').add(<String, dynamic>{
      'userId': userId.toString(),
      'category_id': DateTime.now().millisecondsSinceEpoch,
      'category_name': 'Food',
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
      'createdAt': DateTime.now().toString(),
    });*/

    /*return FirebaseFirestore.instance
        .collection('books')
        .doc(userId)
        .collection('userPaymentModes')
        .add(<String, dynamic>{
      'userId': userId.toString(),
      'pay_id': DateTime.now().millisecondsSinceEpoch,
      'pay_name': 'Food',
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
      'createdAt': DateTime.now().toString(),
    });*/
  }

  //books/m0koHenMq2dkIbjWdnmN0g2AAew1/userbooks
  Future<void> _getBooks() async {
    _bookList.clear();

    setState(() {
      _isLoading = true;
    });

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

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToEntriesScreen(Book book) {
    Utils.logger('_navigateToEntriesScreen triggered ${book.id}');

    Navigator.of(context).pushNamed(RouteNames.ENTRIES_SCREEN, arguments: book);
  }

  void _deleteBook(int index) async {
    var documentId = _bookList[index].id;
    FirebaseFirestore.instance.collection(FirestoreConstants.GETUSERBOOKS()).doc(documentId).delete();

    setState(() {
      _bookList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: Constants.TITLE_HOME, actions: [
        IconButton(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
        )
      ]),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) => Column(
                children: [
                  ListTile(
                    title: Heading(
                      _bookList[index].bookName,
                    ),
                    leading: const Icon(Icons.book),
                    style: ListTileStyle.list,
                    onTap: () => _navigateToEntriesScreen(_bookList[index]),
                    trailing: GestureDetector(
                      onTap: () => _deleteBook(index),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const Divider()
                ],
              ),
              itemCount: _bookList.length,
            ),
      floatingActionButton: CustomFloatingButton(
        label: 'Add New',
        bottomSheet: BottomSheetValues(
          context: context,
          callback: _addBook,
          controller: _bookController,
          heading: 'Add New',
          hint: 'Enter book name',
        ),
      ),
    );
  }
}
