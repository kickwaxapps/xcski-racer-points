

import 'package:app/models/race-result.dart';
import 'package:app/models/race.dart';

class SkierRace
 {
   final Race race;
   final RaceResult result;

   int get id => race.id; // the race id
   DateTime get date => race.date;
   String get discipline => race.discipline ; // (S)print or (D)istance
   double get distanceKm => race.distanceKm;
   String get location => race.location;
   String get name => race.name;
   double get points => result.points;
   double get pointsReference => race.pointsReference;
   int get rank => result.rank;
   String get technique => race.technique; //// (S)kate or (C)lassic
   double get timeSeconds => result.timeSeconds;
   String get type => race.type;

  SkierRace({this.race, this.result});

  factory SkierRace.fromJson(Map<String, dynamic> json) {
    return SkierRace(
         race: Race.fromJson(json),
         result: RaceResult.fromJson(json)
    );
  }


  static List<SkierRace> fromRacesJson(Map<String, dynamic> json) {
      final races = json['races'] as List;
      return races.map((it)=>SkierRace.fromJson(it)).toList();
  }


}