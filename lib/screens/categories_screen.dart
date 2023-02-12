import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/categories.dart';
import '../provider/categories_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_CATEGORY),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Consumer<CategoriesProvider>(
          builder: (ctx, categories, child) => ListView.builder(
            itemBuilder: (ctx, index) {
              return Text(categories.list[index]['display']);
            },
            itemCount: categories.list.length,
          ),
        ),
      ),
    );
  }
}
