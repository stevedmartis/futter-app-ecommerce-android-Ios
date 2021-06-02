class PlaceSearch {
  final String description;
  final String placeId;
  final StructuredFormatting structuredFormatting;
  PlaceSearch({this.description, this.placeId, this.structuredFormatting});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) => PlaceSearch(
        description: json['description'],
        placeId: json['place_id'],
        structuredFormatting:
            StructuredFormatting.fromJson(json["structured_formatting"]),
      );
}

class StructuredFormatting {
  StructuredFormatting(
      {this.mainText,
      this.mainTextMatchedSubstrings,
      this.secondaryText,
      this.number});

  String mainText;
  List<MatchedSubstring> mainTextMatchedSubstrings;
  String secondaryText;
  String number;

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: List<MatchedSubstring>.from(
            json["main_text_matched_substrings"]
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": List<dynamic>.from(
            mainTextMatchedSubstrings.map((x) => x.toJson())),
        "secondary_text": secondaryText,
      };
}

class MatchedSubstring {
  MatchedSubstring({
    this.length,
    this.offset,
  });

  int length;
  int offset;

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
      };
}

/* 

"secondary_text" -> "Arica, Chile" */
