import 'package:flutter/material.dart';

import '../model/bottom_sheet.dart';
import 'custom_widgets.dart';

class CustomFloatingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final BottomSheetValues bottomSheet;

  const CustomFloatingButton({
    super.key,
    required this.label,
    this.icon = Icons.add,
    required this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => customBottomSheet(bottomSheet),
      icon: Icon(icon),
      label: TitleText(label),
    );
  }
}
