import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ProfileEvent {
  final String name;

  NameChanged({required this.name});

  @override
  List<Object> get props => [];
}

class PhotoChanged extends ProfileEvent {
  final File photo;

  PhotoChanged({required this.photo});

  @override
  List<Object> get props => [];
}

class AgeChanged extends ProfileEvent {
  final int age;

  AgeChanged({required this.age});

  @override
  List<Object> get props => [];
}

class GenderChanged extends ProfileEvent {
  final String gender;

  GenderChanged({required this.gender});

  @override
  List<Object> get props => [];
}

class InterestedInChanged extends ProfileEvent {
  final String interestedIn;

  InterestedInChanged({required this.interestedIn});

  @override
  List<Object> get props => [];
}

class LocationChanged extends ProfileEvent {
  final GeoPoint location;

  LocationChanged({required this.location});

  @override
  List<Object> get props => [];
}

class Submitted extends ProfileEvent {
  final String name, gender, interestedIn;
  final DateTime age;
  final GeoPoint location;
  final File photo;

  Submitted(this.name, this.gender, this.interestedIn, this.age, this.location,
      this.photo);

  @override
  List<Object> get props => [location, name, age, gender, interestedIn, photo];
}
