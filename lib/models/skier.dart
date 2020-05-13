import 'package:xcp/models/skier-points.dart';

import 'club.dart';


enum PointsListType {lastPublished, rolling}
enum PointsDiscipline {distance, sprint, combined}


class Skier {
  SkierPoints distancePoints = SkierPoints.none;
  SkierPoints sprintPoints =  SkierPoints.none;


  final Club club;

  final int id;
  final String firstname;
  final String lastname;
  final String sex;
  final int yob;


  int get age => DateTime.now().year - yob;

  String get nation => distancePoints?.nation ?? sprintPoints?.nation ?? '';

  String get name => firstname + ' ' + lastname;
  String get nameYob => firstname + ' ' + lastname + ', ' + yob.toString();
  String get clubCountry => club.isNone ? nation : club.name + ', ' + club.province;

  String get searchText => nameYob.toLowerCase()+ clubCountry.toLowerCase();



  SkierPoints  pointsFor(PointsDiscipline pd) {
    switch (pd) {
      case PointsDiscipline.distance:
        return distancePoints;
      case PointsDiscipline.sprint:
        return sprintPoints;
      case PointsDiscipline.combined:
      default:
        return combinedPoints;
    }
  }

List<double> allPointDataFor({PointsDiscipline discipline , PointsListType type} ){
    final skierPts = pointsFor(discipline);
    final pts = type == PointsListType.rolling ?  skierPts.rolling : skierPts.cpl;
    return [pts.total, pts.avg, pts.raceCount * 1.0];
}


  double avgPointsFor(PointsDiscipline pd, PointsListType type) {
    final skierPts = pointsFor(pd);
    final pts = type == PointsListType.rolling ?  skierPts.rolling : skierPts.cpl;
    return pts.avg;
  }

  SkierPoints get combinedPoints  => SkierPoints(
      distancePoints.nation,
      Points(distancePoints.cpl.avg * 0.7 +sprintPoints.cpl.avg * 0.3, distancePoints.cpl.raceCount + sprintPoints.cpl.raceCount),
      Points(distancePoints.rolling.avg * 0.7 +sprintPoints.rolling.avg * 0.3, distancePoints.rolling.raceCount + sprintPoints.rolling.raceCount),
  );

  Skier({this.id, this.firstname, this.lastname, this.sex, this.yob, this.club});

  factory Skier.notInPointsList(int id) {
    return Skier(id: id, firstname: id.toString(), lastname:'New Skier', yob:0, club: Club(id:575));
  }

  factory Skier.fromJson(Map<String, dynamic> json, Map clubs) {
    int id = json['id'] as int,
        currentClubId = json['current_club_id'] as int;

    return Skier(
      id: id,
      club: clubs[currentClubId] ?? Club(),
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      sex: json['sex'] as String,
      yob: json['yob'] as int,
    );
  }

  void updateRolling(PointsDiscipline discipline, Points points) {
    final SkierPoints cp = discipline == PointsDiscipline.distance ? distancePoints : sprintPoints;
    final SkierPoints newPts = SkierPoints.copy(cp);
    newPts.updateRolling(points);
    if (discipline == PointsDiscipline.distance) {
      distancePoints = newPts;
    } else {
      sprintPoints = newPts;
    }


  }


}