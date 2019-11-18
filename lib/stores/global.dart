/// cmd:     flutter packages pub run build_runner watch --delete-conflicting-outputs

import 'package:app/classes/filter.dart';
import 'package:app/models/bundle.dart';
import 'package:app/loader.dart';
import 'package:app/models/skier.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'global.g.dart';

class GlobalStore = _Global with _$GlobalStore;


abstract class _Global with Store {
  _Global() {
    loadBundle();
  }


  Future<List<Skier>> filterResults(SkierFilter filter) {
    return compute(
        filter.results,
        bundle.value != null
            ? bundle.value.skiers.values.toList()
            : List<Skier>());
  }

  @observable
  ObservableFuture<Bundle> bundle;

  @action
  void loadBundle() {
    bundle = ObservableFuture(fetchBundle());
  }
}
