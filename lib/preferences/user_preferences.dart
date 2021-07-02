import 'dart:convert';

import 'package:australti_ecommerce_app/models/grocery_Store.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/responses/place_search_response.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUserPreferences {
  static final AuthUserPreferences _instance =
      new AuthUserPreferences._internal();

  factory AuthUserPreferences() {
    return _instance;
  }

  AuthUserPreferences._internal();

  SharedPreferences _prefs;

  LatLng newPosition;
  String addresName = '';
  List<Address> addresses = [];
  bool isLocationCurrent = false;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  set setToken(String value) {
    _prefs.setString('token', value);
  }

  get token {
    return _prefs.getString('token') ?? "";
  }

  set setAddreses(Address address) {
    Map<String, dynamic> map = {
      'locality': address.locality,
      'featureName': address.featureName,
      'countryName': address.countryName,
      'adminArea': address.adminArea
    };
    String rawJson = jsonEncode(map);

    _prefs.setString('address', jsonEncode(rawJson));
  }

  get addressSave {
    final address = json.decode(_prefs.getString('address') ?? '');
    return jsonDecode(address);
  }

  set setLocationCurrent(bool isCurrent) {
    _prefs.setBool('locationCurrent', isCurrent);
  }

  get locationCurrent {
    return _prefs.getBool('locationCurrent') ?? false;
  }

  set setLocationSearch(bool value) {
    _prefs.setBool('locationSearch', value);
  }

  get locationSearch {
    return _prefs.getBool('locationSearch') ?? false;
  }

  set setLongSearch(double long) {
    _prefs.setDouble('longitude', long);
  }

  get longSearch {
    return _prefs.getDouble('longitude') ?? 0.0;
  }

  set setLatSearch(double lat) {
    _prefs.setDouble('latitude', lat);
  }

  get latSearch {
    return _prefs.getDouble('latitude') ?? 0.0;
  }

  set setSearchAddreses(PlaceSearch place) {
    Map<String, dynamic> map = {
      'description': place.description,
      'placeId': place.placeId,
      'mainText': place.structuredFormatting.mainText,
      'secondaryText': place.structuredFormatting.secondaryText,
      'number': place.structuredFormatting.number
    };

    String rawJson = jsonEncode(map);

    _prefs.setString('placeSearch', jsonEncode(rawJson));
  }

  get addressSearchSave {
    final place = json.decode(_prefs.getString('placeSearch') ?? '');

    final fromjson = placeSearchFromJson(place);

    return fromjson;
  }

  set setCart(List<GroceryProductItem> cart) {
    final cartSave = cartProductsToJson(cart);

    _prefs.setString('cart', cartSave);
  }

  get getCart {
    final list = _prefs.getString('cart') ?? '';

    final cart = cartProductsFromJson(list);

    // GroceryProductItem.decode(cart);

    return cart;
  }

  // GET y SET del Genero
  get genero {
    return _prefs.getInt('genero') ?? 1;
  }

  set genero(int value) {
    _prefs.setInt('genero', value);
  }

  // GET y SET del _colorSecundario
  get colorSecundario {
    return _prefs.getBool('colorSecundario') ?? false;
  }

  set colorSecundario(bool value) {
    _prefs.setBool('colorSecundario', value);
  }

  // GET y SET del nombreUsuario
  get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario(String value) {
    _prefs.setString('nombreUsuario', value);
  }

  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }
}
