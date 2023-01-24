import 'package:flutter/material.dart';

class EntriesFormScreen extends StatelessWidget {
  const EntriesFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash in/out entry'),
      ),
      body: Center(
        child: Text('Add amount, category and payment mode based on expanse date'),
      ),
    );
  }
}
