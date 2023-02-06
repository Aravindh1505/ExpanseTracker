import 'package:flutter/foundation.dart';

class Utils {
  static void logger(String message) {
    if (kDebugMode) {
      print('ZABC $message');
    }
  }
}
