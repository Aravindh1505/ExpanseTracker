import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/entries_screen.dart';
import '../screens/entries_form_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/payment_mode_screen.dart';
import '../utils/route_names.dart';
import '../utils/custom_theme.dart';
import '../screens/firebase_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
      routes: {
        RouteNames.HOME: (_) => const FirebaseDemoScreen(),
        RouteNames.ENTRIES_SCREEN: (_) => const EntriesScreen(),
        RouteNames.ENTRIES_FORM_SCREEN: (_) => const EntriesFormScreen(),
        RouteNames.CATEGORIES_SCREEN: (_) => const CategoriesScreen(),
        RouteNames.PAYMENT_MODE_SCREEN: (_) => const PaymentModeScreen()
      },
    );
  }
}
