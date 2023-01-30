import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PaymentModeScreen extends StatelessWidget {
  const PaymentModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_PAYMENT_MODE),
      ),
      body: Center(
        child: Text('Choose/Add Category'),
      ),
    );
  }
}
