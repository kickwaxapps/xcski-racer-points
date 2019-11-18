
class RaceResult {
  final int skierId; // the race id
  final int rank;
  final double points;
  final double timeSeconds;

  RaceResult({this.skierId, this.rank, this.points, this.timeSeconds });

  factory RaceResult.fromJson(Map<String, dynamic> json) {
    return RaceResult(
        skierId: json['skier_id'] as int, //
        rank: json['rank'] as int,
        points: json['points'] as double,
        timeSeconds: json['time_seconds'] as double,
    );
  }

  static List<RaceResult>  fromListJson(Map<String, dynamic> json) {
      final r = json['results'] as List;
      return r.map((it)=>RaceResult.fromJson(it)).toList();
  }
}