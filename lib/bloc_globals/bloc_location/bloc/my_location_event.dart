part of 'my_location_bloc.dart';

@immutable
abstract class MyLocationEvent {}

class OnLocationChange extends MyLocationEvent {
  final LatLng positionLocation;
  OnLocationChange(this.positionLocation);
}

class OnPalcesChange extends MyLocationEvent {
  final List<PlaceSearch> searchResults;

  OnPalcesChange(this.searchResults);
}
