import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/UI/Pages/Splash.dart';
import 'package:udemy_course/UI/Pages/login.dart';
import 'package:udemy_course/UI/Pages/profile.dart';
import 'package:udemy_course/UI/Pages/signup.dart';
import 'package:udemy_course/UI/widgets/LoginForm.dart';
import 'package:udemy_course/bloc/authentication/bloc.dart';
import 'package:udemy_course/bloc/login/bloc.dart';
import 'package:udemy_course/repositories/userRepository.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final UserRepository _userepository = UserRepository();
//   late AuthenticationBloc _authenticationBloc;

//   @override
//   void initState() {
//     _authenticationBloc = AuthenticationBloc(_userepository);
//     Timer(Duration(seconds: 3), () {
//       print("Yeah, this line is printed after 3 seconds");
//       _authenticationBloc.add(AppStarted());
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _authenticationBloc,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: BlocBuilder(
//             bloc: _authenticationBloc,
//             builder: (context, state) {
//               if (state is Uninitialisted) {
//                 print('state is uninitialisted');
//                 return Splash();
//               } else if (state is Authenticated) {
//                 return Tabs();
//               } else if (state is AuthenticatedButNotSet) {
//                 return Profile(
//                     userRepository: _userepository, userId: state.UserId);
//               } else if (state is Unauthenticated) {
//                 return Login(userRepository: _userepository);
//               } else
//                 return Container();
//             }),
//       ),
//     );
//   }
// }

class Home extends StatelessWidget {
  final UserRepository userRepository;
  Home({required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialisted) {
            print('state is uninitialisted');
            return Splash();
          } else if (state is Authenticated) {
            return Profile(userRepository: userRepository, userId: state.UserId);
            
          } else if (state is AuthenticatedButNotSet) {
            return Profile(
                userRepository: userRepository, userId: state.UserId);
          } else if (state is Unauthenticated) {
            return Login(userRepository: userRepository);
          } else
            return Container();
        },
      ),
    );
  }
}
