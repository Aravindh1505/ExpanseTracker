import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bottom_sheet.dart';
import '../model/payment_mode.dart';
import '../provider/paymode_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../screens/base_screen.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/radio_button.dart';

class PaymentModeScreen extends StatefulWidget {
  PaymentModeScreen({Key? key}) : super(key: key);

  @override
  State<PaymentModeScreen> createState() => _PaymentModeScreenState();
}

class _PaymentModeScreenState extends State<PaymentModeScreen> with BaseScreen {
  final TextEditingController _payModeController = TextEditingController();

  late PayModeProvider _payModeProvider;

  String _selectedPayMode = '';

  void _addPayMode() {
    var payMode = _payModeController.text.toString();
    bool isAvailable = _payModeProvider.isPayModeAvailable(payMode);

    if (payMode.isEmpty) {
      showToast('PayMode should not be empty');
      return;
    }

    if (isAvailable) {
      showToast('PayMode already available');
      return;
    }

    _payModeProvider.addUserPayMode(payMode);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _payModeProvider = Provider.of<PayModeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_PAYMENT_MODE),
      ),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Paragraph('Your added PayModes'),
            const CustomSizedBox(),
            Consumer<PayModeProvider>(
              builder: (ctx, paymode, child) => ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.all(5.0),
                    child: RadioButton(
                      description: paymode.userPayModeList[index].payName,
                      value: paymode.userPayModeList[index].payName,
                      groupValue: _selectedPayMode,
                      onChanged: (value) {
                        setState(() {
                          _selectedPayMode = value!;
                          _payModeProvider.userSelectedPayMode(value);
                        });
                      },
                    ),
                  );
                },
                itemCount: paymode.userPayModeList.length,
              ),
            ),
            const CustomSizedBox(),
            const Paragraph('Suggested PayModes'),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Consumer<PayModeProvider>(
                builder: (ctx, paymode, child) => ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.all(5.0),
                      child: RadioButton(
                        description: paymode.suggestedPayModeList[index].payName,
                        value: paymode.suggestedPayModeList[index].payName,
                        groupValue: _selectedPayMode,
                        onChanged: (value) {
                          setState(() {
                            _selectedPayMode = value!;
                            _payModeProvider.userSelectedPayMode(value);
                          });
                        },
                      ),
                    );
                  },
                  itemCount: paymode.suggestedPayModeList.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        label: 'Add New',
        bottomSheet: BottomSheetValues(
          context: context,
          callback: _addPayMode,
          controller: _payModeController,
          heading: 'Add New',
          hint: 'Enter pay mode name',
        ),
      ),
    );
  }
}
