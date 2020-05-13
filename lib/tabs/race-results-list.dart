import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:xcp/models/club.dart';
import 'package:xcp/models/race-result.dart';
import 'package:xcp/models/race.dart';
import 'package:xcp/models/skier.dart';
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/filter-tabbar-model.dart';
import 'package:xcp/tabs/list-tab-model.dart';
import 'package:xcp/tabs/race-results-list-model.dart';
import 'package:xcp/tabs/skier-details.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:xcp/widgets/PageContextWrapper.dart';
import 'package:xcp/widgets/closable-details.dart';
import 'package:xcp/widgets/padded-card.dart';

//import 'package:charts_flutter/src/text_style.dart' as style;


class RaceResultsList extends StatelessWidget {
  RaceResultsList(raceId) : model = RaceResultsListModel(raceId);

  final RaceResultsListModel model;

  @override
  Widget build(BuildContext ctx) =>
      Provider<RaceResultsListModel>.value(value: model, child: body(ctx));

  Widget body(ctx) {
    final MQ = MediaQuery.of(ctx),
        isLargeScreen = MQ.size.width > 600 ? true : false;

    return Column(children: [
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Column(children: <Widget>[
                        Observer(builder: (_)=>RaceDataWrapper(child:RaceDetails(), future: model.race,)),
                        Expanded(child: Observer(builder: (_)=>RaceDataWrapper(child:RaceResults(), future: model.results)))
                      ])),
                  isLargeScreen
                      ? Expanded(flex: 7, child: SkierDetailsWrapper())
                      : Container()
                ],
              ))
            ]);
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
      return skier == null ? ClosableDetails(closable:false, title: 'Race Summary', child:RaceSummary() ) : ClosableDetails(closable: true, title: 'Skier Details', child: SkierDetails(skier));
    });
  }
}

class RaceSummary extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Observer(builder: (_) {
      final model = Provider.of<RaceResultsListModel>(ctx);
      final global = Provider.of<GlobalStore>(ctx);
      final results = model.results, race = model.race;
      final data = results.value;
      final meta = race.value;
      if (data == null || meta == null)   return Text('...');
      final wt = data[0].timeSeconds;
      final tot = data.map((it)=>it.timeSeconds).reduce((it, c) => it + c);
      final cnt = data.length;
      final double avg = tot/cnt;
      final avgBack =  avg - wt;
      final avgBackPct = wt/avg;

      double sdiff = 0.0;
      for (var it in data.map((it)=>it.timeSeconds*1.0)) {
        sdiff +=(it-avg)*(it-avg);
      }

     final sd = sqrt(sdiff/(cnt-1));
      final sdPct = wt/sd;
      final medianIndex0 = (cnt/2).floor();
      final medianIndex1 = (cnt/2).ceil();
      final medianTime = (data[medianIndex0].timeSeconds + data[medianIndex1].timeSeconds) / 2.0;
      final medBack = medianTime - wt;
      final medBackPct = wt/medianTime;

      var noCPL = 0;
      var underPerf = 0;
      var overPerf = 0;
      var onPerf = 0;
      data.forEach((it){
        final skier = global.bundle.value.skiers[it.skierId];
        if (skier ==  null) {
          noCPL++;
        } else {
          final target = meta.discipline == 'D' ? skier.distancePoints : skier.sprintPoints;
          if (target.cpl.avg* .995 > it.points) {
            underPerf++;
          } else if (target.cpl.avg*1.005 < it.points) {
            overPerf++;
          } else {
            onPerf++;
          }
        }

      });



      final timeFmt = (double t) => '${(t / 60).floor()}:${(t % 60).toStringAsFixed(1).padLeft(4, '0')}';
      final diffFmt = (double t) => '+${t > 60 ? (t / 60).floor().toString() :'00'}:${(t % 60).toStringAsFixed(1).padLeft(4, '0')}';
      final pctFmt = (double t) => (t * 100).toStringAsFixed(2)+'%';



      return Column(
       children:[
         Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
               Text('Skiers: $cnt, $noCPL with no CPL entry'),
               Text('On Perf. $onPerf/${pctFmt(onPerf/(cnt-noCPL))}'),
               Text('Under Perf. $underPerf/${pctFmt(underPerf/(cnt-noCPL))}'),
               Text('Over Perf. $overPerf/${pctFmt(overPerf/(cnt-noCPL))}'),
            ]),

         Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
               Text('Winning Time: ${timeFmt(wt)}'),
             ]),
         Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
               Text('Avg Time: ${timeFmt(avg)}  (${diffFmt(avgBack)}, ${pctFmt(avgBackPct)})'),
             ]),
         Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
               Text('Std Dev.: ${diffFmt(sd)}  (${pctFmt(sdPct)})'),
             ]),
         Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
               Text('Median Time: ${timeFmt(medianTime)}  (${diffFmt(medBack)}, ${pctFmt(medBackPct)})'),
             ]),
         Expanded(child: RaceSummaryGraph(data,meta)),

      ]);
  });
  }

}

class RaceSummaryGraph extends StatelessWidget {
  RaceSummaryGraph(this.data, this.meta);

  final Race meta;
  final List<RaceResult> data;

