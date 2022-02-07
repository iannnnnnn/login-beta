import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/UI/Pages/home.dart';
import 'package:udemy_course/bloc/authentication/authentication_bloc.dart';
import 'package:udemy_course/bloc/authentication/authentication_event.dart';
import 'package:udemy_course/bloc/blocDelegate.dart';
import 'package:udemy_course/repositories/userRepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    create: (context) => AuthenticationBloc(userRepository)..add(AppStarted()),
    child: Home(
      userRepository: userRepository,
    ),
  ));
}
