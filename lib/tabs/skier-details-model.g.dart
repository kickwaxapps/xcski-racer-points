// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skier-details-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SkierDetailsModel on _SkierDetailsModel, Store {
  Computed<ObservableFuture<List<SkierRace>>> _$raceResultsComputed;

  @override
  ObservableFuture<List<SkierRace>> get raceResults =>
      (_$raceResultsComputed ??= Computed<ObservableFuture<List<SkierRace>>>(
              () => super.raceResults))
          .value;
  Computed<ObservableFuture<List<SkierPointsSeries>>> _$pointsComputed;

  @override
  ObservableFuture<List<SkierPointsSeries>> get points =>
      (_$pointsComputed ??= Computed<ObservableFuture<List<SkierPointsSeries>>>(
              () => super.points))
          .value;
  Computed<ObservableFuture<List<SkierEOSPointsSeries>>> _$eosPointsComputed;

  @override
  ObservableFuture<List<SkierEOSPointsSeries>> get eosPoints =>
      (_$eosPointsComputed ??=
              Computed<ObservableFuture<List<SkierEOSPointsSeries>>>(
                  () => super.eosPoints))
          .value;
  Computed<List<SkierRace>> _$filteredResultsComputed;

  @override
  List<SkierRace> get filteredResults => (_$filteredResultsComputed ??=
          Computed<List<SkierRace>>(() => super.filteredResults))
      .value;

  final _$raceFilterAtom = Atom(name: '_SkierDetailsModel.raceFilter');

  @override
  RaceFilter get raceFilter {
    _$raceFilterAtom.context.enforceReadPolicy(_$raceFilterAtom);
    _$raceFilterAtom.reportObserved();
    return super.raceFilter;
  }

  @override
  set raceFilter(RaceFilter value) {
    _$raceFilterAtom.context.conditionallyRunInAction(() {
      super.raceFilter = value;
      _$raceFilterAtom.reportChanged();
    }, _$raceFilterAtom, name: '${_$raceFilterAtom.name}_set');
  }

  final _$raceSortAtom = Atom(name: '_SkierDetailsModel.raceSort');

  @override
  RaceSort get raceSort {
    _$raceSortAtom.context.enforceReadPolicy(_$raceSortAtom);
    _$raceSortAtom.reportObserved();
    return super.raceSort;
  }

  @override
  set raceSort(RaceSort value) {
    _$raceSortAtom.context.conditionallyRunInAction(() {
      super.raceSort = value;
      _$raceSortAtom.reportChanged();
    }, _$raceSortAtom, name: '${_$raceSortAtom.name}_set');
  }

  final _$timeFilterAtom = Atom(name: '_SkierDetailsModel.timeFilter');

  @override
  TimeFilter get timeFilter {
    _$timeFilterAtom.context.enforceReadPolicy(_$timeFilterAtom);
    _$timeFilterAtom.reportObserved();
    return super.timeFilter;
  }

  @override
  set timeFilter(TimeFilter value) {
    _$timeFilterAtom.context.conditionallyRunInAction(() {
      super.timeFilter = value;
      _$timeFilterAtom.reportChanged();
    }, _$timeFilterAtom, name: '${_$timeFilterAtom.name}_set');
  }
}
