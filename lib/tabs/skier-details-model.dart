import 'dart:core';

import 'package:xcp/loader.dart';
import 'package:xcp/models/skier-points.dart';
import 'package:xcp/models/skier-race.dart';
import 'package:xcp/models/skier.dart';
import 'package:mobx/mobx.dart';


part 'skier-details-model.g.dart';

enum RaceFilter {all, distance, sprint}
enum RaceSort {byDate, byCPLPoints,}
enum TimeFilter {none, currentPointsPeriod, lastPublished}

class SkierDetailsModel = _SkierDetailsModel with _$SkierDetailsModel;

abstract class _SkierDetailsModel with Store {

  _SkierDetailsModel(this.skier):
        _races = fetchSkierRaces(skier.id),
        _points = fetchSkierPoints(skier.id),
        _eosPoints = fetchEOSPointsSeries(skier.id);


  final Future _races;
  final Future _points;
  final Future _eosPoints;


  final Skier skier;

  @computed
  ObservableFuture<List<SkierRace>> get raceResults => ObservableFuture(_races);

  @computed
  ObservableFuture<List<SkierPointsSeries>> get points => ObservableFuture(_points);

  @computed
  ObservableFuture<List<SkierEOSPointsSeries>> get eosPoints => ObservableFuture(_eosPoints);

  @observable
  RaceFilter raceFilter = RaceFilter.all;

  @observable
  RaceSort raceSort = RaceSort.byDate;

  @observable
  TimeFilter timeFilter = TimeFilter.none;

  @computed
  List<SkierRace> get filteredResults => raceResults.status == FutureStatus.fulfilled ? getFilteredRaces(raceResults.value) : [];


  List<SkierRace> getFilteredRaces(List<SkierRace> races) {
    final r = races.where((it)=> applyFilter(it)).toList();
    r.sort((r0, r1) => applySort(r0, r1));
    return r;
  }

  bool applyFilter(SkierRace race) {
    DateTime from, to;
    switch(timeFilter){
      case TimeFilter.none:
        from = DateTime(1900,1,1);
        to = DateTime(3000,12,31);
        break;
      case TimeFilter.currentPointsPeriod:
        from = DateTime.now().add(Duration(days:-365));
        to = DateTime.now();
        break;
      case TimeFilter.lastPublished:
        from = DateTime.now().add(Duration(days:-365));
        to = DateTime.now();
        break;
    }

    if (race.date.isBefore(from) || race.date.isAfter(to)) {
      return false;
    }

    switch(raceFilter) {
      case RaceFilter.distance:
        return race.discipline == 'D';
      case RaceFilter.sprint:
        return race.discipline == 'S';
      case RaceFilter.all:
      default:
        return true;
    }
  }

  Comparable applySort(SkierRace r0,SkierRace r1) {
    switch(raceSort){
      case RaceSort.byDate:
        return r1.date.compareTo(r0.date);

      case RaceSort.byCPLPoints:
        return  r1.points.compareTo(r0.points);
      default:
        return  0.compareTo(1);
    }


  }



}
