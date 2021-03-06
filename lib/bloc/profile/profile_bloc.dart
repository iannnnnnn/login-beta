import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_course/repositories/userRepository.dart';
import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileState.empty());

  @override
  ProfileState get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await userRepository.getUser();
      yield* _mapSubmittedToState(event.photo, event.gender, event.name, uid,
          event.age, event.location, event.interestedIn);
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String? name) async* {
    yield state.update(isNameEmpty: name == null);
  }

  Stream<ProfileState> _mapPhotoChangedToState(File? photo) async* {
    yield state.update(isphotoEmpty: photo == null);
  }

  Stream<ProfileState> _mapAgeChangedToState(int? age) async* {
    yield state.update(isAgeEmpty: age == null);
  }

  Stream<ProfileState> _mapGenderChangedToState(String? gender) async* {
    yield state.update(isGenderEmpty: gender == null);
  }

  Stream<ProfileState> _mapInterestedInChangedToState(
      String? interestedIn) async* {
    yield state.update(isInterestedInEmpty: interestedIn == null);
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint? location) async* {
    yield state.update(isLocationEmpty: location == null);
  }

  Stream<ProfileState> _mapSubmittedToState(
      File photo,
      String gender,
      String name,
      String userId,
      DateTime age,
      GeoPoint location,
      String interestedIn) async* {
    yield ProfileState.loading();
    try {
      await userRepository.profileSetUp(
          photo, userId, name, gender, interestedIn, age, location);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
