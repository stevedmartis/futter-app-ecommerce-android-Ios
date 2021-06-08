import 'package:australti_ecommerce_app/models/place_Search.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

class PlaceService with ChangeNotifier {
  Future getAutocomplete(String searchTerm) async {
    // this.authenticated = true;

    final apiKey = 'AIzaSyB0tQN9KhupiyRjtxN6ZsbjryXWJDDRV-M';
    final urlFinal =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchTerm&types=address&language=es_419&components=country:cl&key=$apiKey';

    final resp = await http.get(Uri.parse(urlFinal));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['predictions'] as List;

    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  /*  Future getRoadsAutocomplete(String searchTerm) async {
    // this.authenticated = true;

    final apiKey = 'AIzaSyB0tQN9KhupiyRjtxN6ZsbjryXWJDDRV-M';

    final urlFinal2 =
        'https://roads.googleapis.com/v1/snapToRoads?path=-33.45694, -70.64827|-33.61169, -70.57577&interpolate=true&key=$apiKey';
    final resp = await http.get(Uri.parse(urlFinal2));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['predictions'] as List;

    //return jsonResult.malp((place) => PlaceSearch.fromJson(place)).toList();
  } */

  /*  Future getAutocompleteDetails(String palceId) async {
    // this.authenticated = true;

    final apiKey = 'AIzaSyB0tQN9KhupiyRjtxN6ZsbjryXWJDDRV-M';
    final urlFinal =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$palceId&key=$apiKey';

    final resp = await http.get(Uri.parse(urlFinal));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['result'];

    var jsonGeometryResult = jsonResult['geometry'];

    final sdf = geometryPlaceDetailFromJson(jsonResult.geometry);

    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  } */
}
