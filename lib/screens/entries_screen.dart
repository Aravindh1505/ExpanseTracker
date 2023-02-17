import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/book.dart';
import '../model/cash_type.dart';
import '../model/entries.dart';
import '../provider/entries_provider.dart';
import '../utils/destination.dart';
import '../utils/utils.dart';
import '../widgets/custom_progress.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/entries_bottom_button.dart';
import '../widgets/entries_item.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({Key? key}) : super(key: key);

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  @override
  void initState() {
    Utils.logger('initState triggered...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Book book = ModalRoute.of(context)?.settings.arguments as Book;
      var entriesProvider = Provider.of<EntriesProvider>(context, listen: false);
      entriesProvider.resetExpense();
      entriesProvider.fetchEntries(book);
    });
    super.initState();
  }

  void cashInAndOut(BuildContext context, CashType type, Book book) {
    book.type = type;
    Navigator.of(context).pushNamed(Destination.ENTRIES_FORM_SCREEN, arguments: book).then((value) {
      Utils.logger(value);
      if (value != null && value == true) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    Utils.logger('Entries screen rebuild...');
    Book book = ModalRoute.of(context)?.settings.arguments as Book;

    return Scaffold(
      appBar: CustomAppBar(context: context, title: book.bookName),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(2.0),
          child: Consumer<EntriesProvider>(
            builder: (ctx, entries, child) => Column(
              children: [
                buildTopSection('Total in (+)', entries.expense?.cashIn.toString()),
                buildTopSection('Total out (-)', entries.expense?.cashOut.toString()),
                buildTopSection('Net Balance', entries.expense?.total.toString()),
                SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: entries.isLoading ? const CustomProgress() : EntriesItem(entries.list),
                ),
                EntriesBottomButton(cashInAndOut, book),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopSection(String title, String? amount) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(title),
          ParagraphText(amount ?? '0'),
        ],
      ),
    );
  }
}
