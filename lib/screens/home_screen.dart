import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/book.dart';
import '../model/bottom_sheet.dart';
import '../provider/books_provider.dart';
import '../screens/base_screen.dart';
import '../utils/constants.dart';
import '../utils/route_names.dart';
import '../widgets/book_item.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_widgets.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with BaseScreen {
  final TextEditingController _bookController = TextEditingController();

  late BooksProvider _booksProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _booksProvider = Provider.of<BooksProvider>(context, listen: false);

      _booksProvider.getBooks();
      _booksProvider.getData(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _booksProvider.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    pushAndRemove(context, const LoginScreen());
  }

  void _addBook() async {
    String bookName = _bookController.text.toString();
    _booksProvider.addBook(bookName);
    _bookController.text = '';
    Navigator.of(context).pop();
  }

  void _navigateToEntriesScreen(Book book) {
    Navigator.of(context).pushNamed(RouteNames.ENTRIES_SCREEN, arguments: book);
  }

  void _deleteBook(int index) async {
    _booksProvider.deleteBook(index);
  }

  BottomSheetValues buildBottomSheetValues(BuildContext context) {
    return BottomSheetValues(
      context: context,
      callback: _addBook,
      controller: _bookController,
      heading: 'Add New',
      hint: 'Enter book name',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: Constants.TITLE_HOME, actions: [
        IconButton(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
        )
      ]),
      body: Consumer<BooksProvider>(
        builder: (ctx, books, child) => books.isLoading
            ? const Center(child: CircularProgressIndicator())
            : books.bookList.isEmpty
                ? const Center(child: Text('No data found'))
                : ListView.builder(
                    itemBuilder: (ctx, index) => BookItem(
                      bookName: books.bookList[index].bookName,
                      clickAction: () => _navigateToEntriesScreen(books.bookList[index]),
                      deleteBook: () => _deleteBook(index),
                    ),
                    itemCount: books.bookList.length,
                  ),
      ),
      floatingActionButton: CustomFloatingButton(
        label: 'Add New',
        bottomSheet: buildBottomSheetValues(context),
      ),
    );
  }
}
