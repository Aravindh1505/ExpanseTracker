import 'package:flutter/material.dart';

import '../model/entries.dart';
import 'custom_widgets.dart';

class EntriesItem extends StatelessWidget {
  final List<Entries?>? entries;

  const EntriesItem(this.entries, {super.key});

  @override
  Widget build(BuildContext context) {
    return entries?.length == 0 ? const Center(
      child: Paragraph('No entries found'),
    ) : ListView.builder(
      itemBuilder: (ctx, index) => SizedBox(
        height: 120,
        child: Card(
          elevation: 5.0,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Heading(entries?[index]?.remark),
                      TitleMedium(entries?[index]?.amount),
                    ],
                  ),
                ),
                const CustomSizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildLabel(entries?[index]?.category, const Color.fromARGB(100, 235, 203, 174)),
                    const CustomSizedBox(height: 0, width: 20),
                    _buildLabel(entries?[index]?.paymentMode, const Color.fromARGB(100, 200, 238, 217)),
                    const CustomSizedBox(height: 0, width: 10),
                    //Paragraph(getFormattedDate(_entriesList[index].date)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      itemCount: entries?.length,
    );
  }
}

Container _buildLabel(String? label, Color color) {
  return Container(
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(width: 0.5),
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: label != null ? Text(label) : const Text(''),
  );
}
