import 'package:flutter/material.dart';

class BottomSheetValues {
  final BuildContext context;
  final Function callback;
  final TextEditingController controller;
  final String heading;
  final String hint;

  BottomSheetValues({
    required this.context,
    required this.callback,
    required this.controller,
    required this.heading,
    required this.hint,
  });
}
