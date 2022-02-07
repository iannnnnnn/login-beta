import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged email:$email';
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'passwordChanged email:$password';
}

class LoginWithCredentialsPassword extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPassword({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}
