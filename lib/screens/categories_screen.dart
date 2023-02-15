import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bottom_sheet.dart';
import '../provider/categories_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/radio_button.dart';
import 'base_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with BaseScreen {
  final TextEditingController _categoriesController = TextEditingController();
  late CategoriesProvider categoriesProvider;
  String _selectedCategory = '';

  void _addCategories() {
    var categoryName = _categoriesController.text.toString();

    bool isAvailable = categoriesProvider.isCategoryAvailable(categoryName);

    if (categoryName.isEmpty) {
      showToast('Categories should not be empty');
      return;
    }

    if (isAvailable) {
      showToast('Category already available');
      return;
    }

    categoriesProvider.addUserCategory(categoryName);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: Constants.TITLE_CATEGORY),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Paragraph('Your added Categories'),
            const CustomSizedBox(),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Consumer<CategoriesProvider>(
                builder: (ctx, categories, child) => ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.all(5.0),
                      child: RadioButton(
                        description: categories.userCategories[index].categoryName,
                        value: categories.userCategories[index].categoryName,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                            categoriesProvider.userSelectedCategory(value);
                          });
                        },
                      ),
                    );
                  },
                  itemCount: categories.userCategories.length,
                ),
              ),
            ),
            const CustomSizedBox(),
            const Paragraph('Suggested Categories'),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Consumer<CategoriesProvider>(
                builder: (ctx, categories, child) => ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.all(5.0),
                      child: RadioButton(
                        description: categories.suggestedCategories[index].categoryName,
                        value: categories.suggestedCategories[index].categoryName,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                            categoriesProvider.userSelectedCategory(value);
                          });
                        },
                      ),
                    );
                  },
                  itemCount: categories.suggestedCategories.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        label: 'Add New',
        bottomSheet: BottomSheetValues(
          context: context,
          callback: _addCategories,
          controller: _categoriesController,
          heading: 'Add New',
          hint: 'Enter book name',
        ),
      ),
    );
  }
}
