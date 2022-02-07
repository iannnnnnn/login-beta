import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/UI/Pages/signup.dart';
import 'package:udemy_course/bloc/authentication/authentication_bloc.dart';
import 'package:udemy_course/bloc/authentication/authentication_event.dart';
import 'package:udemy_course/bloc/login/login_bloc.dart';
import 'package:udemy_course/bloc/login/login_state.dart';
import 'package:udemy_course/bloc/login/login_event.dart';
import 'package:udemy_course/repositories/userRepository.dart';

import '../constant.dart';

class LoginForm extends StatefulWidget {
  final UserRepository userRepository;

  LoginForm({required this.userRepository});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late LoginBloc loginBloc;
  UserRepository get userRepository => widget.userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    // TODO: implement initState
    loginBloc = BlocProvider.of<LoginBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  void _onFormSubmmitted() {
    loginBloc.add(LoginWithCredentialsPassword(
        email: _emailController.text, password: _passwordController.text));
  }

  void _onEmailChanged() {
    loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
      bloc: loginBloc,
      listener: (BuildContext context, LoginState state) {
        // TODO: implement listener
        if (state.isFaliure) {
          print("failure");
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Login failed"),
                Icon(Icons.error),
              ],
            )));
        } else if (state.isSubmitting) {
          print('is submitting');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Logging in...'),
              CircularProgressIndicator()
            ],
          )));
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          print('Success');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder(
        bloc: loginBloc,
        builder: (context, LoginState state) {
          return SingleChildScrollView(
              child: Container(
            color: backgroundColor,
            width: size.width,
            height: size.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Chill',
                      style: TextStyle(
                          fontSize: size.width * 0.2, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: Divider(
                      height: size.height * 0.05,
                      color: Colors.white,
                    ),
                  ),
                  //Email
                  //=================
                  Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (_) {
                                return !EmailValidator.validate(
                                        _emailController.text)
                                    ? 'invalid Email'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.03),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0))),
                            ),
                          ],
                        ),
                      )),
                  //=================
                  //password
                  //=================
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: TextFormField(
                      obscureText: true,
                      autocorrect: false,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.03),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0))),
                    ),
                  ),
                  //=================
                  Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: GestureDetector(
                          onTap: isSignUpButtonEnabled(state) &&
                                  _formKey.currentState!.validate()
                              ? _onFormSubmmitted
                              : null,
                          child: Container(
                            width: size.width * 0.8,
                            height: size.width * 0.2,
                            decoration: BoxDecoration(
                              color: isSignUpButtonEnabled(state)
                                  ? Colors.white
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(
                                size.height * 0.05,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: size.height * 0.04,
                                    color: Colors.blue),
                              ),
                            ),
                          ))),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SignUp(userRepository: userRepository);
                      }));
                    },
                    child: Text(
                      "Are you new? Create an account.",
                      style: TextStyle(
                          fontSize: size.height * 0.025, color: Colors.white),
                    ),
                  )
                ]),
          ));
        },
      ),
    );
  }
}
