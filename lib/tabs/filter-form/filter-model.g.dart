// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilterModel on _FilterModel, Store {
  final _$filterOpenAtom = Atom(name: '_FilterModel.filterOpen');

  @override
  bool get filterOpen {
    _$filterOpenAtom.context.enforceReadPolicy(_$filterOpenAtom);
    _$filterOpenAtom.reportObserved();
    return super.filterOpen;
  }

  @override
  set filterOpen(bool value) {
    _$filterOpenAtom.context.conditionallyRunInAction(() {
      super.filterOpen = value;
      _$filterOpenAtom.reportChanged();
    }, _$filterOpenAtom, name: '${_$filterOpenAtom.name}_set');
  }

  final _$pointsListTypeAtom = Atom(name: '_FilterModel.pointsListType');

  @override
  PointsListType get pointsListType {
    _$pointsListTypeAtom.context.enforceReadPolicy(_$pointsListTypeAtom);
    _$pointsListTypeAtom.reportObserved();
    return super.pointsListType;
  }

  @override
  set pointsListType(PointsListType value) {
    _$pointsListTypeAtom.context.conditionallyRunInAction(() {
      super.pointsListType = value;
      _$pointsListTypeAtom.reportChanged();
    }, _$pointsListTypeAtom, name: '${_$pointsListTypeAtom.name}_set');
  }

  final _$pointDisciplineAtom = Atom(name: '_FilterModel.pointDiscipline');

  @override
  PointsDiscipline get pointDiscipline {
    _$pointDisciplineAtom.context.enforceReadPolicy(_$pointDisciplineAtom);
    _$pointDisciplineAtom.reportObserved();
    return super.pointDiscipline;
  }

  @override
  set pointDiscipline(PointsDiscipline value) {
    _$pointDisciplineAtom.context.conditionallyRunInAction(() {
      super.pointDiscipline = value;
      _$pointDisciplineAtom.reportChanged();
    }, _$pointDisciplineAtom, name: '${_$pointDisciplineAtom.name}_set');
  }

  final _$sexAtom = Atom(name: '_FilterModel.sex');

  @override
  int get sex {
    _$sexAtom.context.enforceReadPolicy(_$sexAtom);
    _$sexAtom.reportObserved();
    return super.sex;
  }

  @override
  set sex(int value) {
    _$sexAtom.context.conditionallyRunInAction(() {
      super.sex = value;
      _$sexAtom.reportChanged();
    }, _$sexAtom, name: '${_$sexAtom.name}_set');
  }

  final _$yobsAtom = Atom(name: '_FilterModel.yobs');

  @override
  ObservableList get yobs {
    _$yobsAtom.context.enforceReadPolicy(_$yobsAtom);
    _$yobsAtom.reportObserved();
    return super.yobs;
  }

  @override
  set yobs(ObservableList value) {
    _$yobsAtom.context.conditionallyRunInAction(() {
      super.yobs = value;
      _$yobsAtom.reportChanged();
    }, _$yobsAtom, name: '${_$yobsAtom.name}_set');
  }

  final _$nationsAtom = Atom(name: '_FilterModel.nations');

  @override
  ObservableList get nations {
    _$nationsAtom.context.enforceReadPolicy(_$nationsAtom);
    _$nationsAtom.reportObserved();
    return super.nations;
  }

  @override
  set nations(ObservableList value) {
    _$nationsAtom.context.conditionallyRunInAction(() {
      super.nations = value;
      _$nationsAtom.reportChanged();
    }, _$nationsAtom, name: '${_$nationsAtom.name}_set');
  }

  final _$regionsAtom = Atom(name: '_FilterModel.regions');

  @override
  ObservableList get regions {
    _$regionsAtom.context.enforceReadPolicy(_$regionsAtom);
    _$regionsAtom.reportObserved();
    return super.regions;
  }

  @override
  set regions(ObservableList value) {
    _$regionsAtom.context.conditionallyRunInAction(() {
      super.regions = value;
      _$regionsAtom.reportChanged();
    }, _$regionsAtom, name: '${_$regionsAtom.name}_set');
  }

  final _$searchStringAtom = Atom(name: '_FilterModel.searchString');

  @override
  String get searchString {
    _$searchStringAtom.context.enforceReadPolicy(_$searchStringAtom);
    _$searchStringAtom.reportObserved();
    return super.searchString;
  }

  @override
  set searchString(String value) {
    _$searchStringAtom.context.conditionallyRunInAction(() {
      super.searchString = value;
      _$searchStringAtom.reportChanged();
    }, _$searchStringAtom, name: '${_$searchStringAtom.name}_set');
  }

  final _$_FilterModelActionController = ActionController(name: '_FilterModel');

  @override
  void setSearchString(String v) {
    final _$actionInfo = _$_FilterModelActionController.startAction();
    try {
      return super.setSearchString(v);
    } finally {
      _$_FilterModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clear() {
    final _$actionInfo = _$_FilterModelActionController.startAction();
    try {
      return super.clear();
    } finally {
      _$_FilterModelActionController.endAction(_$actionInfo);
    }
  }
}
