import 'package:xcp/models/points-bundle.dart';
import 'package:xcp/models/skier-points.dart';

import 'club.dart';


enum PointsListType {lastPublished, rolling}
enum PointsDiscipline {distance, sprint, combined}


class Skier {
  final SkierPoints distancePoints;
  final SkierPoints sprintPoints;
  final SkierPoints combinedPoints;

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
    final pts = pointsFor(discipline);
    if (type == PointsListType.lastPublished) {
        return [pts.totalPoints, pts.avgPoints, pts.raceCount * 1.0];
    }

    return [pts.rollingTotalPoints, pts.rollingAvgPoints, pts.rollingRaceCount * 1.0];

  }


  double avgPointsFor(PointsDiscipline pd, PointsListType pt) {
    final skierPoints = pointsFor(pd);

    switch (pt) {
      case PointsListType.lastPublished:
        return skierPoints.avgPoints;
      case PointsListType.rolling:
      default:
        return skierPoints.avgPoints;
    }

  }

  Skier({this.id, this.firstname, this.lastname, this.sex, this.yob, this.distancePoints, this.sprintPoints, this.club}):
    combinedPoints = SkierPoints(
        nation: distancePoints.nation,
        skierId: distancePoints.skierId,
        avgPoints: distancePoints.avgPoints * 0.7 +sprintPoints.avgPoints * 0.3,
        totalPoints: distancePoints.totalPoints * 0.7 +sprintPoints.totalPoints * 0.3,
        raceCount: distancePoints.raceCount + sprintPoints.raceCount,
        rollingAvgPoints: distancePoints.rollingAvgPoints * 0.7 + sprintPoints.rollingAvgPoints * 0.3,
        rollingRaceCount: distancePoints.rollingRaceCount + sprintPoints.rollingRaceCount
    )
  ;

  factory Skier.fromJson(Map<String, dynamic> json, PointsBundle points, Map clubs) {
    int id = json['id'] as int,
        currentClubId = json['current_club_id'] as int;

    return Skier(
      id: id,
      distancePoints: points.distance[id] ?? SkierPoints(skierId: id),
      sprintPoints: points.sprint[id] ?? SkierPoints(skierId: id),
      club: clubs[currentClubId] ?? Club(),
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      sex: json['sex'] as String,
      yob: json['yob'] as int,
    );
  }


}