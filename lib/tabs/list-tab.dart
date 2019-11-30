
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/points-list.dart';
import 'package:xcp/tabs/race-results-list.dart';
import 'package:xcp/tabs/skier-details.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list-tab-model.dart';

class ListTab extends StatelessWidget {
  ListTab({type, skier, skierFilter, raceId, name}) :
        this.model = ListTabModel(type:type, skier:skier, skierFilter:skierFilter, raceId:raceId, name:name);

  final ListTabModel model;

  @override
  Widget build(BuildContext ctx) {
    return  MultiProvider(
        providers:[
          Provider<ListTabModel>.value(value: model),
          Provider<SkierFilterContextModel>.value(value: model.skierFilterContextModel)
        ],
        child: FutureBuilder(
          future: body(),
          builder: (ctx, snp){
            if (snp.connectionState !=ConnectionState.done) {
              return CircularProgressIndicator();
            }
            return snp.data;
          })
    );
  }

  Future<Widget> body() async {
    switch (model.type) {
      case TAB_POINTS_LIST:
        return PointsList();
      case TAB_SKIER_DETAILS:
        return SkierDetails(model.skier);
      case TAB_RACE_DETAILS:
        return RaceResultsList(model.raceId);
      default:
        return Text('error');
    }
  }

  factory ListTab.fromJson(it,ctx) {
    final gs = Provider.of<GlobalStore>(ctx, listen: false);
    final int skierId = it['skier'] as int;
    final skier = skierId == null ? null : gs.bundle.value.skiers[skierId];
    return ListTab(skier: skier, type: it['type'], skierFilter: it['skierFilter'], raceId: it['race'], name: it['name']);
  }

}

