import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback callback;

  const CustomFloatingButton({
    super.key,
    required this.label,
    required this.callback,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: callback,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
