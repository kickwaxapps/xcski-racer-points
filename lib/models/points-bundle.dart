
import 'dart:collection';

import 'package:app/models/skier-points.dart';

class PointListDetail {
  final int id;
  final String sex;
  final String type;
  final DateTime pubDate;
  final DateTime fromDate;
  final DateTime toDate;
  final int raceCount;
  final String sprintOrDistance;

  PointListDetail({this.id, this.sex, this.type, this.pubDate, this.fromDate, this.toDate, this.raceCount, this.sprintOrDistance});

  factory PointListDetail.fromJson(Map<String, dynamic> json) {
    return PointListDetail(
      id: json['id'] as int,
      sex: json['sex'] as String,
      type: json['type'] as String,
      pubDate: DateTime.parse(json['pub_dt']),
      fromDate: DateTime.parse(json['from_dt']),
      toDate: DateTime.parse(json['to_dt']),
      raceCount: json['race_count'] as int,
      sprintOrDistance: json['sp_dt'] as String
    );
  }
}

class PointsBundle {

  final PointListDetail maleDistance;
  final PointListDetail maleSprint;
  final PointListDetail femaleDistance;
  final PointListDetail femaleSprint;

  final Map distance;
  final Map sprint;

  PointsBundle({this.maleDistance, this.maleSprint, this.femaleDistance, this.femaleSprint, this.distance, this.sprint});

  factory PointsBundle.fromJson(Map<String, dynamic> json) {

    var distancePoints =  (json['D'] as List).map<SkierPoints>((json)=> SkierPoints.fromJson(json));
    var sprintPoints = (json['S'] as List).map<SkierPoints>((json)=> SkierPoints.fromJson(json));

    return PointsBundle( 
      maleDistance: PointListDetail.fromJson(json['l'][0]),
      maleSprint: PointListDetail.fromJson(json['l'][1]),
      femaleDistance: PointListDetail.fromJson(json['l'][2]),
      femaleSprint: PointListDetail.fromJson(json['l'][3]),
      distance: HashMap<int,SkierPoints>.fromIterable(distancePoints, key: (v)=> v.skierId, value: (v)=>v ),
      sprint: HashMap<int,SkierPoints>.fromIterable(sprintPoints, key: (v)=> v.skierId, value: (v)=>v )
    );

  }


}