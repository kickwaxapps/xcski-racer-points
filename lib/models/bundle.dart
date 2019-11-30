import 'dart:collection';

import 'package:xcp/models/points-bundle.dart';

import 'package:xcp/models/club.dart';
import 'package:xcp/models/nation.dart';
import 'package:xcp/models/province.dart';
import 'package:xcp/models/skier.dart';

class Bundle {
  Map<int, Club> clubs;
  List<Nation> nations;
  List<Province> regions;
  Map<int, Skier>  skiers;
  PointsBundle points;
  List<int> males;
  List<int> females;

  Bundle({this.clubs, this.nations, this.regions, this.skiers, this.females, this.males, this.points} );

  factory Bundle.fromJson(Map<String, dynamic> json) {

    final clubs = HashMap<int,Club>.fromIterable((json['clubs'] as List).map( (it) => Club.fromJson(it)), key: (v)=> v.id, value: (v)=>v );
    final points = PointsBundle.fromJson(json['currentPoints']);
    var skiers = (json['skiers'] as List).map( (it) => Skier.fromJson(it, points, clubs)).toList();

    return Bundle(
      clubs: clubs,
      nations: (json['nations'] as List).map( (it) => Nation.fromJson(it) ).toList(),
      regions: (json['regions'] as List).map( (it) => Province.fromJson(it) ).toList(),
      skiers: HashMap<int,Skier>.fromIterable(skiers, key: (v)=> v.id, value: (v)=>v ),
      points: points

    );
  }
}