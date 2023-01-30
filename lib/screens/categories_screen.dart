import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_CATEGORY),
      ),
      body: Center(
        child: Text('Choose/Add Category'),
      ),
    );
  }
}
