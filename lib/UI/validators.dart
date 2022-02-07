import 'package:email_validator/email_validator.dart';

class validators {
  static final RegExp _password =
      RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

  static isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  static isValidPassword(String password) {
    return _password.hasMatch(password);
  }
}
