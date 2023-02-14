import 'package:flutter/material.dart';
import '../model/bottom_sheet.dart';

AppBar CustomAppBar({required BuildContext context, required String title, List<Widget>? actions = null}) {
  return AppBar(
    foregroundColor: Colors.white,
    backgroundColor: Theme.of(context).primaryColor,
    title: Text(title),
    actions: actions ?? [],
  );
}

class CustomSizedBox extends StatelessWidget {
  final double width;
  final double height;

  const CustomSizedBox({super.key, this.width = double.infinity, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}

class Heading extends StatelessWidget {
  final String? text;

  const Heading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class TitleMedium extends StatelessWidget {
  final String? text;

  const TitleMedium(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class Paragraph extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color textColor;

  const Paragraph(this.text, {this.textAlign = TextAlign.start, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      textAlign: textAlign,
    );
  }
}

void customBottomSheet(BottomSheetValues bottomSheet) {
  showModalBottomSheet(
      context: bottomSheet.context,
      builder: (BuildContext ctx) {
        return Column(
          children: [
            const CustomSizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  GestureDetector(
                    child: const Icon(Icons.close, size: 25.0),
                    onTap: () {
                      Navigator.of(bottomSheet.context).pop();
                    },
                  ),
                  const CustomSizedBox(height: 0, width: 20),
                  Heading(bottomSheet.heading),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CustomSizedBox(),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.book),
                      label: Text(bottomSheet.hint),
                    ),
                    controller: bottomSheet.controller,
                    onSubmitted: (value) => bottomSheet.callback(),
                    maxLength: 25,
                    maxLines: 1,
                  ),
                  const CustomSizedBox(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(bottomSheet.context).primaryColor),
                    onPressed: () => bottomSheet.callback(),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      });
}
