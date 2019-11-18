class Nation {
final String abbrev;

  Nation({this.abbrev});

  factory Nation.fromJson(Map<String, dynamic> json) {
    return Nation(
      abbrev: json['abbrev'] as String
    );
  }
}
