import 'package:app/classes/filter.dart';
import 'package:mobx/mobx.dart';

part 'skier-filter-context-model.g.dart';

class SkierFilterContextModel = _SkierFilterContextModel with _$SkierFilterContextModel;

abstract class _SkierFilterContextModel with Store {
  _SkierFilterContextModel({skierFilter}) :
        this.skierFilter = skierFilter == null ? SkierFilter() : SkierFilter.fromJson(skierFilter);

  @observable
  bool filterExpanded = false;

  @observable
  int selectedSkierId = -1;
  @observable
  SkierFilter skierFilter = SkierFilter();

  @computed
  Map get toJson =>{
        'skierFilter': skierFilter.toJson
  };

}