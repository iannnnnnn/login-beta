import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignupEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged email:$email';
}

class PasswordChanged extends SignupEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'passwordChanged email:$password';
}

class SignupWithCredentialsPassword extends SignupEvent {
  final String email;
  final String password;

  SignupWithCredentialsPassword({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}
