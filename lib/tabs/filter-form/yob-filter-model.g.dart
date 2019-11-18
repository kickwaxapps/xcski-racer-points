// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yob-filter-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$YOBFilterModel on _YOBFilterModel, Store {
  final _$enabledAtom = Atom(name: '_YOBFilterModel.enabled');

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
}
