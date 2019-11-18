// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points-list-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PointsListModel on _PointsListModel, Store {
  final _$filterExpandedAtom = Atom(name: '_PointsListModel.filterExpanded');

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
}
