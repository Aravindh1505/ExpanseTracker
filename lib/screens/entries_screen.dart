import 'package:flutter/material.dart';

class EntriesScreen extends StatelessWidget {
  const EntriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expanse'),
      ),
      body: Center(
        child: Text('Track all monthly expanses here!'),
      ),
    );
  }
}
