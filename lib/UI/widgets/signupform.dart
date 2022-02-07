import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/UI/constant.dart';
import 'package:udemy_course/bloc/authentication/authentication_bloc.dart';
import 'package:udemy_course/bloc/authentication/authentication_event.dart';
import 'package:udemy_course/bloc/signup/signup_bloc.dart';
import 'package:udemy_course/bloc/signup/signup_event.dart';
import 'package:udemy_course/bloc/signup/signup_state.dart';
import 'package:udemy_course/repositories/userRepository.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository userRepository;

  SignUpForm({required this.userRepository});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');

  late SignupBloc signUpbloc;
  UserRepository get userRepository => widget.userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignupState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    // TODO: implement initState
    signUpbloc = BlocProvider.of<SignupBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  void _onFormSubmmitted() {
    signUpbloc.add(SignupWithCredentialsPassword(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener(
      bloc: signUpbloc,
      listener: (BuildContext context, SignupState state) {
        if (state.isFaliure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("sign up failed"),
                Icon(Icons.error),
              ],
            )));
        }
        if (state.isSubmitting) {
          print('is submitting');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('sigging up...'),
              CircularProgressIndicator()
            ],
          )));
        }
        if (state.isSuccess) {
          print('success');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        bloc: signUpbloc,
        builder: (context, state) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: backgroundColor,
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Chill',
                      style: TextStyle(
                          fontSize: size.width * 0.2, color: Colors.white),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Divider(
                        height: size.height * 0.05,
                        color: Colors.white,
                      ),
                    ),
                    //Email Form
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
                    //password form
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: TextFormField(
                        obscureText: true,
                        autocorrect: false,
                        controller: _passwordController,
                        validator: (_) {
                          final RegExp _password =
                              RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

                          return _password.hasMatch(_passwordController.text)
                              ? 'invalid password'
                              : null;
                        },
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
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0))),
                      ),
                    ),
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
                                  "sign Up",
                                  style: TextStyle(
                                      fontSize: size.height * 0.04,
                                      color: Colors.blue),
                                ),
                              ),
                            )))
                  ],
                ),
              ));
        },
      ),
    );
  }

  void _onEmailChanged() {
    signUpbloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    signUpbloc.add(PasswordChanged(password: _passwordController.text));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
