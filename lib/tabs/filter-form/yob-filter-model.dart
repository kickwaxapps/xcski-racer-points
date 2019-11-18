import 'package:mobx/mobx.dart';

part 'yob-filter-model.g.dart';

class YOBFilterModel = _YOBFilterModel with _$YOBFilterModel;

abstract class _YOBFilterModel with Store {

  final int filterValue;
  final String displayValue;

  _YOBFilterModel({this.filterValue, this.displayValue, this.enabled = false});

  @observable
  bool enabled;


}