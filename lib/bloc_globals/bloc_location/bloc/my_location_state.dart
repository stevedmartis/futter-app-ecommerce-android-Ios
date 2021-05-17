part of 'my_location_bloc.dart';

@immutable
class MyLocationState {
  final bool following;
  final bool isLocationExist;
  final LatLng location;

  MyLocationState(
      {this.following = true, this.isLocationExist = false, this.location});

  MyLocationState copyWith(
          {bool following, bool isLocationExist, LatLng location}) =>
      MyLocationState(
          following: following ?? this.following,
          isLocationExist: isLocationExist ?? this.isLocationExist,
          location: location ?? this.location);
}
