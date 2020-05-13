import 'package:xcp/models/skier.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';
import 'package:mobx/mobx.dart';

part 'list-tab-model.g.dart';

const int TAB_POINTS_LIST = 0;
const int TAB_SKIER_DETAILS = 1;
const int TAB_RACE_DETAILS = 2;
const int TAB_LIST_BUILDER = 3;

class ListTabModel = _ListTabModel with _$ListTabModel;

abstract class _ListTabModel with Store {
  _ListTabModel({this.type = 0, this.skier, skierFilter, this.raceId = 0, this.name = ''}) :
    skierFilterContextModel = SkierFilterContextModel(skierFilter:skierFilter);


  final String name;
  final Skier skier;
  final int type;
  final SkierFilterContextModel skierFilterContextModel;
  final int raceId;


  @action
  onTap() {
    skierFilterContextModel.filterExpanded = !skierFilterContextModel.filterExpanded;
  }


  @computed
  String get title => type == TAB_POINTS_LIST
      ? skierFilterContextModel.skierFilter.filterName()
      : name ?? 'Tab';


  @computed
  String get subTitle => type == TAB_POINTS_LIST
      ? skierFilterContextModel.skierFilter.listDescription()
      : '' ;


  @observable
  String description = '';

  @computed
  Map get toJson => {
    'name' : name,
    'race' : raceId,
    'skier': skier?.id,
    'type': type,
    'skierFilter': skierFilterContextModel.skierFilter.toJson
  };




}