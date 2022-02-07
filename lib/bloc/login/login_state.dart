import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFaliure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState(
      {required this.isEmailValid,
      required this.isPasswordValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFaliure});

  //initial login form
  factory LoginState.empty() {
    return LoginState(
        isEmailValid: false,
        isPasswordValid: false,
        isSubmitting: false,
        isSuccess: false,
        isFaliure: false);
  }

  factory LoginState.loading() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFaliure: false);
  }

  factory LoginState.failure() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFaliure: true);
  }

  factory LoginState.success() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFaliure: false);
  }

  LoginState update(bool isEmailValid, bool isPasswordValid) {
    return copyWith(isEmailValid, isPasswordValid, false, false, false);
  }

  LoginState copyWith(bool isEmailValid, bool isPasswordValid,
      bool isSubmitting, bool isSuccess, bool isFaliure) {
    return LoginState(
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isSubmitting: isSubmitting,
        isSuccess: isSuccess,
        isFaliure: isFaliure);
  }
}
