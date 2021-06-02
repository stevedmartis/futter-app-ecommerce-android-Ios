part of 'search_places_bloc.dart';

@immutable
class PlacesSearchState {
  final List<PlaceSearch> searchResults;
  PlacesSearchState({this.searchResults});

  PlacesSearchState copyWith({List<PlaceSearch> searchResults}) =>
      PlacesSearchState(
        searchResults: searchResults ?? this.searchResults,
      );
}
