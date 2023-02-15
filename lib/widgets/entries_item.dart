import 'package:expanse_tracker/model/cash_type.dart';
import 'package:flutter/material.dart';

import '../model/entries.dart';
import '../screens/base_screen.dart';
import 'custom_widgets.dart';

class EntriesItem extends StatelessWidget with BaseScreen {
  final List<Entries?>? entries;

  EntriesItem(this.entries, {super.key});

  @override
  Widget build(BuildContext context) {
    if (entries?.length == 0) {
      return const Center(
        child: ParagraphText('No entries found'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) => SizedBox(
          height: 120,
          child: Card(
            elevation: 5.0,
            child: Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeadingText(entries?[index]?.remark),
                      TitleText(
                        'Rs. ${entries?[index]?.amount}',
                        textColor: entries?[index]?.type == CashType.CASH_IN.name ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  const CustomSizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildLabel(entries?[index]?.category, const Color.fromARGB(100, 235, 203, 174)),
                      const CustomSizedBox(height: 0, width: 15),
                      _buildLabel(entries?[index]?.paymentMode, const Color.fromARGB(100, 200, 238, 217)),
                      const Spacer(),
                      LabelText(getFormattedDate(entries?[index]?.date), textColor: Colors.black54),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        itemCount: entries?.length,
      );
    }
  }
}

Widget _buildLabel(String? label, Color color) {
  return label == null || label.isEmpty
      ? const Text('')
      : Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: label != null ? LabelText(label) : const Text(''),
        );
}
