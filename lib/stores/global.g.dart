// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GlobalStore on _Global, Store {
  final _$bundleAtom = Atom(name: '_Global.bundle');

  @override
  ObservableFuture<Bundle> get bundle {
    _$bundleAtom.context.enforceReadPolicy(_$bundleAtom);
    _$bundleAtom.reportObserved();
    return super.bundle;
  }

  @override
  set bundle(ObservableFuture<Bundle> value) {
    _$bundleAtom.context.conditionallyRunInAction(() {
      super.bundle = value;
      _$bundleAtom.reportChanged();
    }, _$bundleAtom, name: '${_$bundleAtom.name}_set');
  }

  final _$_GlobalActionController = ActionController(name: '_Global');

  @override
  void loadBundle() {
    final _$actionInfo = _$_GlobalActionController.startAction();
    try {
      return super.loadBundle();
    } finally {
      _$_GlobalActionController.endAction(_$actionInfo);
    }
  }
}