import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/UI/constant.dart';
import 'package:udemy_course/UI/widgets/profileForm.dart';
import 'package:udemy_course/bloc/profile/bloc.dart';
import 'package:udemy_course/repositories/userRepository.dart';

class Profile extends StatelessWidget {
  final UserRepository userRepository;
  final userId;

  Profile({required this.userRepository, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Setup"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => ProfileBloc(userRepository: userRepository),
        child: ProfileForm(
          userRepository: userRepository,
        ),
      ),
    );
  }
}
