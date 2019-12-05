import 'package:mobx/mobx.dart';


part 'combined-config-model.g.dart';


class CombinedConfigModel = _CombinedConfigModel with _$CombinedConfigModel;

abstract class _CombinedConfigModel with Store {

  @observable
  double factor = 70;

}