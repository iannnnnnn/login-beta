import 'package:meta/meta.dart';

@immutable
class SignupState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFaliure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  SignupState(
      {required this.isEmailValid,
      required this.isPasswordValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFaliure});

  //initial login form
  factory SignupState.empty() {
    return SignupState(
        isEmailValid: false,
        isPasswordValid: false,
        isSubmitting: false,
        isSuccess: false,
        isFaliure: false);
  }

  factory SignupState.loading() {
    return SignupState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFaliure: false);
  }

  factory SignupState.failure() {
    return SignupState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFaliure: true);
  }

  factory SignupState.success() {
    return SignupState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFaliure: false);
  }

  SignupState update(bool isEmailValid, bool isPasswordValid) {
    return copyWith(isEmailValid, isPasswordValid, false, false, false);
  }

  SignupState copyWith(bool isEmailValid, bool isPasswordValid,
      bool isSubmitting, bool isSuccess, bool isFaliure) {
    return SignupState(
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isSubmitting: isSubmitting,
        isSuccess: isSuccess,
        isFaliure: isFaliure);
  }
}
