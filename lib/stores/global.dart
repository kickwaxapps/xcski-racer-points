/// cmd:     flutter packages pub run build_runner watch --delete-conflicting-outputs

import 'package:xcp/classes/filter.dart';
import 'package:xcp/models/bundle.dart';
import 'package:xcp/loader.dart';
import 'package:xcp/models/skier.dart';
import 'package:mobx/mobx.dart';

part 'global.g.dart';

class GlobalStore = _Global with _$GlobalStore;


abstract class _Global with Store {
  _Global() {
    loadBundle();
  }


  Future<List<Skier>>  filterResults(SkierFilter filter) async {
    return await filter.results( bundle.value != null
                      ? bundle.value.skiers.values.toList()
            : List<Skier>());
  }


  @observable
  ObservableFuture<Bundle> bundle;

  @action
  void loadBundle({forceReload: false}) {
    bundle = ObservableFuture(fetchBundle(forceReload));
  }

  List<Skier> get skiers => bundle.value.skiers.values.toList();

  @observable
  Function addFreeFormListBuilder;
}
