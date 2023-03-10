import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../utils/destination.dart';
import 'base_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with BaseScreen {
  late TextEditingController _controller;

  void _submit() {
    String mobileNumber = _controller.text.toString();
    if (mobileNumber.length != 10) {
      showToast('Please enter valid mobile number');
      return;
    }

    Navigator.of(context).pushNamed(Destination.OTP_VERIFICATION_SCREEN, arguments: mobileNumber);
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/smartphone.png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
              const CustomSizedBox(),
              const HeadingText('Verification'),
              const CustomSizedBox(),
              const ParagraphText(
                'We will send you a One Time Password on your phone number',
                textAlign: TextAlign.center,
              ),
              const CustomSizedBox(height: 50),
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
      ),
    );
  }
}
