import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:udemy_course/UI/validators.dart';
import 'package:udemy_course/bloc/signup/signup_event.dart';
import 'package:udemy_course/bloc/signup/signup_state.dart';
import 'package:udemy_course/repositories/userRepository.dart';

import 'package:bloc/bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  UserRepository userRepository;

  SignupBloc({required this.userRepository}) : super(SignupState.empty());

  @override
  SignupState get initialState => SignupState.empty();

  @override
  Stream<Transition<SignupEvent, SignupState>> transformEvents(
      Stream<SignupEvent> events,
      Stream<Transition<SignupEvent, SignupState>> Function(SignupEvent event)
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
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mappasswordChangedToState(event.password);
    } else if (event is SignupWithCredentialsPassword) {
      yield* _mapSignupwihtCredentialisPressedToState(
          event.email, event.password);
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    yield state.update(EmailValidator.validate(email), true);
  }

  Stream<SignupState> _mappasswordChangedToState(String password) async* {
    yield state.update(true, validators.isValidPassword(password));
  }

  Stream<SignupState> _mapSignupwihtCredentialisPressedToState(
      String email, String password) async* {
    bool check = false;
    yield SignupState.loading();

    await userRepository
        .signUpWithEmailAndPaasword(email, password)
        .whenComplete(() => check = true)
        .catchError((e) {
      check = false;
    });

    if (check) {
      yield SignupState.success();
    } else {
      yield SignupState.failure();
    }
  }
}
