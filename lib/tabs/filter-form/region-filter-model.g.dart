// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region-filter-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegionFilterModel on _RegionFilterModel, Store {
  final _$enabledAtom = Atom(name: '_RegionFilterModel.enabled');

  @override
  bool get enabled {
    _$enabledAtom.context.enforceReadPolicy(_$enabledAtom);
    _$enabledAtom.reportObserved();
    return super.enabled;
  }

  @override
  set enabled(bool value) {
    _$enabledAtom.context.conditionallyRunInAction(() {
      super.enabled = value;
      _$enabledAtom.reportChanged();
    }, _$enabledAtom, name: '${_$enabledAtom.name}_set');
  }

  final _$_RegionFilterModelActionController =
      ActionController(name: '_RegionFilterModel');

  @override
  void setEabled(bool v) {
    final _$actionInfo = _$_RegionFilterModelActionController.startAction();
    try {
      return super.setEabled(v);
    } finally {
      _$_RegionFilterModelActionController.endAction(_$actionInfo);
    }
  }
}
