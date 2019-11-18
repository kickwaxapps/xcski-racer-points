import 'package:mobx/mobx.dart';


part 'points-list-model.g.dart';


class PointsListModel = _PointsListModel with _$PointsListModel;

abstract class _PointsListModel with Store {

  @observable
  bool filterExpanded = false
  ;

}