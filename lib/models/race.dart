

class Race {
  final int id; // the race id
  final String name;
  final String sex;
  final String categories;
  final String description;
  final DateTime date;
  final String discipline; // (S)print or (D)istance 
  final double distanceKm;
  final String location;
  final double pointsReference;
  final String technique; //// (S)kate or (C)lassic
  final String type;

  Race({this.id, this.date, this.discipline, this.distanceKm, this.description,
      this.location, this.name,  this.pointsReference,
      this.technique, this.type, this.sex, this.categories});

  factory Race.fromJson(Map<String, dynamic> json) {
   return  Race(
        id: json['id'] as int, // the race id
        date: DateTime.parse(json['date'] as String),
        categories: json['categories'] as String,
        description: json['description'] as String,
        discipline: json['discipline'] as String,
        distanceKm: json['distance_km'] as double,
        location: json['location'] as String,
        name: json['name'] as String,
        pointsReference: json['points_reference'] as double,
        technique: json['technique'] as String,
        type: json['type'] as String,
        sex: json['sex'] as String
    );
  }


  toString() => '$id $name';

}