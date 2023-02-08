import 'package:flutter/material.dart';


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

  const CustomSizedBox({super.key, this.width = double.infinity, this.height = 30});

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

  const Paragraph(this.text, {this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
