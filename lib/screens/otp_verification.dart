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

  void _verifyOTP() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomeScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
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
      body: Column(
        children: [
          Image.asset(
            'assets/images/smartphone.png',
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
          const CustomSizedBox(),
          Heading('Verify +91-${widget.phone}'),
          const CustomSizedBox(),
          const Paragraph('You will get OTP via SMS'),
          const CustomSizedBox(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              controller: _pinPutController,
              pinAnimationType: PinAnimationType.fade,
              onSubmitted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(
                          PhoneAuthProvider.credential(verificationId: _verificationCode!, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      print(value.user?.uid);
                    }
                  });
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _verifyOTP,
            child: const Text('Verify OTP'),
          ),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 ${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verificationCompleted');
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
            if (value.user != null) {}
          });
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
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_verifyPhone();
  }
}
