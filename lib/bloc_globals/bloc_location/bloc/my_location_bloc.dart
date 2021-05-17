import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState>
    with ChangeNotifier {
  LatLng newPosition;
  String addresName = '';
  MyLocationBloc() : super(MyLocationState());

  StreamSubscription<Position> _positionSubscription;
  void initPositionLocation() async {
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      newPosition = new LatLng(position.latitude, position.longitude);

      add(OnLocationChange(newPosition));
    });
  }

  void disposePositionLocation() {
    this._positionSubscription?.cancel();
  }

  @override
  Stream<MyLocationState> mapEventToState(
    MyLocationEvent event,
  ) async* {
    if (event is OnLocationChange) {
      print(event);
      yield state.copyWith(
          isLocationExist: true, location: event.positionLocation);

      final coordinates =
          new Coordinates(newPosition.latitude, newPosition.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      addresName = addresses.first.featureName;
    }
  }
}

void getAddressFromCoordinates(double lat, double long) async {
  //print("${first.featureName} : ${first.addressLine}");
}

final myLocationBloc = MyLocationBloc();
