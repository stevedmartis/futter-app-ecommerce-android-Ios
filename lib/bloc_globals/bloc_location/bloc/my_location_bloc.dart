import 'dart:async';

import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/bloc_globals/bloc/validators.dart';
import 'package:freeily/models/Address.dart';
import 'package:freeily/models/place_Current.dart';
import 'package:freeily/models/place_Search.dart';
import 'package:freeily/preferences/user_preferences.dart';
import 'package:freeily/responses/stores_list_principal_response.dart';
import 'package:freeily/services/places_service.dart';

import 'package:flutter/material.dart';
import 'package:freeily/services/stores_Services.dart';
import 'package:freeily/store_principal/store_principal_bloc.dart';
//import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends ChangeNotifier {
  final prefs = new AuthUserPreferences();
  LatLng newPosition;
  String addresName = '';
  List<Address> addresses = [];
  bool isLocationCurrent = false;
  Location location = new Location();

  bool isLocationSearch = false;

  final storeService = StoreService();

  PlaceSearch place;

  final placeService = PlaceService();
  final authBloc = AuthenticationBLoC();
  //List<PlaceSearch> _searchResults = [];

  final BehaviorSubject<List<PlaceSearch>> _searchResults =
      BehaviorSubject<List<PlaceSearch>>();

  final BehaviorSubject<String> _numberAddress = BehaviorSubject<String>();

  BehaviorSubject<List<PlaceSearch>> get searchResults => _searchResults;

  BehaviorSubject<String> get numberAddress => _numberAddress;

  StreamSubscription<LocationData> _positionSubscription;

  void initPositionLocation(context) async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    location.onLocationChanged.listen((LocationData currentLocation) {
      print(currentLocation);
      newPosition =
          new LatLng(currentLocation.latitude, currentLocation.longitude);
      getAddressLocation(context, authService.storeAuth.user.uid);
    });
  }

  void disposePositionLocation() {
    this._positionSubscription.cancel();
  }

  getAddressLocation(context, String uid) async {
    final AddressesCurrent resp = await placeService.getAddressByLocation(
        newPosition.latitude.toString(), newPosition.longitude.toString());

    if (resp.results.length > 0) {
      final addressComponent = resp.results[0].addressComponents;

      final addressNumber = addressComponent[0].longName;

      final address = addressComponent[1].longName;

      final addressFinal = '$address, $addressNumber';

      final city = addressComponent[3].longName;

      final commune = addressComponent[2].longName;

      final country = addressComponent[6].longName;

      final comuneCity = '$commune, $city';

      var placeCurrent = new PlaceSearch(
          description: '$addressFinal, $city, $country',
          placeId: addressFinal,
          structuredFormatting: new StructuredFormatting(
              mainText: addressFinal, secondaryText: comuneCity, number: ''));

      addresName = addressFinal;

      prefs.setSearchAddreses = placeCurrent;

      prefs.setLatSearch = newPosition.latitude;
      prefs.setLongSearch = newPosition.longitude;

      prefs.setLocationSearch = true;

      print('location!!');

      getStoresLocationList(context, address, commune, uid);
    }
  }

  getStoresLocationList(context, address, location, uid) async {
    final StoresListResponse resp = await storeService
        .getStoresLocationListServices(address, location, uid);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    if (resp.ok) {
      storeBloc.chargeServicesStores(resp.storeListServices);
    }
  }

  searchPlaces(String searchTerm) async {
    final resp = await placeService.getAutocomplete(searchTerm);

    // final resp2 = await placeService.getAutocompleteDetails(searchTerm);

    _searchResults.sink.add(resp.predictions);
  }

  changeNumberAddress(String value) async {
    // final resp2 = await placeService.getAutocompleteDetails(searchTerm);

    _numberAddress.sink.add(value);
  }

  savePlaceSearchConfirm(PlaceSearch value, String uid) async {
    place = value;

    prefs.setLocationSearch = true;

    prefs.setSearchAddreses = value;

    if (place.placeId != '0' && uid != '0') {
      final editProfileOk = await authBloc.editAddressStoreProfile(
          uid,
          value.structuredFormatting.secondaryText.split(",").first,
          value.structuredFormatting.mainText,
          value.structuredFormatting.number);
      if (editProfileOk != null) {
        if (editProfileOk == true) {
          final resp = await placeService.getAutocompleteDetails(value.placeId);
          prefs.setLatSearch = resp.first;
          prefs.setLongSearch = resp.last;

          notifyListeners();
        }
      }
    } else {
      final resp = await placeService.getAutocompleteDetails(value.placeId);
      prefs.setLatSearch = resp.first;
      prefs.setLongSearch = resp.last;

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _searchResults.close();
    _numberAddress.close();
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
    _privacityController.close();

    _addressController.close();

    _descriptionController.close();
    _priceController.close();

    //  _roomsController?.close();
  }
}

final myLocationBloc = MyLocationBloc();
