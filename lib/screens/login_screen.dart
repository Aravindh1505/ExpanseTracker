import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../utils/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _controller;

  void _submit() {
    String mobileNumber = _controller.text.toString();
    print('MobileNumber $mobileNumber');

    Navigator.of(context).pushNamed(RouteNames.OTP_VERIFICATION_SCREEN, arguments: mobileNumber);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.TITLE_LOGIN),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/smartphone.png',
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
            const CustomSizedBox(),
            const Heading('Verification'),
            const CustomSizedBox(),
            const Paragraph('We will send you a One Time Password on your phone number'),
            const CustomSizedBox(),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone_android),
                label: Text('Enter mobile number'),
              ),
              controller: _controller,
              onSubmitted: (value) => _submit(),
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
            const CustomSizedBox(),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Get OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
