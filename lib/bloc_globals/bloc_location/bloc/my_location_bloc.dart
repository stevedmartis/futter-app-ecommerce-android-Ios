import 'dart:async';

import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/services/places_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState>
    with ChangeNotifier {
  final prefs = new AuthUserPreferences();
  LatLng newPosition;
  String addresName = '';
  List<Address> addresses = [];
  bool isLocationCurrent = false;

  bool isLocationSearch = false;

  PlaceSearch place;

  final placeService = PlaceService();
  //List<PlaceSearch> _searchResults = [];

  final BehaviorSubject<List<PlaceSearch>> _searchResults =
      BehaviorSubject<List<PlaceSearch>>();

  final BehaviorSubject<String> _numberAddress = BehaviorSubject<String>();

  BehaviorSubject<List<PlaceSearch>> get searchResults => _searchResults;

  BehaviorSubject<String> get numberAddress => _numberAddress;

  MyLocationBloc() : super(MyLocationState());

  StreamSubscription<Position> _positionSubscription;
  void initPositionLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      newPosition = new LatLng(position.latitude, position.longitude);

      add(OnLocationChange(newPosition));
    });

/* 
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      newPosition = new LatLng(position.latitude, position.longitude);

      add(OnLocationChange(newPosition));
    }); */
  }

  void disposePositionLocation() {
    this._positionSubscription?.cancel();
  }

  @override
  Stream<MyLocationState> mapEventToState(
    MyLocationEvent event,
  ) async* {
    if (event is OnLocationChange) {
      yield state.copyWith(
          isLocationCurrent: true, location: event.positionLocation);

      final coordinates =
          new Coordinates(newPosition.latitude, newPosition.longitude);
      addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      addresName = addresses.first.featureName;
      isLocationCurrent = true;
      prefs.setAddreses = addresses[0];

      prefs.setLocationCurrent = true;
    }
  }

  searchPlaces(String searchTerm) async {
    final resp = await placeService.getAutocomplete(searchTerm);

    // final resp2 = await placeService.getAutocompleteDetails(searchTerm);

    _searchResults.sink.add(resp);
  }

  changeNumberAddress(String value) async {
    // final resp2 = await placeService.getAutocompleteDetails(searchTerm);

    _numberAddress.sink.add(value);
  }

  savePlaceSearchConfirm(PlaceSearch value) async {
    place = value;
    isLocationSearch = true;
    prefs.setLocationSearch = true;
    prefs.setSearchAddreses = value;

    final resp = await placeService.getAutocompleteDetails(value.placeId);

    print(resp);

    prefs.setLatSearch = resp.first;
    prefs.setLongSearch = resp.last;

    print(prefs.latSearch);

    notifyListeners();
  }

  @override
  void dispose() {
    _searchResults?.close();
    _numberAddress?.close();
    super.dispose();
  }
}

final myLocationBloc = MyLocationBloc();
