// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skier-filter-context-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SkierFilterContextModel on _SkierFilterContextModel, Store {
  Computed<Map> _$toJsonComputed;

  @override
  Map get toJson =>
      (_$toJsonComputed ??= Computed<Map>(() => super.toJson)).value;

  final _$filterExpandedAtom =
      Atom(name: '_SkierFilterContextModel.filterExpanded');

  @override
  bool get filterExpanded {
    _$filterExpandedAtom.context.enforceReadPolicy(_$filterExpandedAtom);
    _$filterExpandedAtom.reportObserved();
    return super.filterExpanded;
  }

  @override
  set filterExpanded(bool value) {
    _$filterExpandedAtom.context.conditionallyRunInAction(() {
      super.filterExpanded = value;
      _$filterExpandedAtom.reportChanged();
    }, _$filterExpandedAtom, name: '${_$filterExpandedAtom.name}_set');
  }

  final _$selectedSkierIdAtom =
      Atom(name: '_SkierFilterContextModel.selectedSkierId');

  @override
  int get selectedSkierId {
    _$selectedSkierIdAtom.context.enforceReadPolicy(_$selectedSkierIdAtom);
    _$selectedSkierIdAtom.reportObserved();
    return super.selectedSkierId;
  }

  @override
  set selectedSkierId(int value) {
    _$selectedSkierIdAtom.context.conditionallyRunInAction(() {
      super.selectedSkierId = value;
      _$selectedSkierIdAtom.reportChanged();
    }, _$selectedSkierIdAtom, name: '${_$selectedSkierIdAtom.name}_set');
  }

  final _$skierFilterAtom = Atom(name: '_SkierFilterContextModel.skierFilter');

  @override
  SkierFilter get skierFilter {
    _$skierFilterAtom.context.enforceReadPolicy(_$skierFilterAtom);
    _$skierFilterAtom.reportObserved();
    return super.skierFilter;
  }

  @override
  set skierFilter(SkierFilter value) {
    _$skierFilterAtom.context.conditionallyRunInAction(() {
      super.skierFilter = value;
      _$skierFilterAtom.reportChanged();
    }, _$skierFilterAtom, name: '${_$skierFilterAtom.name}_set');
  }
}
