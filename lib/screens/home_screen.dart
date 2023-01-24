import 'package:flutter/material.dart';

import '../utils/route_names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanse Tracker'),
      ),
      body: Center(
        child: Text('Home screen contents available here!'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.ENTRIES_SCREEN);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),

      ),
    );
  }
}
