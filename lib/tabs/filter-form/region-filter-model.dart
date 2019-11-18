import 'package:mobx/mobx.dart';

part 'region-filter-model.g.dart';

class RegionFilterModel = _RegionFilterModel with _$RegionFilterModel;

abstract class _RegionFilterModel with Store {

  final String filterValue;
  final String displayValue;

  final List<RegionFilterModel> subRegions = List();

  _RegionFilterModel({this.filterValue, this.displayValue, this.enabled});

  @observable
  bool enabled;

  @action
  void setEabled(bool v){
    enabled = v;
  }

}