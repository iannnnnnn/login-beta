import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:udemy_course/repositories/userRepository.dart';
import 'bloc.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc(this._userRepository) : super(Uninitialisted());
  //maybe some problem here

  @override
  AuthenticationState get initialState => Uninitialisted();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignIn = await _userRepository.isSignIn();
      if (isSignIn) {
        final uid = await _userRepository.getUser();
        final isFirstTime = await _userRepository.isFirstTime(uid);

        if (!isFirstTime) {
          yield AuthenticatedButNotSet(uid);
        } else {
          yield Authenticated(uid);
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final isfirstTime =
        await _userRepository.isFirstTime(await _userRepository.getUser());

    if (!isfirstTime) {
      print("is first time");
      yield AuthenticatedButNotSet(await _userRepository.getUser());
    } else {
      print("is not first time");
      yield Authenticated(await _userRepository.getUser());
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut((e) {});
  }
}
