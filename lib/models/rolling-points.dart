import 'dart:collection';

import 'package:xcp/models/skier-points.dart';
import 'package:xcp/models/skier.dart';

class RollingPoints {
  final int skierId;
  final PointsDiscipline discipline;
  final Points points;

  RollingPoints(this.points, {this.skierId, this.discipline});


  static List<RollingPoints>  fromListJson(Map<String, dynamic> json) {

    final r = json['results'];
    final List<int> ids = (r['skier_id'] as List).map((it)=>it as int).toList(growable: false);
    final List<String> disciplines = (r['discipline'] as List).map((it)=> it as String).toList(growable: false);
    final List<double> points = (r['points'] as List).map((it)=>it as double).toList(growable: false);
    final List<int> raceCounts = (r['race_count']  as List).map((it)=>it as int).toList(growable: false);
    int idx = -1;
    return ids.map<RollingPoints>( (it) {
      idx++;
      return RollingPoints(Points(points[idx], raceCounts[idx]),
          skierId: it,
          discipline: disciplines[idx] == 'D' ? PointsDiscipline.distance : PointsDiscipline.sprint);
    }).toList(growable: false);
  }
}
