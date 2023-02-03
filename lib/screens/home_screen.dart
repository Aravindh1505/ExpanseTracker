import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanse_tracker/widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  TextEditingController _bookController = TextEditingController();

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

  void add(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: const [
                    Icon(Icons.close, size: 25.0),
                    CustomSizedBox(height: 0, width: 20,),
                    Heading('Add New Book'),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const TitleMedium('Suggestions'),
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
