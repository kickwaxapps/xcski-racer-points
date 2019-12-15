import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:xcp/models/skier.dart';


part 'free-form-list-builder-model.g.dart';

class FreeFormListBuilderModel = _FreeFormListBuilderModel with _$FreeFormListBuilderModel;

abstract class _FreeFormListBuilderModel with Store {

  final splitter = LineSplitter();

  final controller = TextEditingController(text: '');

  @observable
  String csvList = '';


  @computed
  List<List<String>> get parsedNames   {
    final lines = splitter.convert(csvList);

    final result = List<List<String>>();

    for (var line in lines) {
      final a = line.split('\t');
      if (a.length != 2) continue;
      final s0 = a[0].trim().toLowerCase();
      final s1 = a[1].trim().toLowerCase();
      result.add( <String>[s0,s1] );
    }

    return result;

  }

  List<Skier> findSkier(List<Skier> skiers, String s0, String s1) {
    return skiers.where((it)=> it.firstname.toLowerCase() == s0 && it.lastname.toLowerCase() == s1
        || it.firstname == s1.toLowerCase() && it.lastname.toLowerCase() == s0 ).toList();
  }

  List<Skier> list(List<Skier> skiers, List<List<String>> parsedList) {

    final result = List<Skier>();
    for (final l in parsedList) {
      final matches = findSkier(skiers, l[0], l[1]);
      if (matches != null) {
        result.addAll(matches);
      }
    }

    return result;
  }

}