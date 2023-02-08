import 'package:flutter/material.dart';

import '../model/book.dart';
import '../widgets/custom_widgets.dart';

class EntriesFormScreen extends StatefulWidget {
  const EntriesFormScreen({Key? key}) : super(key: key);

  @override
  State<EntriesFormScreen> createState() => _EntriesFormScreenState();
}

class _EntriesFormScreenState extends State<EntriesFormScreen> {
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

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)?.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash in/out entry'),
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
                      onPressed: () {},
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
