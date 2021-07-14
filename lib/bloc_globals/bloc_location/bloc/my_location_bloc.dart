import 'dart:async';

import 'package:australti_ecommerce_app/bloc_globals/bloc/validators.dart';
import 'package:australti_ecommerce_app/models/place_Current.dart';
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

    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
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
      yield state.copyWith(
          isLocationCurrent: true, location: event.positionLocation);

      final AddressesCurrent resp = await placeService.getAddressByLocation(
          newPosition.latitude.toString(), newPosition.longitude.toString());

      if (resp.results.length > 0) {
        final addressComponent = resp.results[0].addressComponents;

        final addressNumber = addressComponent[0].longName;

        final address = addressComponent[1].longName;

        final addressFinal = '$address, $addressNumber';

        final city = addressComponent[2].longName;
        final country = addressComponent[6].longName;

        final countryCode = addressComponent[6].shortName;

        final adminArea = addressComponent[5].longName;

        final newAddress = Address(
            addressLine: '$addressFinal, $city, $country',
            adminArea: adminArea,
            coordinates:
                Coordinates(newPosition.latitude, newPosition.longitude),
            countryCode: countryCode,
            countryName: country,
            featureName: addressFinal,
            locality: city,
            postalCode: null,
            subAdminArea: null,
            subLocality: city,
            subThoroughfare: null,
            thoroughfare: address);

        addresName = addressFinal;

        prefs.setAddreses = newAddress;

        prefs.setLatSearch = newPosition.latitude;
        prefs.setLongSearch = newPosition.longitude;

        prefs.setLocationCurrent = true;
        prefs.setLocationSearch = false;
      }
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
    prefs.setLocationCurrent = false;

    final resp = await placeService.getAutocompleteDetails(value.placeId);

    prefs.setLatSearch = resp.first;
    prefs.setLongSearch = resp.last;

    notifyListeners();
  }

  @override
  void dispose() {
    _searchResults?.close();
    _numberAddress?.close();
    super.dispose();
  }
}

class LocationBloc with Validators {
  final _addressController = BehaviorSubject<String>();

  final _descriptionController = BehaviorSubject<String>();

  final _privacityController = BehaviorSubject<bool>();

  final _priceController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get addressStream =>
      _addressController.stream.transform(validationAddressRequired);
  Stream<String> get descriptionStream => _descriptionController.stream;

  // Insertar valores al Stream
  Function(String) get changeAddress => _addressController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  Stream<bool> get privacityStream => _privacityController.stream;

  Stream<String> get priceSteam => _priceController.stream;

  Function(String) get changePrice => _priceController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get name => _addressController.value;
  String get description => _descriptionController.value;
  bool get privacity => _privacityController.value;
  String get price => _priceController.value;

  dispose() {
    _privacityController?.close();

    _addressController?.close();

    _descriptionController?.close();
    _priceController?.close();

    //  _roomsController?.close();
  }
}

final myLocationBloc = MyLocationBloc();
