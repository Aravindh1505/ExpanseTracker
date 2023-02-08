import 'cash_type.dart';

class Book {
  final String id;
  final String bookName;
  CashType type;

  Book({required this.id, required this.bookName, this.type = CashType.NONE});
}
