import 'dart:convert' show json;

import 'package:freeily/pages/get_phone/data_models/country.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show TextEditingController, debugPrint;

class CountryProvider with ChangeNotifier {
  /// loading countries data from json
  /// setting up listeners
  ///

  List<Country> _countries = [];

  List<Country> get countries => _countries;

//  set countries(List<Country> value) {
//    _countries = value;
//    notifyListeners();
//  }

  List<Country> _searchResults = [];

  List<Country> get searchResults => _searchResults;

  set searchResults(List<Country> value) {
    _searchResults = value;

    notifyListeners();
  }

  Country _selectedCountry = Country();

  Country get selectedCountry => _selectedCountry;

  set selectedCountry(Country value) {
    _selectedCountry = value;
    notifyListeners();
  }

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  Future loadCountriesFromJSON() async {
    try {
      if (countries.length <= 0) {
        var _file =
            await rootBundle.loadString('data/country_phone_codes.json');
        var _countriesJson = json.decode(_file);
        List<Country> _listOfCountries = [];
        for (var country in _countriesJson) {
          _listOfCountries.add(Country.fromJson(country));
        }
        _countries = _listOfCountries;
        notifyListeners();
        // Selecting India
        selectedCountry = _listOfCountries[100];
        searchResults = _listOfCountries;
      }
    } catch (err) {
      debugPrint("Unable to load countries data");
      throw err;
    }
  }

  void resetSearch() {
    searchResults = countries;
  }
}
