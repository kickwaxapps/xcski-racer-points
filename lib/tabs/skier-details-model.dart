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

  @observable
  DateTime  filterFrom = DateTime(1970,1,1);

  @observable
  DateTime  filterTo = DateTime(2050,1,1);


  @computed
  List<SkierRace> get filteredResults => raceResults.status == FutureStatus.fulfilled ? getFilteredRaces(raceResults.value) : [];


  List<SkierRace> getFilteredRaces(List<SkierRace> races) {
    final r = races.where((it)=> applyFilter(it)).toList();
    r.sort((r0, r1) => applySort(r0, r1));
    return r;
  }

  @action
  setTimeFilter(TimeFilter tf, DateTime fromDt, DateTime toDt) {
    timeFilter = tf;
    filterFrom = fromDt;
    filterTo = toDt;
  }

  bool applyFilter(SkierRace race) {
    if (race.date.isBefore(filterFrom) || race.date.isAfter(filterTo)) {
      return false;
    }

    switch(raceFilter) {
      case RaceFilter.distance:
        return race.discipline == 'D' && race.type != 'ROL';
      case RaceFilter.sprint:
        return race.discipline == 'S' && race.type != 'ROL';
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
