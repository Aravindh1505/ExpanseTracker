import 'package:flutter/material.dart';


class CustomProgress extends StatelessWidget {
  const CustomProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(widthFactor: 30, heightFactor: 30, child: CircularProgressIndicator());
  }
}
