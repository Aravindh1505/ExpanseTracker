import 'package:flutter/material.dart';

import '../model/book.dart';
import '../model/cash_type.dart';

class EntriesBottomButton extends StatelessWidget {
  final Function cashInAndOut;
  final Book book;

  const EntriesBottomButton(this.cashInAndOut, this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(150, 30),
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => cashInAndOut(context, CashType.CASH_IN, book),
                icon: const Icon(Icons.add),
                label: const Text('CASH IN'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => cashInAndOut(context, CashType.CASH_OUT, book),
                icon: const Icon(Icons.remove),
                label: const Text('CASH OUT'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
