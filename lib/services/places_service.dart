import 'package:australti_ecommerce_app/models/place_Search.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

class PlaceService with ChangeNotifier {
  Future getAutocomplete(String searchTerm) async {
    // this.authenticated = true;

    final apiKey = 'AIzaSyD_lFpA7YI75XFW12HdnpS32Y8q3k-v31Q';
    final urlFinal =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchTerm&types=address&language=es_419&components=country:cl&key=$apiKey';

    final resp = await http.get(Uri.parse(urlFinal));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['predictions'] as List;

    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future getRoadsAutocomplete(String searchTerm) async {
    // this.authenticated = true;

    final apiKey = 'AIzaSyD_lFpA7YI75XFW12HdnpS32Y8q3k-v31Q';

    final urlFinal2 =
        'https://roads.googleapis.com/v1/snapToRoads?path=-33.45694, -70.64827|-33.61169, -70.57577&interpolate=true&key=$apiKey';
    final resp = await http.get(Uri.parse(urlFinal2));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['predictions'] as List;

    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future getAutocompleteDetails(String palceId) async {
    // this.authenticated = true;

    final apiKey = 'AIzaSyD_lFpA7YI75XFW12HdnpS32Y8q3k-v31Q';
    final urlFinal =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$palceId&key=$apiKey';

    final resp = await http.get(Uri.parse(urlFinal));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['result'];

    print(jsonResult);

    var jsonGeometryResult = jsonResult['geometry'];

    print(jsonGeometryResult);

    final location = jsonGeometryResult['location'];

    print(location);
    final latitude = location['lat'];

    final longitude = location['lng'];

    print(latitude);

    print(longitude);

    return {latitude, longitude};

    //final sdf = geometryPlaceDetailFromJson(jsonResult.geometry);

    //return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}
