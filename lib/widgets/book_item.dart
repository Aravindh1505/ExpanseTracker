import 'package:flutter/material.dart';

import 'custom_widgets.dart';

class BookItem extends StatelessWidget {
  final String bookName;
  final VoidCallback clickAction;
  final VoidCallback deleteBook;

  const BookItem({super.key, required this.bookName, required this.clickAction, required this.deleteBook});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        elevation: 2.0,
        child: ListTile(
          title: HeadingText(bookName),
          leading: const Icon(Icons.book),
          style: ListTileStyle.list,
          onTap: clickAction,
          trailing: GestureDetector(
            onTap: deleteBook,
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
