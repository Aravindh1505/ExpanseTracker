import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/book.dart';
import '../model/cash_type.dart';
import '../model/entries.dart';
import '../provider/entries_provider.dart';
import '../utils/route_names.dart';
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
  bool isInitialLaunch = true;

  @override
  void initState() {
    super.initState();
  }

  void cashInAndOut(BuildContext context, CashType type, Book book) {
    book.type = type;
    Navigator.of(context).pushNamed(RouteNames.ENTRIES_FORM_SCREEN, arguments: book).then((value) {
      Utils.logger(value);
      if (value != null && value == true) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)?.settings.arguments as Book;
    var entriesProvider = Provider.of<EntriesProvider>(context, listen: true);
    var isLoading = entriesProvider.isLoading;
    late Future<List<Entries>> fetchEntries;

    if (isInitialLaunch) {
      fetchEntries = entriesProvider.fetchEntries(book);
      isInitialLaunch = false;
    }

    return Scaffold(
      appBar: CustomAppBar(context: context, title: book.bookName),
      body: FutureBuilder<List<Entries>>(
        future: fetchEntries,
        builder: (context, snapshot) {
          return SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: isLoading ? const CustomProgress() : EntriesItem(snapshot.data),
                ),
                EntriesBottomButton(cashInAndOut, book),
              ],
            ),
          );
        },
      ),
    );
  }
}
