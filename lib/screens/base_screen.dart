import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BaseScreen {
  var currentUserId = FirebaseAuth.instance.currentUser?.uid;

  String getPlatform() => Platform.isAndroid ? 'Android' : 'iOS';

  String getCurrentDateAndTime() => DateTime.now().toString();

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
