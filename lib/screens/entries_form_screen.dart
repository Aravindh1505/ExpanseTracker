import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'base_screen.dart';
import '../model/book.dart';
import '../model/cash_type.dart';
import '../widgets/custom_widgets.dart';
import '../provider/categories_provider.dart';
import '../provider/paymode_provider.dart';
import '../provider/entries_provider.dart';
import '../utils/utils.dart';
import '../utils/destination.dart';

class EntriesFormScreen extends StatefulWidget {
  const EntriesFormScreen({Key? key}) : super(key: key);

  @override
  State<EntriesFormScreen> createState() => _EntriesFormScreenState();
}

class _EntriesFormScreenState extends State<EntriesFormScreen> with BaseScreen {
  late TextEditingController _amountController;
  late TextEditingController _remarkController;
  late TextEditingController _categoryController;
  late TextEditingController _payModeController;
  late TextEditingController _dateController;

  var _selectedDate = '';

  @override
  void initState() {
    _amountController = TextEditingController();
    _remarkController = TextEditingController();
    _categoryController = TextEditingController();
    _payModeController = TextEditingController();
    _dateController = TextEditingController();

    CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    PayModeProvider payModeProvider = Provider.of<PayModeProvider>(context, listen: false);

    categoriesProvider.userSelectedCategory('');
    payModeProvider.userSelectedPayMode('');

    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarkController.dispose();
    _categoryController.dispose();
    _payModeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _save(Book book, BuildContext context) async {
    var amount = _amountController.text.toString();
    var remark = _remarkController.text.toString();
    var category = _categoryController.text.toString();
    var payMode = _payModeController.text.toString();

    if (amount.isEmpty) {
      showToast('Please enter amount');
      return;
    }

    if (remark.isEmpty) {
      showToast('Please enter remark');
      return;
    }

    var entriesProvider = Provider.of<EntriesProvider>(context, listen: false);
    entriesProvider.save(book, amount, remark, category, payMode, _selectedDate);
    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022, 1),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      _selectedDate = selectedDate.toString();
      var date = getFormattedDate(selectedDate.toString());
      Utils.logger('selectedDate $date');
      _dateController.text = date.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Utils.logger('entries form screen rebuild...');
    Book book = ModalRoute.of(context)?.settings.arguments as Book;

    return Scaffold(
      appBar: CustomAppBar(context: context, title: book.type == CashType.CASH_IN ? 'Cash in' : 'Cash out'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              const CustomSizedBox(),
              TextField(
                enabled: true,
                readOnly: true,
                showCursor: false,
                autofocus: false,
                enableInteractiveSelection: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payment),
                  label: Text('Choose Date'),
                ),
                controller: _dateController,
                onTap: _datePicker,
              ),
              const CustomSizedBox(height: 35),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                  label: Text('Amount'),
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
              const CustomSizedBox(),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt),
                  label: Text('Remark'),
                ),
                controller: _remarkController,
                keyboardType: TextInputType.text,
                maxLength: 25,
              ),
              const CustomSizedBox(),
              Consumer<CategoriesProvider>(builder: (ctx, category, child) {
                _categoryController.text = category.selectedCategory;
                return TextField(
                  enabled: true,
                  readOnly: true,
                  showCursor: false,
                  autofocus: false,
                  enableInteractiveSelection: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                    label: Text('Category'),
                  ),
                  controller: _categoryController,
                  onTap: () {
                    Navigator.of(context).pushNamed(Destination.CATEGORIES_SCREEN);
                  },
                );
              }),
              const CustomSizedBox(height: 40),
              Consumer<PayModeProvider>(
                builder: (ctx, paymode, child) {
                  _payModeController.text = paymode.selectedPayMode;
                  return TextField(
                    enabled: true,
                    readOnly: true,
                    showCursor: false,
                    autofocus: false,
                    enableInteractiveSelection: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                      label: Text('PayMode'),
                    ),
                    controller: _payModeController,
                    onTap: () {
                      Navigator.of(context).pushNamed(Destination.PAYMENT_MODE_SCREEN);
                    },
                  );
                },
              ),
              const CustomSizedBox(),
              ElevatedButton(
                onPressed: () => _save(book, context),
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
