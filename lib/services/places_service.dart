import 'dart:convert';

import 'package:freeily/models/place_Current.dart';
import 'package:freeily/models/place_Search.dart';
import 'package:freeily/responses/google_maps_autocomplete.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:freeily/global/enviroments.dart';

class PlaceService with ChangeNotifier {
  final apiKey = 'AIzaSyD_lFpA7YI75XFW12HdnpS32Y8q3k-v31Q';

  Future<GoogleMapsAutoComplete> getAutocomplete(String searchTerm) async {
    // this.authenticated = true;

    final urlFinal =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchTerm&types=address&language=es_419&components=country:cl&key=$apiKey';

    final placesResponse = await getAutocompleteApi(urlFinal);

    var response = googleMapsAutoCompleteFromJson(placesResponse.body);

    print(response);
    return response;
  }

  Future getAutocompleteApi(String urlFinal) async {
    // this.authenticated = true;

    final data = {'urlFinal': urlFinal};
    final resp = await http.post(
        Uri.parse('${Environment.apiUrl}/api/google-maps/autocomplete'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    print(resp);
    return resp;
  }

  Future getRoadsAutocomplete(String searchTerm) async {
    // this.authenticated = true;

    final urlFinal2 =
        'https://roads.googleapis.com/v1/snapToRoads?path=-33.45694, -70.64827|-33.61169, -70.57577&interpolate=true&key=$apiKey';
    final resp = await http.get(Uri.parse(urlFinal2));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['predictions'] as List;

    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future getAddressByLocation(String long, String lat) async {
    // this.authenticated = true;

    final urlFinal2 =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$long,$lat&sensor=true&key=$apiKey';
    final resp = await http.get(Uri.parse(urlFinal2));

    var jsonResult = addressCurrentFromJson(resp.body);

    return jsonResult;
  }

  Future getAutocompleteDetails(String palceId) async {
    // this.authenticated = true;

    final urlFinal =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$palceId&key=$apiKey';

    final resp = await http.get(Uri.parse(urlFinal));

    var json = convert.jsonDecode(resp.body);

    var jsonResult = json['result'];

    var jsonGeometryResult = jsonResult['geometry'];

    final location = jsonGeometryResult['location'];

    final latitude = location['lat'];

    final longitude = location['lng'];

    return {latitude, longitude};

    //final sdf = geometryPlaceDetailFromJson(jsonResult.geometry);

    //return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}
