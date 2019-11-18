class Province {
final String abbrev;

  Province({this.abbrev});

  factory Province.fromJson(dynamic json) {
    return Province(
      abbrev: json['province'] as String
    );
  }
}
