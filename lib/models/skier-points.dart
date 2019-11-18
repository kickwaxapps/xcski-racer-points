class SkierPoints {
  final double avgPoints;
  final String nation;
  final int raceCount;
  final double rollingTotalPoints;
  final double rollingAvgPoints;
  final int rollingRaceCount;
  final int skierId;
  final double totalPoints;

  SkierPoints({this.avgPoints=0, this.nation='', this.raceCount=0, this.rollingAvgPoints=0,  this.rollingTotalPoints = 0, this.rollingRaceCount=0, this.skierId, this.totalPoints=0});

  factory SkierPoints.fromJson(Map<String, dynamic> json) {
    return SkierPoints(
      avgPoints: json['avg_points'] as double,
      nation: json['nation'] as String,
      raceCount: json['race_count'] as int,
      rollingAvgPoints: json['rolling_avg_points'] as double,
      rollingTotalPoints:  (json['rolling_avg_points']as double) * (json['rolling_race_count'] as int),
      rollingRaceCount: json['rolling_race_count'] as int,
      skierId: json['skier_id'] as int,
      totalPoints: json['total_points'] as double
    );
  }
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



