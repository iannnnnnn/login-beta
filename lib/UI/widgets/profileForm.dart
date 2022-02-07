import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:udemy_course/UI/constant.dart';
import 'package:udemy_course/UI/widgets/gender.dart';
import 'package:udemy_course/bloc/authentication/authentication_bloc.dart';
import 'package:udemy_course/bloc/authentication/authentication_event.dart';
import 'package:udemy_course/bloc/profile/bloc.dart';
import 'package:udemy_course/repositories/userRepository.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository userRepository;

  ProfileForm({required this.userRepository});
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  String? gender = null, interestedIn = null;
  DateTime? age = null;
  FilePickerResult? photo = null;
  GeoPoint? location = null;
  late ProfileBloc profileBloc;

  UserRepository get userRepository => widget.userRepository;

  bool get isFilled => (_nameController.text.isNotEmpty &&
      gender != null &&
      interestedIn != null &&
      photo != null &&
      age != null);

  bool isButtonEnable(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission denided');
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      location = GeoPoint(position.latitude, position.longitude);
    }
  }

  _onSubmitted() async {
    await _getLocation();
    profileBloc.add(Submitted(_nameController.text, gender!, interestedIn!,
        age!, location!, File(photo!.paths[0].toString())));
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
  }

  @override
  void initState() {
    // TODO: implement initState
    _getLocation();
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener(
      bloc: profileBloc,
      listener: (BuildContext context, ProfileState state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Profile creation failed"), Icon(Icons.error)],
            )));
        } else if (state.isSubmitting) {
          print('is submitting');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Submitting...'),
              CircularProgressIndicator()
            ],
          )));
        } else if (state.isSuccess) {
          print('success');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          // Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: backgroundColor,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width,
                      child: CircleAvatar(
                          radius: size.width * 0.2,
                          backgroundColor: Colors.transparent,
                          child: photo == null
                              ? GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? getpic = (await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image));

                                    setState(() {
                                      photo = getpic;
                                    });
                                  },
                                  child: Image.asset('assets/profilephoto.png'),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    photo = (await FilePicker.platform
                                        .pickFiles(type: FileType.image));
                                    setState(() {});
                                  },
                                  child: CircleAvatar(
                                    radius: size.width * 0.3,
                                    backgroundImage: FileImage(
                                        File(photo!.paths[0].toString())),
                                  ),
                                )),
                    ),
                    textFileWidget(_nameController, "Name", size),
                    GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime.now(), onConfirm: (date) {
                          setState(() {
                            age = date;
                          });
                          print(age);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(0.2),
                        child: Text(
                          "Your Birthday?",
                          style: TextStyle(
                              color: Colors.white, fontSize: size.width * 0.09),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.02),
                          child: Text(
                            "You are",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.09),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                gender = "Female";
                                print("tapped $gender");
                                setState(() {});
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.venus,
                                    size: size.height * 0.11,
                                    color: gender == "Female"
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Text(
                                    "Feamle",
                                    style: TextStyle(
                                      color: gender == "Female"
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            genderWidget(
                                FontAwesomeIcons.mars, "Male", size, gender,
                                () {
                              gender = "Male";
                              print("tapped $gender");
                              setState(() {});
                            }),
                            genderWidget(FontAwesomeIcons.transgender,
                                "Transgender", size, gender, () {
                              gender = "Transgender";
                              print("tapped $gender");
                              setState(() {});
                            }),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.02),
                          child: Text(
                            "Looking For:",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.09),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            genderWidget(FontAwesomeIcons.venus, "Female", size,
                                interestedIn, () {
                              interestedIn = "Female";
                              setState(() {});
                            }),
                            genderWidget(FontAwesomeIcons.mars, "Male", size,
                                interestedIn, () {
                              interestedIn = "Male";
                              setState(() {});
                            }),
                            genderWidget(FontAwesomeIcons.transgender,
                                "Transgender", size, interestedIn, () {
                              interestedIn = "Transgender";
                              setState(() {});
                            }),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                      child: GestureDetector(
                        onTap: () {
                          if (isButtonEnable(state)) {
                            _onSubmitted();
                          } else {}
                        },
                        child: Container(
                          width: size.width * 0.8,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: isButtonEnable(state)
                                ? Colors.white
                                : Colors.grey,
                            borderRadius:
                                BorderRadius.circular(size.height * 0.05),
                          ),
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}

Widget textFileWidget(controller, text, size) {
  return Padding(
      padding: EdgeInsets.all(size.height * 0.01),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          labelStyle:
              TextStyle(color: Colors.white, fontSize: size.height * 0.03),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0)),
        ),
      ));
}
