import 'dart:convert';

import 'package:australti_ecommerce_app/models/Address.dart';
import 'package:australti_ecommerce_app/models/grocery_Store.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/responses/place_search_response.dart';

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

  get followed {
    return _prefs.getInt('followed') ?? 0;
  }

  set followed(int value) {
    _prefs.setInt('followed', value);
  }

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  set setToken(String value) {
    _prefs.setString('token', value);
  }

  get token {
    return _prefs.getString('token') ?? "";
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
    final location =
        place.structuredFormatting.secondaryText.toString().split(",").first;
    Map<String, dynamic> map = {
      'description': place.description,
      'placeId': place.placeId,
      'mainText': place.structuredFormatting.mainText,
      'secondaryText': location,
      'number': place.structuredFormatting.number
    };

    String rawJson = jsonEncode(map);

    _prefs.setString('placeSearch', jsonEncode(rawJson));
  }

  get addressSearchSave {
    final placeSearch = _prefs.getString('placeSearch') ?? '';

    if (placeSearch != '') {
      final place = json.decode(_prefs.getString('placeSearch') ?? '');

      final PlacesSearch fromjson = placeSearchFromJson(place);

      return fromjson;
    } else {
      return placeSearch;
    }
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

  set setPyamentMethodCashOption(bool value) {
    _prefs.setBool('cashOption', value);
  }

  get pyamentMethodCashOption {
    return _prefs.getBool('cashOption') ?? false;
  }

  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }
}
