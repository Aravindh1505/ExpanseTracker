import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/categories.dart';
import '../provider/categories_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/radio_button.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategory = '';

  addCategories(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Constants.TITLE_CATEGORY),
        ),
        body: Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Paragraph('Suggested Categories'),
              const CustomSizedBox(),
              SizedBox(
                height: 500,
                width: double.infinity,
                child: Consumer<CategoriesProvider>(
                  builder: (ctx, categories, child) => ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(5.0),
                        child: RadioButton(
                          description: categories.list[index]['display'],
                          value: categories.list[index]['display'],
                          groupValue: _selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      );
                    },
                    itemCount: categories.list.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFloatingButton(
          label: 'Add New',
          callback: () => addCategories(context),
        ));
  }
}
