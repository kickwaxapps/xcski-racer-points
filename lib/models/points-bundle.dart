

import 'package:xcp/models/rolling-points.dart';
import 'package:xcp/models/skier-points.dart';
import 'package:xcp/models/skier.dart';

class PointListDetail {
  final int id;
  final String sex;
  final String type;
  final String title;
  final DateTime pubDate;
  final DateTime fromDate;
  final DateTime toDate;
  final int raceCount;
  final String sprintOrDistance;

  PointListDetail({this.id, this.sex, this.type, this.title, this.pubDate, this.fromDate, this.toDate, this.raceCount, this.sprintOrDistance});

  factory PointListDetail.fromJson(Map<String, dynamic> json) {
    return PointListDetail(
      id: json['id'] as int,
      sex: json['sex'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
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

  int get hash => maleSprint.id + maleDistance.id + femaleSprint.id + femaleDistance.id;

  Map<int, RollingPoints> _rollingPoints;


  PointsBundle({this.maleDistance, this.maleSprint, this.femaleDistance, this.femaleSprint, this.distance, this.sprint});

  factory PointsBundle.fromJson(Map<String, dynamic> json, Map<int, Skier> skiers) {


    final D = json['D'];
    final bindPoints = (Map<String, dynamic> json, Function(int id, String n, double pt, int cnt) fn ) {
      final ids = json['skier_id'] as List;
      final nations = json['nation'] as List;
      final pts = json['avg_points'] as List;
      final totals = json['total_points'] as List;
      final counts = json['race_count'] as List;

      for (int i = 0; i < ids.length; i++) {
        final int skierId = ids[i] as int;
        final String nation = nations[i] as String;
        final double pt = pts[i] as double;
        final double total = totals[i] as double;
        final int count = counts[i] as int;
        fn(skierId, nation, pt, count);
      }
    };

    bindPoints(json['D'], (id, n,pt,cnt){
      skiers[id].distancePoints = SkierPoints(n,Points(pt,cnt), Points.none);
    });

    bindPoints(json['S'], (id, n,pt,cnt){
      skiers[id].sprintPoints = SkierPoints(n,Points(pt,cnt), Points.none);
    });


    return PointsBundle( 
      maleDistance: PointListDetail.fromJson(json['l'][0]),
      maleSprint: PointListDetail.fromJson(json['l'][1]),
      femaleDistance: PointListDetail.fromJson(json['l'][2]),
      femaleSprint: PointListDetail.fromJson(json['l'][3]),
    );
  }

  setRollingPoints(Map value) {
    _rollingPoints = value;
  }


}