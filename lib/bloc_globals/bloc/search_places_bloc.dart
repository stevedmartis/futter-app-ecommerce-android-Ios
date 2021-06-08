import 'dart:async';

import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/services/places_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'saerch_places_event.dart';
part 'search_places_state.dart';

class PlacesSearchBloc extends Bloc<MyLocationEvent, PlacesSearchState>
    with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  final placeService = PlaceService();
  List<PlaceSearch> searchResults = [];

  PlacesSearchBloc() : super(PlacesSearchState());

/* 
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      newPosition = new LatLng(position.latitude, position.longitude);

      add(OnLocationChange(newPosition));
    }); */

  @override
  Stream<PlacesSearchState> mapEventToState(
    MyLocationEvent event,
  ) async* {
    if (event is OnPalcesChange) {
      yield state.copyWith();
    }
  }

  void searchPlaces(String searchTerm) async {
    searchResults = await placeService.getAutocomplete(searchTerm);

    add(OnPalcesChange(searchResults));
  }
}

final searchPlacesBloc = PlacesSearchBloc();
