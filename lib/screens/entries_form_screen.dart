import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/book.dart';
import '../provider/entries_provider.dart';
import '../utils/firestore_constants.dart';
import '../utils/utils.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_widgets.dart';
import '../model/cash_type.dart';
import '../widgets/dropdown_formfield.dart';
import 'base_screen.dart';

class EntriesFormScreen extends StatefulWidget {
  const EntriesFormScreen({Key? key}) : super(key: key);

  @override
  State<EntriesFormScreen> createState() => _EntriesFormScreenState();
}

class _EntriesFormScreenState extends State<EntriesFormScreen> with BaseScreen {
  bool _isNewEntryAdded = false;

  late TextEditingController _amountController;
  late TextEditingController _remarkController;

  String _selectedCategory = '';

  String _myActivity = '';

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

  void _save(Book book, BuildContext context) async {
    var amount = _amountController.text.toString();
    var remark = _remarkController.text.toString();

    var entriesProvider = Provider.of<EntriesProvider>(context, listen: false);
    entriesProvider.save(book, amount, remark);
  }

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)?.settings.arguments as Book;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _isNewEntryAdded);
        return false;
      },
      child: Scaffold(
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
              DropDownFormField(
                titleText: 'Choose Category',
                hintText: 'Please choose one',
                value: _myActivity,
                onSaved: (value) {
                  setState(() {
                    _myActivity = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _myActivity = value;
                  });
                },
                dataSource: const [
                  {
                    "display": "Running",
                    "value": "Running",
                  },
                  {
                    "display": "Climbing",
                    "value": "Climbing",
                  },
                ],
                textField: 'display',
                valueField: 'value',
                validator: (value) {},
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
                        onPressed: () => _save(book, context),
                        child: const Text('SAVE'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
