import 'package:firebase_auth/firebase_auth.dart';

class FirestoreConstants {
  static var currentUserId = FirebaseAuth.instance.currentUser?.uid;

  /*COLLECTION NAMES*/

  static const BOOKS = 'books';

  static const USERBOOKS = 'userBooks';

  static const USERCATEGORY = 'userCategory';

  static const USERPAYMENTMODES = 'userPaymentModes';

  static String getUserBooks() => 'books/$currentUserId/$USERBOOKS';

  static const CATEGORIES = 'categories';

  static const PAYMODES = 'paymodes';
}
