import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/UI/constant.dart';
import 'package:udemy_course/UI/widgets/signupform.dart';
import 'package:udemy_course/bloc/signup/signup_bloc.dart';
import 'package:udemy_course/repositories/userRepository.dart';

class SignUp extends StatelessWidget {
  final UserRepository userRepository;
  SignUp({required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(fontSize: 36.0),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<SignupBloc>(
        create: (context) => SignupBloc(userRepository: userRepository),
        child: SignUpForm(
          userRepository: userRepository,
        ),
      ),
    );
  }
}
