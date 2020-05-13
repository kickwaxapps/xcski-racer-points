

class Points{
  final double avg;
  final int raceCount;
  double get total => avg * raceCount;
  Points(this.avg, this.raceCount);

  static Points none = Points(0,0);
}

class SkierPoints {
  final String nation;
  Points rolling = Points.none;
  final Points cpl;
  SkierPoints(this.nation,  this.cpl, this.rolling);

  factory SkierPoints.copy(SkierPoints cp) {
    return SkierPoints(cp.nation,
        Points(cp.cpl.avg, cp.cpl.raceCount),
        Points(cp.rolling.avg, cp.rolling.raceCount));
  }
  factory SkierPoints.fromJson(Map<String, dynamic> json) {
    return SkierPoints(
      json['nation'] as String,
      Points(json['avg_points'] as double, json['race_count'] as int),
      Points(json['rolling_avg_points'] as double, json['rolling_race_count'] as int),
    );
  }

  updateRolling(Points points) {
    if (points.avg != rolling.avg) {
      rolling = Points(points.avg, points.raceCount);
    }
  }

  static SkierPoints none =  SkierPoints('',Points.none, Points.none);

}



enum Discipline {sprint, distance}

class  SkierPointsSeries {
  final DateTime date;
  final double points;
  final int raceCount;
  final Discipline discipline;
  SkierPointsSeries({this.date, this.points, this.raceCount, this.discipline});

  factory SkierPointsSeries.fromJson(Map<String, dynamic> json) {
    if ((json['race_id'] as int) >-1) return null;
    return SkierPointsSeries(
      date: DateTime.parse(json['date'] as String),
      points: json['points'] as double,
      raceCount: json['race_count'] as int,
      discipline: ( json['sp_dt'] as String == 'D') ? Discipline.distance : Discipline.sprint
    );
  }

  static List<SkierPointsSeries> fromListJson(Map<String, dynamic> json) {
    final races = json['results'] as List;
    return races.map((it)=>SkierPointsSeries.fromJson(it)).where((it) => it != null).toList();
  }
}

class SkierEOSPointsSeries {
  final Discipline discipline;
  final int age;
  final double points;

  SkierEOSPointsSeries({this.age, this.points, this.discipline});

  factory SkierEOSPointsSeries.from(Discipline discipline,  List data) {
    return SkierEOSPointsSeries(discipline: discipline, age: data[0] as int , points: data[1] as double);
  }

  static List<SkierEOSPointsSeries> fromListJson(Map<String, dynamic> json) {
    final r = json['results'];
    final spts  = r['sprint'] as List;
    final dpts  = r['distance'] as List;

    return [...spts.map((it)=>SkierEOSPointsSeries.from(Discipline.sprint, it)).toList(),
            ...dpts.map((it)=>SkierEOSPointsSeries.from(Discipline.distance, it)).toList()];
  }

}