  @override
  Widget build(BuildContext ctx) {
    final global = Provider.of<GlobalStore>(ctx);

    final List<charts.Series<RaceResult,double>> ts =  [
      charts.Series<RaceResult, double>(
        id: 'RacePoints',
          measureFn: (it, _) => it.points,
          domainFn: (it, _) {
          final skier = global.bundle.value.skiers[it.skierId];
          if (skier ==  null) {
              return data[0].timeSeconds / it.timeSeconds * meta.pointsReference;
          }
          final target = meta.discipline == 'D' ? skier.distancePoints : skier.sprintPoints;
          return max(target.cpl.avg, 50);
        },
        data: data
    ),
    charts.Series<RaceResult, double>(
        id: 'Eq',
        domainFn: (it, _) => it.points,
        measureFn: (it, _) => it.points,
        data: [RaceResult(skierId: -1, points:50,rank: 0, timeSeconds: 0), RaceResult(skierId: -2, points:100,rank: 1, timeSeconds: 0)]
    )..setAttribute(charts.rendererIdKey, 'customLine'),
    ];

    return charts.ScatterPlotChart(ts,
        behaviors: [
          charts.ChartTitle('Current CPL vs. Earned Points'),
          charts.ChartTitle('Current CPL',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
          charts.ChartTitle('Earned Points',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification: charts.OutsideJustification.middleDrawArea),

          charts.LinePointHighlighter(
          symbolRenderer:  CustomCircleSymbolRenderer(),
        )],
        domainAxis:charts.NumericAxisSpec(
            tickProviderSpec:
            charts.BasicNumericTickProviderSpec(zeroBound: false)),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec:
            charts.BasicNumericTickProviderSpec(zeroBound: false)),
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: (charts.SelectionModel model) {
              if(model.hasDatumSelection) {
                //print(model.selectedDatum[0].toString());
              }
            }
          )
        ],
        customSeriesRenderers: [
          charts.LineRendererConfig(
              customRendererId: 'customLine',
              layoutPaintOrder: charts.LayoutViewPaintOrder.point + 1)
        ]
    );
  }
}


class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
@override
void paint(charts.ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, fillColor, strokeColor, fillPattern, double strokeWidthPx}) {
  super.paint(canvas, bounds, dashPattern: dashPattern,   strokeWidthPx: strokeWidthPx);
  canvas.drawRect(
      Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10, bounds.height + 10),
      fill: charts.Color.white
  );
  return;
/*
  var textStyle = charts.TextStyle();
  textStyle.color = Color.black;
  textStyle.fontSize = 15;
  canvas.drawText(
      charts.TextElement("1", style: textStyle),
      (bounds.left).round(),
      (bounds.top - 28).round()
  );
*/
}
}


class RaceDataWrapper extends StatelessWidget {
  final ObservableFuture future;
  final Widget child;

  const RaceDataWrapper({Key key, this.child, this.future}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Observer(builder: (_) {
      switch (future.status) {
        case FutureStatus.fulfilled:
          return child;
        case FutureStatus.pending:
          return Center(child: CircularProgressIndicator());
        case FutureStatus.rejected:
        default:
          return Text('Error');
          break;
      }
    });
  }
}

class RaceDetails extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<RaceResultsListModel>(ctx);
    final race = model.race.value;

    final texts = [
      race.name,
      race.location,
      race.categories,
      race.distanceKm > 0 ? '${race.distanceKm}km' : '',
      race.discipline,
      race.technique,
      race.pointsReference.toStringAsFixed(3)
    ].where((it) => it.length > 0).map((it) => Text(it)).toList();

    return PaddedCard(
        child: Row(
                children:[ Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: texts)]));
  }
}

class RaceResults extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<RaceResultsListModel>(ctx);
    final data = model.results.value;
    final global = Provider.of<GlobalStore>(ctx);
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);
    final winner = data[0];
    return PaddedCard(child:ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (_, index) {
          final rr = data[index];
          final Skier skier = global.bundle.value.skiers[rr.skierId] ?? Skier.notInPointsList(rr.skierId);
          final Club club = skier.club;


          final s = rr.timeSeconds;
          final timeMMSS =
              '${(s / 60).floor()}:${(s % 60).toStringAsFixed(1).padLeft(4, '0')}';
          final diff = s - data[0].timeSeconds;
          final diffMMSS = index == 0
              ? ''
              : '+${diff > 60 ? (diff / 60).floor() : 00}:${(diff % 60).toStringAsFixed(1).padLeft(4, '0')}';

          final MQ = MediaQuery.of(ctx),
              isLargeScreen = MQ.size.width > 600 ? true : false;

          return Observer(
              builder: (_) => Container(
                    decoration: BoxDecoration(
                        border: filterContext.selectedSkierId == skier.id
                            ? Border(top: BorderSide(), bottom: BorderSide())
                            : Border.fromBorderSide(BorderSide.none)),
                    child: ListTile(
                        dense: true,
                        selected: filterContext.selectedSkierId == skier.id,
                        onTap: () {
                          filterContext.selectedSkierId = skier.id;
                          if (!isLargeScreen) {
                            Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                    builder: (_) => PageContextWrapper(
                                        ctx,
                                        'Skier Details',
                                        () => SkierDetails(skier))));
                          }
                        },
                        onLongPress: () {
                          final tbModel = Provider.of<FilterTabbarModel>(ctx, listen: false);
                          tbModel.addTab(type: TAB_SKIER_DETAILS, skier: skier);
                        },
                        leading: Text((index + 1).toString()),
                        title: Text(
                          '${skier.firstname + ' ' + skier.lastname + ' `' + (skier.yob > 0 ? skier.yob.toString().substring(2) : '') }' ,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          (club.isNone)
                              ? skier.nation
                              : club.name + ', ' + club.province,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing:
                            Column( crossAxisAlignment: CrossAxisAlignment.end,
                                children: [Text(timeMMSS),
                                              index == 0 ? null : Text(diffMMSS, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                              Text('${rr.points}pts', style: TextStyle(fontSize: 10, color: Colors.grey))].where((it)=>it != null).toList() )),
                  ));
        }));
  }
}
