// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combined-config-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CombinedConfigModel on _CombinedConfigModel, Store {
  final _$factorAtom = Atom(name: '_CombinedConfigModel.factor');

  @override
  double get factor {
    _$factorAtom.context.enforceReadPolicy(_$factorAtom);
    _$factorAtom.reportObserved();
    return super.factor;
  }

  @override
  set factor(double value) {
    _$factorAtom.context.conditionallyRunInAction(() {
      super.factor = value;
      _$factorAtom.reportChanged();
    }, _$factorAtom, name: '${_$factorAtom.name}_set');
  }
}
