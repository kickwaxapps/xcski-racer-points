import 'package:app/models/race-result.dart';
import 'package:app/stores/global.dart';
import 'package:app/tabs/filter-tabbar-model.dart';
import 'package:app/tabs/list-tab-model.dart';
import 'package:app/tabs/race-results-list-model.dart';
import 'package:app/tabs/skier-details.dart';
import 'package:app/tabs/skier-filter-context-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';


class RaceResultsList extends StatelessWidget {
  RaceResultsList(raceId) :
        model = RaceResultsListModel(raceId);

  final RaceResultsListModel  model;

  @override
  Widget build(BuildContext ctx) => Provider<RaceResultsListModel>.value(
          value: model,
          child: body(ctx)
      );

  Widget body(ctx) {
    return
      Observer( builder: (_)=> Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Column( children: <Widget>[
                      RaceDetailsWrapper(),
                      Expanded(child:RaceResultsWrapper())
                    ])),
                    Expanded(flex: 8, child: SkierDetailsWrapper())
                  ],
                )
              )
            ]
        )
      );

  }
}


class SkierDetailsWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);
    final gs = Provider.of<GlobalStore>(ctx);


    return Observer(builder: (_) {
      final id = filterContext.selectedSkierId;
      final skier = gs.bundle.value.skiers[id];
      return skier == null ? Text('') : SkierDetails(skier) ;
    });
  }
}


class RaceDetailsWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<RaceResultsListModel>(ctx);
    return Observer(builder: (_) {
      switch (model.race.status) {
        case FutureStatus.fulfilled:
          return body(ctx);
        case FutureStatus.pending:
          return LinearProgressIndicator();
        case FutureStatus.rejected:
        default:
          return Text('Error');
          break;
      }
    });
  }
  Widget body(ctx) {
    final model = Provider.of<RaceResultsListModel>(ctx);
    final race = model.race.value;

    final texts = [race.name, race.location, race.categories,
      race.distanceKm > 0 ? '${race.distanceKm}km' : '',
      race.discipline, race.technique, race.pointsReference.toStringAsFixed(3)
    ].where((it)=>it.length> 0 ).map((it)=>Text(it)).toList();



    return Card(
        child: Container(
        padding: EdgeInsets.all(10),
    child: FittedBox(
    fit: BoxFit.fitWidth,

    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: texts

    )
    )
    )
    );


  }
}

class RaceResultsWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<RaceResultsListModel>(ctx);
    return Observer(builder: (_) {
      switch (model.results.status) {
        case FutureStatus.fulfilled:
          return getList(ctx, model.results.value);
        case FutureStatus.pending:
          return LinearProgressIndicator();
        case FutureStatus.rejected:
        default:
          return Text(model.results.error as String);
          break;
      }
    });
  }

  Widget getList(ctx, List<RaceResult> data) {
    final global = Provider.of<GlobalStore>(ctx);
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);


    return ListView.builder(

        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (_, index) {
          final rr = data[index];
          final skier = global.bundle.value.skiers[rr.skierId];
          final club = skier.club;

          final  s = rr.timeSeconds;
          final timeMMSS = '${(s/60).floor()}:${(s % 60).toStringAsFixed(1).padLeft(4,'0')}';
          final diff = s - data[0].timeSeconds;
          final diffMMSS = index == 0 ? '' : '+${diff > 60 ? (diff/60).floor() : 00}:${(diff % 60).toStringAsFixed(1).padLeft(4,'0')}';


          return Observer( builder: (_)=>Container(
            decoration: BoxDecoration(
              border:  filterContext.selectedSkierId == skier.id ? Border(top: BorderSide(), bottom: BorderSide()) : Border.fromBorderSide(BorderSide.none)
            ),
            child: ListTile(
               dense:true,
               selected: filterContext.selectedSkierId == skier.id,
                onTap: () {
                  filterContext.selectedSkierId = skier.id;
                },
                onLongPress: () {
                  final tbModel = Provider.of<FilterTabbarModel>(ctx);
                  tbModel.addTab(type: TAB_SKIER_DETAILS, skier: skier);
                },
                leading: Text((index + 1).toString()),
                title: Text(
                    '${skier.firstname + ' ' + skier.lastname + ' `' +
                        skier.yob.toString().substring(2)}', overflow: TextOverflow.ellipsis,),
                subtitle: Text(club.isNone
                    ? skier.nation
                    : club.name + ', ' + club.province, overflow: TextOverflow.ellipsis,),
                trailing: Column(children:[Text(timeMMSS), Text(diffMMSS)])
            ),
          ));
        }
    );
  }
}
