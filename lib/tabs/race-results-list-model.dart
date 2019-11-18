import 'package:app/loader.dart';
import 'package:app/models/race-result.dart';
import 'package:app/models/race.dart';
import 'package:mobx/mobx.dart';


part 'race-results-list-model.g.dart';


class RaceResultsListModel = _RaceResultsListModel with _$RaceResultsListModel;

abstract class _RaceResultsListModel with Store {
  _RaceResultsListModel(this.raceId) :
        _race = fetchRaceDetails(raceId),
        _results = fetchRaceResults(raceId);

      final Future<Race> _race;
      final Future<List<RaceResult>> _results;


  final int raceId;

  @computed
  ObservableFuture<Race> get race => ObservableFuture(_race);

  @computed
  ObservableFuture<List<RaceResult>> get results => ObservableFuture(_results);

}