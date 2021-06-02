part of 'my_location_bloc.dart';

@immutable
class MyLocationState {
  final bool following;
  final bool isLocationCurrent;
  final LatLng location;

  MyLocationState(
      {this.following = true, this.isLocationCurrent = false, this.location});

  MyLocationState copyWith(
          {bool following, bool isLocationCurrent, LatLng location}) =>
      MyLocationState(
          following: following ?? this.following,
          isLocationCurrent: isLocationCurrent ?? this.isLocationCurrent,
          location: location ?? this.location);
}
