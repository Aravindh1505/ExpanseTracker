import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanse_tracker/widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/route_names.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _bookController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  Future<void> logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<DocumentReference> addBook() async {
    const String pattern = 'dd-MM-yyyy hh:mm:ss';
    final String formatted = DateFormat(pattern).format(DateTime.now());
    Utils.logger(formatted);

    var userId = FirebaseAuth.instance.currentUser?.uid;
    String bookName = _bookController.text.toString();

    /*return FirebaseFirestore.instance.collection('books').doc(userId).collection('userBooks').add(<String, dynamic>{
      'userId': userId.toString(),
      'bookName': bookName,
      'createdAt': DateTime.now().toString(),
      'platform': Platform.isAndroid ? 'Android' : 'iOS'
    });*/

    /*return FirebaseFirestore.instance.collection('books').doc(userId).collection('userCategory').add(<String, dynamic>{
      'userId': userId.toString(),
      'category_id': DateTime.now().millisecondsSinceEpoch,
      'category_name': 'Food',
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
      'createdAt': DateTime.now().toString(),
    });*/

    return FirebaseFirestore.instance
        .collection('books')
        .doc(userId)
        .collection('userPaymentModes')
        .add(<String, dynamic>{
      'userId': userId.toString(),
      'pay_id': DateTime.now().millisecondsSinceEpoch,
      'pay_name': 'Food',
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
      'createdAt': DateTime.now().toString(),
    });
  }

  //books/m0koHenMq2dkIbjWdnmN0g2AAew1/userbooks
  Future<void> getBooks() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;

    var collectionUrl = 'books/$userId/userbooks';

    var collection = FirebaseFirestore.instance.collection(collectionUrl);

    var querySnapshots = await collection.get();

    for (var snapshot in querySnapshots.docs) {
      var bookName = snapshot.data()['bookName'] as String;
      Utils.logger('bookName : $bookName');
    }
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
                      onSubmitted: (value) => _submit,
                      maxLength: 25,
                      maxLines: 1,
                    ),
                    const CustomSizedBox(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      onPressed: addBook,
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

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_HOME),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: Text('Home screen contents available here!'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => add(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }
}
