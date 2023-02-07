import 'package:flutter/foundation.dart';

class Utils {
  static void logger(Object? object) {
    if (kDebugMode) {
      print('ZABC $object');
    }
  }
}
