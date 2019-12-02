import 'package:xcp/classes/filter.dart';
import 'package:xcp/models/skier.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import 'region-filter-model.dart';
import 'yob-filter-model.dart';

part 'filter-model.g.dart';




class FilterModel = _FilterModel with _$FilterModel;

abstract class _FilterModel with Store {
  _FilterModel(SkierFilter skierFilter):
        searchStringController = TextEditingController(text:skierFilter.searchString);

  final TextEditingController  searchStringController ;

  @observable
  bool filterOpen;

  @observable
  PointsListType pointsListType = PointsListType.lastPublished;

  @observable
  PointsDiscipline pointDiscipline = PointsDiscipline.distance;


  @observable
  int sex = 0;

  @observable
  ObservableList yobs = ObservableList<YOBFilterModel>();
  
  @observable
  ObservableList nations = ObservableList<RegionFilterModel>();

  @observable
  ObservableList regions = ObservableList<RegionFilterModel>();


  @observable
  String searchString = '';

  @action
  void setSearchString(String v){
    searchString = v;
  }

  @action
  clear() {
    searchStringController.clear();
    pointsListType = PointsListType.lastPublished;
    pointDiscipline = PointsDiscipline.distance;
    searchString = '';
    sex = 0;
    yobs.forEach((it)=> it.enabled = false);
    nations.forEach((it)=> it.enabled = false);
    regions.forEach((it)=> it.enabled = false);
  }

  @override
  void dispose() {
    print('BYE BYE');
    searchStringController.dispose();
  }


}