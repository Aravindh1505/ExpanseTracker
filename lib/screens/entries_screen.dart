import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';
import '../model/entries.dart';
import '../utils/firestore_constants.dart';
import '../utils/utils.dart';
import '../widgets/custom_widgets.dart';
import '../utils/route_names.dart';
import '../model/cash_type.dart';
import 'base_screen.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({Key? key}) : super(key: key);

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> with BaseScreen {
  bool _isLoading = true;
  final List<Entries> _entriesList = [];
  late Book book;

  void cashInAndOut(BuildContext context, CashType type, Book book) {
    book.type = type;
    Navigator.of(context).pushNamed(RouteNames.ENTRIES_FORM_SCREEN, arguments: book).then((value) {
      Utils.logger(value);
      if (value != null && value == true) {
        _getEntries();
      }
    });
  }

  Future<void> _getEntries() async {
    _entriesList.clear();

    setState(() {
      _isLoading = true;
    });

    var collection =
        FirebaseFirestore.instance.collection(FirestoreConstants.USERENTRIES).doc(book.id).collection(book.bookName);

    var querySnapshots = await collection.get();

    for (var snapshots in querySnapshots.docs) {
      Entries entries = Entries(
        id: snapshots.id,
        type: snapshots.data()['type'],
        bookName: snapshots.data()['bookName'],
        amount: snapshots.data()['amount'],
        remark: snapshots.data()['remark'],
        category: snapshots.data()['category'],
        paymentMode: snapshots.data()['paymentMode'],
        date: snapshots.data()['date'],
        createdAt: snapshots.data()['createdAt'],
      );

      _entriesList.add(entries);
    }

    setState(() {
      _isLoading = false;
    });

    Utils.logger(_entriesList.length);
  }

  @override
  void initState() {
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      book = ModalRoute.of(context)?.settings.arguments as Book;
      _getEntries();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    book = ModalRoute.of(context)?.settings.arguments as Book;
    Utils.logger(book.id);

    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: book.bookName,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 600,
            width: double.infinity,
            child: _isLoading
                ? const Center(
                    widthFactor: 30,
                    heightFactor: 30,
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) => Card(
                      elevation: 5.0,
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Heading(_entriesList[index].remark),
                                TitleMedium(_entriesList[index].amount),
                              ],
                            ),
                            const CustomSizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildLabel(_entriesList[index].category, const Color.fromARGB(100, 235, 203, 174)),
                                const CustomSizedBox(height: 0, width: 20),
                                _buildLabel(_entriesList[index].paymentMode, const Color.fromARGB(100, 200, 238, 217)),
                                const CustomSizedBox(height: 0, width: 10),
                                //Paragraph(getFormattedDate(_entriesList[index].date)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    itemCount: _entriesList.length,
                  ),
          ),
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

  Container _buildLabel(String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(label),
    );
  }
}
