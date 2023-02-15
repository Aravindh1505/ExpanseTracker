import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../utils/route_names.dart';
import '../widgets/custom_widgets.dart';
import '../screens/home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  String? phone;

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  Future<void> _verifyOTP() async {
    try {
      String otp = _pinPutController.text.toString();

      if (otp.length == 6) {
        await FirebaseAuth.instance
            .signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode!, smsCode: otp))
            .then((value) async {
          if (value.user != null) {
            print(value.user?.uid);
            navigateToHome();
          }
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String mobileNumber = ModalRoute.of(context)?.settings.arguments as String;
    widget.phone = mobileNumber;

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/smartphone.png',
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
            const CustomSizedBox(),
            HeadingText('Verify +91-${widget.phone}'),
            const CustomSizedBox(),
            const ParagraphText('You will get OTP via SMS'),
            const CustomSizedBox(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                controller: _pinPutController,
                pinAnimationType: PinAnimationType.fade,
                onSubmitted: (pin) async {
                  _verifyOTP();
                },
              ),
            ),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 ${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verificationCompleted');
          /*await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              print('verificationCompleted signInWithCredential');
              _verifyOTP();
            }
          });*/
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          print('codeSent $verficationID - $resendToken');
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          print('codeAutoRetrievalTimeout $verificationID');
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  void initState() {
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      String? mobileNumber = ModalRoute.of(context)?.settings.arguments as String?;
      if (mobileNumber != null) {
        widget.phone = mobileNumber;
        _verifyPhone();
      }
    });
    super.initState();
  }
}
