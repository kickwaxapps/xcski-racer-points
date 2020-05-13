import 'dart:math';

import 'package:xcp/models/race.dart';
import 'package:xcp/models/skier.dart';
import 'package:xcp/tabs/list-tab.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'filter-tabbar-model.g.dart';

class FilterTabbarModel = _FilterTabbarModel with _$FilterTabbarModel;

abstract class _FilterTabbarModel with Store {
  _FilterTabbarModel(TickerProvider owner, layout, ctx) : _owner = owner {
    tabs.addAll(((layout['tabs'] ?? []) as List)
        .map((it) => ListTab.fromJson(it, ctx))
        .toList());
    currentIndex = layout['currentIndex'];

    controller = TabController(
        length: tabs.length,
        initialIndex: tabs.length > 0 ? currentIndex : 0,
        vsync: _owner);
    controller.addListener(() {
      setCurrent(controller.index);
    });
  }

  final TickerProvider _owner;

  TabController controller;

  @observable
  ObservableList<ListTab> tabs = ObservableList<ListTab>();

  @action
  addTab({int type, Skier skier, Race race}) {
    final tab = ListTab(type: type, skier: skier, raceId: race?.id, name: (skier?.lastname ?? race?.name));
    tabs.add(tab);

    setCurrent(tabs.lastIndexOf(tab));
    syncController();
  }

  @computed
  int get count => tabs.length;

  @observable
  int currentIndex = -1;

  @action
  deleteTab(int i) {
    final tb = tabs.removeAt(i);

    setCurrent(i < count ? i : count - 1);
    syncController();
  }

  @action
  setCurrent(int i) {
    currentIndex = i;
  }

  @computed
  Map get toJson => {
        'tabs': tabs.map((it) => it.model.toJson).toList(),
        'currentIndex': currentIndex
      };

  void syncController() {

    final index = max(min(controller.index, count - 1), 0);

    controller.dispose();

    controller = TabController(length: count, initialIndex: index, vsync: _owner);
    if (count > 0 ) {
      controller.animateTo(currentIndex);
    }
    controller.addListener(() {
      setCurrent(controller.index);
    });
    }


  @override
  void dispose() {
    controller.dispose();
  }
}
