import 'package:flutter/material.dart';

import '../model/book.dart';
import '../utils/utils.dart';
import '../widgets/custom_widgets.dart';
import '../utils/route_names.dart';
import '../model/cash_type.dart';

class EntriesScreen extends StatelessWidget {
  const EntriesScreen({Key? key}) : super(key: key);

  void cashInAndOut(BuildContext context, CashType type, Book book) {
    book.type = type;
    Navigator.of(context).pushNamed(RouteNames.ENTRIES_FORM_SCREEN, arguments: book);
  }

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)?.settings.arguments as Book;
    Utils.logger(book.id);

    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: book.bookName,
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: const Size(150, 30),
                    ),
                    onPressed: () => cashInAndOut(context, CashType.CASH_IN, book),
                    icon: const Icon(Icons.add),
                    label: const Text('CASH IN'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      fixedSize: const Size(150, 30),
                    ),
                    onPressed: () => cashInAndOut(context, CashType.CASH_OUT, book),
                    icon: const Icon(Icons.remove),
                    label: const Text('CASH OUT'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
