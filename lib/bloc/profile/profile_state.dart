import 'package:meta/meta.dart';

@immutable
class ProfileState {
  final bool isphotoEmpty;
  final bool isNameEmpty;
  final bool isAgeEmpty;
  final bool isGenderEmpty;
  final bool isInterestedInEmpty;
  final bool isLocationEmpty;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;

  ProfileState(
      {required this.isphotoEmpty,
      required this.isNameEmpty,
      required this.isAgeEmpty,
      required this.isGenderEmpty,
      required this.isInterestedInEmpty,
      required this.isLocationEmpty,
      required this.isSubmitting,
      required this.isFailure,
      required this.isSuccess});

  bool get isFormvalid => (isphotoEmpty &&
      isNameEmpty &&
      isAgeEmpty &&
      isGenderEmpty &&
      isInterestedInEmpty);

  factory ProfileState.empty() => ProfileState(
      isphotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false);

  factory ProfileState.loading() => ProfileState(
      isphotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isFailure: false,
      isSubmitting: true,
      isSuccess: false);

  factory ProfileState.failure() => ProfileState(
      isphotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isFailure: true,
      isSubmitting: false,
      isSuccess: false);

  factory ProfileState.success() => ProfileState(
      isphotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isFailure: false,
      isSubmitting: false,
      isSuccess: true);

  ProfileState update({
    bool isphotoEmpty = true,
    bool isNameEmpty = true,
    bool isAgeEmpty = true,
    bool isGenderEmpty = true,
    bool isInterestedInEmpty = true,
    bool isLocationEmpty = true,
  }) {
    return copywith(isphotoEmpty, isNameEmpty, isAgeEmpty, isGenderEmpty,
        isInterestedInEmpty, isLocationEmpty, false, false, false);
  }

  ProfileState copywith(
    bool isphotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGenderEmpty,
    bool isInterestedInEmpty,
    bool isLocationEmpty,
    bool isFailure,
    bool isSubmitting,
    bool isSuccess,
  ) {
    return ProfileState(
        isphotoEmpty: isphotoEmpty,
        isNameEmpty: isNameEmpty,
        isAgeEmpty: isAgeEmpty,
        isGenderEmpty: isGenderEmpty,
        isInterestedInEmpty: isInterestedInEmpty,
        isLocationEmpty: isLocationEmpty,
        isSubmitting: isSubmitting,
        isFailure: isFailure,
        isSuccess: isSuccess);
  }
}
