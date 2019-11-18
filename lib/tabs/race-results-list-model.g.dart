// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race-results-list-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RaceResultsListModel on _RaceResultsListModel, Store {
  Computed<ObservableFuture<Race>> _$raceComputed;

  @override
  ObservableFuture<Race> get race =>
      (_$raceComputed ??= Computed<ObservableFuture<Race>>(() => super.race))
          .value;
  Computed<ObservableFuture<List<RaceResult>>> _$resultsComputed;

  @override
  ObservableFuture<List<RaceResult>> get results => (_$resultsComputed ??=
          Computed<ObservableFuture<List<RaceResult>>>(() => super.results))
      .value;
}
