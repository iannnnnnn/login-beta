import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String gender;
  String interestIn;
  String photo;
  Timestamp? age;
  GeoPoint? location;

  User(
      {required this.uid,
      required this.name,
      required this.gender,
      required this.interestIn,
      required this.photo,
      this.age,
      this.location});

  factory User.empty() {
    return User(
        uid: ' ',
        name: ' ',
        gender: ' ',
        interestIn: ' ',
        photo: ' ',
        age: null,
        location: null);
  }
}
