// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter-tabbar-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilterTabbarModel on _FilterTabbarModel, Store {
  Computed<int> _$countComputed;

  @override
  int get count => (_$countComputed ??= Computed<int>(() => super.count)).value;
  Computed<Map> _$toJsonComputed;

  @override
  Map get toJson =>
      (_$toJsonComputed ??= Computed<Map>(() => super.toJson)).value;

  final _$tabsAtom = Atom(name: '_FilterTabbarModel.tabs');

  @override
  ObservableList<ListTab> get tabs {
    _$tabsAtom.context.enforceReadPolicy(_$tabsAtom);
    _$tabsAtom.reportObserved();
    return super.tabs;
  }

  @override
  set tabs(ObservableList<ListTab> value) {
    _$tabsAtom.context.conditionallyRunInAction(() {
      super.tabs = value;
      _$tabsAtom.reportChanged();
    }, _$tabsAtom, name: '${_$tabsAtom.name}_set');
  }

  final _$currentIndexAtom = Atom(name: '_FilterTabbarModel.currentIndex');

  @override
  int get currentIndex {
    _$currentIndexAtom.context.enforceReadPolicy(_$currentIndexAtom);
    _$currentIndexAtom.reportObserved();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.context.conditionallyRunInAction(() {
      super.currentIndex = value;
      _$currentIndexAtom.reportChanged();
    }, _$currentIndexAtom, name: '${_$currentIndexAtom.name}_set');
  }

  final _$_FilterTabbarModelActionController =
      ActionController(name: '_FilterTabbarModel');

  @override
  dynamic addTab({int type, Skier skier, Race race}) {
    final _$actionInfo = _$_FilterTabbarModelActionController.startAction();
    try {
      return super.addTab(type: type, skier: skier, race: race);
    } finally {
      _$_FilterTabbarModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteTab(int i) {
    final _$actionInfo = _$_FilterTabbarModelActionController.startAction();
    try {
      return super.deleteTab(i);
    } finally {
      _$_FilterTabbarModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrent(int i) {
    final _$actionInfo = _$_FilterTabbarModelActionController.startAction();
    try {
      return super.setCurrent(i);
    } finally {
      _$_FilterTabbarModelActionController.endAction(_$actionInfo);
    }
  }
}
