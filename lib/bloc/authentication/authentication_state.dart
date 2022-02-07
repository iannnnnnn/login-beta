import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialisted extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String UserId;

  Authenticated(this.UserId);

  @override
  List<Object> get props => [UserId];

  @override
  String toString() => "Authenticated $UserId";
}

class AuthenticatedButNotSet extends AuthenticationState {
  final String UserId;

  AuthenticatedButNotSet(this.UserId);

  @override
  List<Object> get props => [UserId];
}

class Unauthenticated extends AuthenticationState {}
