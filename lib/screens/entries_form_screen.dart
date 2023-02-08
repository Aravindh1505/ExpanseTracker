import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';
import '../utils/firestore_constants.dart';
import '../widgets/custom_widgets.dart';
import '../model/cash_type.dart';
import 'base_screen.dart';

class EntriesFormScreen extends StatefulWidget {
  const EntriesFormScreen({Key? key}) : super(key: key);

  @override
  State<EntriesFormScreen> createState() => _EntriesFormScreenState();
}

class _EntriesFormScreenState extends State<EntriesFormScreen> with BaseScreen {
  late TextEditingController _amountController;
  late TextEditingController _remarkController;

  @override
  void initState() {
    _amountController = TextEditingController();
    _remarkController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save(Book book) async {
    var amount = _amountController.text.toString();
    var remark = _remarkController.text.toString();

    Map<String, dynamic> data = {
      'userId': currentUserId,
      'bookName': book.bookName,
      'type': book.type.name,
      'amount': amount,
      'remark': remark,
      'category': 'other',
      'paymentMode': 'cash',
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

    /*
    * FirebaseFirestore.instance
        .collection(FirestoreConstants.BOOKS)
        .doc(currentUserId)
        .collection(FirestoreConstants.USERENTRIES)
        .doc(book.id)
        .collection(DateTime.now().millisecondsSinceEpoch.toString())
        .add(<String, dynamic>{
      'userId': currentUserId,
      'bookName': book.bookName,
      'type': book.type.name,
      'amount': amount,
      'remark': remark,
      'category': 'other',
      'paymentMode': 'cash',
      'date': getCurrentDateAndTime(),
      'platform': getPlatform(),
      'createdAt': getCurrentDateAndTime(),
    });*/
  }

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)?.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.type == CashType.CASH_IN ? 'Cash in' : 'Cash out'),
      ),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const CustomSizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
                label: Text('Enter amount'),
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            const CustomSizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note_alt),
                label: Text('Enter remark'),
              ),
              controller: _remarkController,
              keyboardType: TextInputType.text,
              maxLength: 25,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('SAVE & ADD NEW'),
                    ),
                    ElevatedButton(
                      onPressed: () => _save(book),
                      child: const Text('SAVE'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
