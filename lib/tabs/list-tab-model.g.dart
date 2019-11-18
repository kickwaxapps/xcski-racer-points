// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list-tab-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ListTabModel on _ListTabModel, Store {
  Computed<String> _$titleComputed;

  @override
  String get title =>
      (_$titleComputed ??= Computed<String>(() => super.title)).value;
  Computed<Map> _$toJsonComputed;

  @override
  Map get toJson =>
      (_$toJsonComputed ??= Computed<Map>(() => super.toJson)).value;

  final _$descriptionAtom = Atom(name: '_ListTabModel.description');

  @override
  String get description {
    _$descriptionAtom.context.enforceReadPolicy(_$descriptionAtom);
    _$descriptionAtom.reportObserved();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.context.conditionallyRunInAction(() {
      super.description = value;
      _$descriptionAtom.reportChanged();
    }, _$descriptionAtom, name: '${_$descriptionAtom.name}_set');
  }

  final _$_ListTabModelActionController =
      ActionController(name: '_ListTabModel');

  @override
  dynamic onTap() {
    final _$actionInfo = _$_ListTabModelActionController.startAction();
    try {
      return super.onTap();
    } finally {
      _$_ListTabModelActionController.endAction(_$actionInfo);
    }
  }
}
