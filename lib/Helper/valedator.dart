import 'package:denta_needs/Helper/applocal.dart';

class Validator {
  static String password(context, value) {
    if (value == null || value.isEmpty) {
      return getLang(context, 'required');
    }
    return null;
  }
}
