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

class HeadingText extends StatelessWidget {
  final String? text;
  final Color textColor;

  const HeadingText(this.text, {super.key, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        color: textColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String? text;
  final Color textColor;

  const TitleText(this.text, {super.key, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        color: textColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class ParagraphText extends StatelessWidget {
  final String? text;
  final TextAlign textAlign;
  final Color textColor;

  const ParagraphText(this.text, {super.key, this.textAlign = TextAlign.start, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      style: TextStyle(
        color: textColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w300,
      ),
      textAlign: textAlign,
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color textColor;

  const LabelText(this.text, {super.key, this.textAlign = TextAlign.start, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w200,
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
                  HeadingText(bottomSheet.heading),
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
