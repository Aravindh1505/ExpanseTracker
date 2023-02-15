import 'package:expanse_tracker/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/books_provider.dart';
import '../provider/categories_provider.dart';
import '../provider/entries_provider.dart';
import '../provider/paymode_provider.dart';
import '../screens/base_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/entries_form_screen.dart';
import '../screens/entries_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_verification.dart';
import '../screens/payment_mode_screen.dart';
import '../screens/splash_screen.dart';
import '../theme/custom_theme.dart';
import '../utils/route_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;

  runApp(MyApp());
}

class MyApp extends StatelessWidget with BaseScreen {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EntriesProvider>(create: (_) => EntriesProvider()),
        ChangeNotifierProvider<CategoriesProvider>(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider<PayModeProvider>(create: (_) => PayModeProvider()),
        ChangeNotifierProvider<BooksProvider>(create: (_) => BooksProvider()),
      ],
      child: MaterialApp(
        theme: CustomTheme.lightTheme,
        routes: {
          RouteNames.HOME: (_) => currentUserId == null ? const LoginScreen() : const HomeScreen(),
          RouteNames.LOGIN_SCREEN: (_) => const LoginScreen(),
          RouteNames.OTP_VERIFICATION_SCREEN: (_) => OtpVerificationScreen(),
          RouteNames.ENTRIES_SCREEN: (_) => const EntriesScreen(),
          RouteNames.ENTRIES_FORM_SCREEN: (_) => const EntriesFormScreen(),
          RouteNames.CATEGORIES_SCREEN: (_) => const CategoriesScreen(),
          RouteNames.PAYMENT_MODE_SCREEN: (_) => PaymentModeScreen(),
        },
      ),
    );
  }
}
