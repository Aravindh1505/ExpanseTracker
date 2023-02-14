import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BaseScreen {
  static const String pattern = 'yyyy-MM-dd hh:mm:ss.SSS';

  var currentUserId = FirebaseAuth.instance.currentUser?.uid;

  String getPlatform() => Platform.isAndroid ? 'Android' : 'iOS';

  String getCurrentDateAndTime() => DateTime.now().toString();

  String getFormattedDate(String date) {
    DateTime tempDate = DateFormat(pattern).parse(date);
    return DateFormat.yMMMMd().format(tempDate);
  }

  showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void pushAndRemove(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => widget,
      ),
      (route) => false,
    );
  }
}
