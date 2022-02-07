import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/UI/constant.dart';
import 'package:udemy_course/UI/widgets/LoginForm.dart';
import 'package:udemy_course/bloc/login/login_bloc.dart';
import 'package:udemy_course/repositories/userRepository.dart';

class Login extends StatelessWidget {
  final UserRepository userRepository;
  Login({required this.userRepository});

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
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: userRepository),
        child: LoginForm(
          userRepository: userRepository,
        ),
      ),
    );
  }
}
