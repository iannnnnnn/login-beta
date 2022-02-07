import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:udemy_course/bloc/login/bloc.dart';
import 'package:udemy_course/repositories/userRepository.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:udemy_course/UI/validators.dart';

import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;

  LoginBloc({required this.userRepository}) : super(LoginState.empty());

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> events,
      Stream<Transition<LoginEvent, LoginState>> Function(LoginEvent event)
          next) {
    final nonDebouncedStream = events.where((event) {
      return (event is! EmailChanged || event is! PasswordChanged);
    });

    final debouncedStream = events.where((event) {
      return (event is! EmailChanged || event is! PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super
        .transformEvents(nonDebouncedStream.mergeWith([debouncedStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    }
    if (event is PasswordChanged) {
      yield* _mappasswordChangedToState(event.password);
    }
    if (event is LoginWithCredentialsPassword) {
      print("login with credentialandpassword");
      yield* _mapLoginwihtCredentialisPressedToState(
          event.email, event.password);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(EmailValidator.validate(email), true);
  }

  Stream<LoginState> _mappasswordChangedToState(String password) async* {
    yield state.update(true, validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginwihtCredentialisPressedToState(
      String email, String password) async* {
    yield LoginState.loading();
    bool check = false;

    await userRepository
        .signInWithEmail(
      email,
      password,
    )
        .whenComplete(() {
      print("ohhhh");
      check = true;
    }).catchError((e) {
      print("ee");
      check = false;
    });

    if (check) {
      yield LoginState.success();
    } else {
      yield LoginState.failure();
    }
  }
}
