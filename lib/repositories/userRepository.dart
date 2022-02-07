import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/bloc/login/bloc.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebasefirestore;

  UserRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseStorage})
      : _firebaseAuth = FirebaseAuth.instance,
        _firebasefirestore = FirebaseFirestore.instance {
    isLoggedIn();
  }

  bool LoggedIn = false;

  Future<void> isLoggedIn() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null)
        LoggedIn = false;
      else
        LoggedIn = true;
    });
  }

  Future<bool> isSignIn() async {
    return LoggedIn;
  }

  //Login with email
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw IntegerDivisionByZeroException();
    }
  }

  //Check if the user exist
  Future<bool> isFirstTime(String userId) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) => exist = user.exists);

    return exist;
  }

  //Create a user
  Future<void> signUpWithEmailAndPaasword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw IntegerDivisionByZeroException();
    }
  }

  //SignOut
  void signOut(void Function(FirebaseAuthException e) errorCallback) async {
    try {
      _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<String> getUser() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> profileSetUp(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime age,
      GeoPoint location) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child('userPhotos').child(userId).child(userId);
    UploadTask uploadTask = ref.putFile(photo);

    uploadTask.then((res) => res.ref.getDownloadURL().then((url) async {
          await _firebasefirestore.collection('users').doc(userId).set({
            'uid': userId,
            'photoUrl': url,
            'name': name,
            'location': location,
            'gender': gender,
            'interestedIn': interestedIn,
            'age': age
          });
        }));
  }
}
