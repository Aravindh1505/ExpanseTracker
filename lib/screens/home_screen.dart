import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/firestore_constants.dart';
import '../utils/route_names.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'login_screen.dart';
import '../model/book.dart';
import '../widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _bookController = TextEditingController();

  final List<Book> _bookList = [];
  bool _isLoading = true;

  @override
  void initState() {
    _getBooks();
    super.initState();
  }

  Future<void> _logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<DocumentReference> _addBook() async {
    const String pattern = 'dd-MM-yyyy hh:mm:ss';
    final String formatted = DateFormat(pattern).format(DateTime.now());
    Utils.logger(formatted);

    var userId = FirebaseAuth.instance.currentUser?.uid;
    String bookName = _bookController.text.toString();

    return FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(userId)
        .collection(FirestoreConstants.USERBOOKS)
        .add(<String, dynamic>{
      'userId': userId.toString(),
      'bookName': bookName,
      'createdAt': DateTime.now().toString(),
      'platform': Platform.isAndroid ? 'Android' : 'iOS'
    }).whenComplete(() => _getBooks());

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

    var collection = FirebaseFirestore.instance
        .collection(FirestoreConstants.getUserBooks())
        .orderBy('createdAt', descending: true);

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

  void add(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Column(
            children: [
              const CustomSizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: const [
                    Icon(Icons.close, size: 25.0),
                    CustomSizedBox(
                      height: 0,
                      width: 20,
                    ),
                    Heading('Add New Book'),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CustomSizedBox(),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                        label: Text('Enter book name'),
                      ),
                      controller: _bookController,
                      onSubmitted: (value) => _addBook,
                      maxLength: 25,
                      maxLines: 1,
                    ),
                    const CustomSizedBox(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      onPressed: _addBook,
                      child: const Text(
                        'ADD',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
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
                  ),
                  const Divider()
                ],
              ),
              itemCount: _bookList.length,
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => add(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }
}
