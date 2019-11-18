import 'dart:math';

import 'package:app/models/skier-points.dart';
import 'package:app/models/skier-race.dart';
import 'package:app/models/skier.dart';
import 'package:app/tabs/filter-tabbar-model.dart';
import 'package:app/tabs/skier-details-model.dart';
import 'package:app/tabs/skier-filter-context-model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:date_format/date_format.dart';

import 'list-tab-model.dart';

class SkierDetails extends StatelessWidget {
  SkierDetails(skier) : model = SkierDetailsModel(skier);

  final SkierDetailsModel model;

  @override
  Widget build(BuildContext ctx) =>
            Provider<SkierDetailsModel>.value(
              value:  model,
              child: body(ctx)
          );


  Widget body(ctx) {
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap( direction: Axis.horizontal
              ,children:[
                SkierInfo(),
                SkierPointsInfo(type:PointsListType.lastPublished),
                SkierPointsInfo(type:PointsListType.rolling),
                RaceFilters(),
                IconButton(icon:Icon(Icons.close), onPressed: ()=>filterContext.selectedSkierId = -1,)
              ]),

          Expanded( flex: 5,
              child: Row(children: [
            Expanded(flex: 3, child: SkierRaces()),
            Expanded(flex: 7, child: SkierResultGraph()),
          ])),
          Expanded( flex: 5,
              child: Row(children: [
                Expanded(flex: 5, child: SkierEosPointsGraph()),
                Expanded(flex: 5, child: SkierPointsGraph()),
              ]))
        ]);
  }
}


class SkierInfo extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
      final model = Provider.of<SkierDetailsModel>(ctx);
      final skier = model.skier;
      return Card(
          child: Container(
            padding: EdgeInsets.all(10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(skier.nameYob),
                Text(skier.club.name),
                skier.club.province.isEmpty ? null : Text(skier.club.province),
                Text(skier.nation),
                Text(skier.sex == 'F' ? 'Female' : 'Male'),
              ].where((it)=> it!=null).toList(),
            ),
          ));
  }
}

class SkierPointsInfo extends StatelessWidget {
  SkierPointsInfo({type}): this.type = type;
  final PointsListType type ;
  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<SkierDetailsModel>(ctx);
    final skier = model.skier;
    final pd = skier.allPointDataFor(discipline: PointsDiscipline.distance, type: type);
    final sp = skier.allPointDataFor(discipline: PointsDiscipline.sprint, type: type);
    final cb = skier.allPointDataFor(discipline: PointsDiscipline.combined, type: type);

    final label =  (t) =>Container( width: 75 ,child: Text(t, style: TextStyle(fontWeight: FontWeight.bold)) );
    final heading = (t) =>Container( width: 50 ,child: Text(t, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,) );
    final header = ['Total', 'Avg', 'Races'];
    final num = (n, {f=2}) => Text(n.toStringAsFixed(f));
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
          child: FittedBox(
            fit: BoxFit.fitWidth,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type == PointsListType.lastPublished ? 'Offical Published Points' : 'Rolling Points', textAlign: TextAlign.center),
                Row( children:[
                  Column( crossAxisAlignment: CrossAxisAlignment.start, children:[Text(''), label('Distance'), label('Sprint'), label('Combined')]),
                 ...List.generate(header.length, (i)=>Column( crossAxisAlignment: CrossAxisAlignment.end, children:[heading(header[i]), num(pd[i], f: i==2 ? 0 : 2), num(sp[i],f: i==2 ? 0 : 2), num(cb[i], f: i==2 ? 0 : 2)]) )
              ])
            ]),
          )
              )
    );
  }
}


class RaceFilters extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<SkierDetailsModel>(ctx);
    // TODO: implement build
    return  Card( child: Container(
      padding: EdgeInsets.all(10),
      child:  FittedBox(
      fit: BoxFit.fitWidth,

      child:Wrap(
        direction: Axis.horizontal,
        children: [
          Column( children: [
            Text('Race Type'),
          Observer(
            builder: (_) => ToggleButtons(
                children: RaceFilter.values
                    .map((it) => Tooltip(
                    message: ['Include all race types','Include only Distance races', 'Include only Sprint races'][it.index],
                    child:  Text(['All','Distance', 'Sprint'][it.index])
                )).toList(),
                onPressed: (int index) {
                  model.raceFilter = RaceFilter.values[index];
                },
                isSelected: RaceFilter.values
                    .map((it) => it == model.raceFilter)
                    .toList()),
          )
        ]),
          VerticalDivider(),
          Column(
            children: [
              Text('Period Filter'),
              Observer(
                builder: (_) => ToggleButtons(
                    children: TimeFilter.values
                        .map((it) => Tooltip(
                      message: ['All races', 'Only races in last 365 days', 'Races included in the last publised points period' ][it.index],
                      child:Text(['All ', '365', 'CPL' ][it.index])
                    ))
                        .toList(),
                    onPressed: (int index) {
                      model.timeFilter = TimeFilter.values[index];
                    },
                    isSelected: TimeFilter.values
                        .map((it) => it == model.timeFilter)
                        .toList()),
              ),
            ]
          ),
          VerticalDivider(),
          Column(
            children: [
              Text('Sort'),
              Observer(
                builder: (_) => ToggleButtons(
                    children: RaceSort.values
                        .map((it) => Text(['Date', 'Points'][it.index]))
                        .toList(),
                    onPressed: (int index) {
                      model.raceSort = RaceSort.values[index];
                    },
                    isSelected:
                    RaceSort.values.map((it) => it == model.raceSort).toList()),
              ),
            ]
          )

        ],
      ),
    )));
  }
}

class SkierResultGraph extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<SkierDetailsModel>(ctx);

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: Observer(builder: (_) {
        switch (model.raceResults.status) {
          case FutureStatus.fulfilled:
            final data = model.filteredResults,
                dataBySeason = groupBy<SkierRace, int>(
                    data, (it) => it.date.add(Duration(days: 90)).year),
                ts = dataBySeason.entries
                    .map((season) => charts.Series<SkierRace, DateTime>(
                        id: 'Races ${season.key}',

                        domainFn: (it, _) => DateTime(
                            it.date.month < 11
                                ? DateTime.now().year
                                : DateTime.now().year - 1,
                            it.date.month,
                            it.date.day),
                        measureFn: (it, _) => it.points,
                        data: season.value
                            .where((it) =>
                                it.points > 0 &&
                                (it.date.month < 6 || it.date.month > 10))
                            .toList()
                              ..sort((r0, r1) => r0.date.compareTo(r1.date))))
                    .toList();

            ts.sort(( i0,i1) => i1.id.compareTo(i0.id));

            return charts.TimeSeriesChart(ts,
                defaultRenderer: charts.LineRendererConfig(
                    includePoints: true, includeArea: true),
                primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec:
                        charts.BasicNumericTickProviderSpec(zeroBound: false)),
                behaviors: [charts.SeriesLegend()]);

          case FutureStatus.pending:
            return Column(
              children: <Widget>[
                LinearProgressIndicator(),
                Text('Fetching Races'),
              ],
            );
            break;
          case FutureStatus.rejected:
            return Text('Error');
            break;
        }

        return Text('err');
      }),
    );
  }
}

class SkierPointsGraph extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<SkierDetailsModel>(ctx);

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: Observer(builder: (_) {
        switch (model.points.status) {
          case FutureStatus.fulfilled:
            final data = model.points.value,
                dataByDiscipline = groupBy<SkierPointsSeries, String>(
                    data, (it) => it.discipline.toString()),
                ts = dataByDiscipline.entries
                    .map((discipline) => charts.Series<SkierPointsSeries, DateTime>(
                    id: 'Points ${discipline.key}',

                    domainFn: (it, _) => DateTime(
                        it.date.month < 11
                            ? DateTime.now().year
                            : DateTime.now().year - 1,
                        it.date.month,
                        it.date.day),
                    measureFn: (it, _) => it.points,
                    data: discipline.value
                        .where((it) =>
                    it.points > 0 &&
                        (it.date.month < 6 || it.date.month > 10))
                        .toList()
                      ..sort((r0, r1) => r0.date.compareTo(r1.date))))
                    .toList();

            ts.sort(( i0,i1) => i1.id.compareTo(i0.id));

            return charts.TimeSeriesChart(ts,
                defaultRenderer: charts.LineRendererConfig(
                    includePoints: true, includeArea: true),
                primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec:
                    charts.BasicNumericTickProviderSpec(zeroBound: false)),
                behaviors: [charts.SeriesLegend()]);

          case FutureStatus.pending:
            return Column(
              children: <Widget>[
                LinearProgressIndicator(),
                Text('Fetching Races'),
              ],
            );
            break;
          case FutureStatus.rejected:
            return Text('Error');
            break;
        }

        return Text('err');
      }),
    );
  }
}

class SkierEosPointsGraph extends StatelessWidget {

  static const MIN_MEASURE = 70.0;

  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<SkierDetailsModel>(ctx);

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: Observer(builder: (_) {
        switch (model.eosPoints.status) {
          case FutureStatus.fulfilled:
            final data = model.eosPoints.value.where((it)=>it.points >= MIN_MEASURE).map((it)=>SkierEOSPointsSeries(points: max(it.points-MIN_MEASURE,0), discipline: it.discipline, age: it.age)),
                minAge =data.map((it)=>it.age).reduce(min),
                maxAge =data.map((it)=>it.age).reduce(max),
                ages = List.generate(maxAge - minAge+1, (i)=> minAge +  i ),
                missingSprintAge  = ages.where( (age) => !data.any((it)=>it.age == age && it.discipline == Discipline.sprint)).map( (it)=>SkierEOSPointsSeries(points:0, discipline: Discipline.sprint, age:it)).toList(),
                missingDistanceAge  = ages.where( (age) => !data.any((it)=>it.age == age && it.discipline == Discipline.distance)).map( (it)=>SkierEOSPointsSeries(points:0, discipline: Discipline.distance, age:it)).toList(),

                dataByDiscipline = groupBy<SkierEOSPointsSeries, String>(
                    [...data,...missingDistanceAge, ...missingSprintAge], (it) => it.discipline == Discipline.distance ? "Distance" : "Sprint"),
                ts = dataByDiscipline.entries
                    .map((discipline) => charts.Series<SkierEOSPointsSeries, String>(
                    id: 'Points ${discipline.key}',

                    domainFn: (it, _) => it.age.toString(),
                    measureFn: (it, _) => it.points,
                    data: discipline.value.toList()..sort((r0, r1) => r0.age.compareTo(r1.age))
                ));

            return charts.BarChart([...ts, ...getInternationalNorms(model.skier, minAge, maxAge)],
                barGroupingType: charts.BarGroupingType.grouped,
                customSeriesRenderers: [
                  new charts.BarTargetLineRendererConfig<String>(
                    // ID used to link series to this renderer.
                      customRendererId: 'customTargetLine',
                      groupingType: charts.BarGroupingType.grouped)
                ],
                domainAxis: charts.AxisSpec<String>(
                    tickProviderSpec: charts.StaticOrdinalTickProviderSpec(List.generate(maxAge - minAge +1, (age) => charts.TickSpec((minAge+age).toString())))

                ) ,
                primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.StaticNumericTickProviderSpec([charts.TickSpec(0,label:'70', ), charts.TickSpec(10,label:'80', ), charts.TickSpec(20,label:'90', ) , charts.TickSpec(30,label:'100')])
                ),

                behaviors: [charts.SeriesLegend()]);

          case FutureStatus.pending:
            return Column(
              children: <Widget>[
                LinearProgressIndicator(),
                Text('Fetching Races'),
              ],
            );
            break;
          case FutureStatus.rejected:
            return Text('Error');
            break;
        }

        return Text('err');
      }),
    );
  }


 List getInternationalNorms(Skier skier, minAge, maxAge) {
    final sex = skier.sex;
    final IPBFS = [
          [16, 80],
          [17, 83.5],
          [18, 86.5],
          [19, 89],
          [20, 91],
          [21, 93],
          [22, 94],
          [23, 95],
          [24, 96],
          [25, 96.5],
          [26, 97],
          [27, 97.5],
          [28, 97.5],
          [29, 97.5],
          [30, 97.5]
        ].map((it)=> SkierEOSPointsSeries(points: max(it[1]-MIN_MEASURE,0), discipline: Discipline.sprint, age: it[0])),
    IPBFD = [
          [16, 77.5],
          [17, 81],
          [18, 84],
          [19, 86.5],
          [20, 88.5],
          [21, 90.5],
          [22, 92],
          [23, 93],
          [24, 94],
          [25, 94.5],
          [26, 95],
          [27, 95.5],
          [28, 96],
          [29, 96],
          [30, 96]
        ].map((it)=> SkierEOSPointsSeries(points: max(it[1]-MIN_MEASURE,0), discipline: Discipline.distance, age: it[0])),
      IPBMS =[
          [16, 81],
          [17, 84.5],
          [18, 87.5],
          [19, 90],
          [20, 92],
          [21, 94],
          [22, 95],
          [23, 96],
          [24, 96.5],
          [25, 96.5],
          [26, 96.5],
          [27, 97.0],
          [28, 97.0],
          [29, 97],
          [30, 97]
        ].map((it)=> SkierEOSPointsSeries(points: max(it[1]-MIN_MEASURE,0), discipline: Discipline.sprint, age: it[0])),
      IPBMD =[
          [16, 80.5],
          [17, 84],
          [18, 87],
          [19, 89.5],
          [20, 91.5],
          [21, 93.5],
          [22, 94.5],
          [23, 95],
          [24, 95.5],
          [25, 96],
          [26, 96.5],
          [27, 97],
          [28, 97.5],
          [29, 98],
          [30, 98.5]
        ].map((it)=> SkierEOSPointsSeries(points: max(it[1]-MIN_MEASURE,0), discipline: Discipline.distance, age: it[0]));

    final IPBSprint = (sex == 'F' ? IPBFS : IPBMS).where((it)=>it.age >=minAge && it.age <= maxAge).toList();
    final IPBDistance = (sex == 'F' ? IPBFD : IPBMD).where((it)=>it.age >= minAge && it.age <= maxAge).toList();

    return [
      charts.Series<SkierEOSPointsSeries, String>(
        id: 'IPB Sprint',
        domainFn: (it, _) => it.age.toString(),
        measureFn: (it, _) => it.points,
        data: IPBSprint)..setAttribute(charts.rendererIdKey, 'customTargetLine'),
      charts.Series<SkierEOSPointsSeries, String>(
          id: 'IPB Distance',
          domainFn: (it, _) => it.age.toString(),
          measureFn: (it, _) => it.points,
          data: IPBDistance)..setAttribute(charts.rendererIdKey, 'customTargetLine')
      ] ;


  }
}

class SkierRaces extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<SkierDetailsModel>(ctx);
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(30.0)
      ),
      child: Observer(builder: (_) {
        switch (model.raceResults.status) {
          case FutureStatus.fulfilled:
            final data = model.filteredResults;

            return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (_, index) {
                  final skierRace = data[index];
                  final name = '${skierRace.name} (${skierRace.type})' ;
                  final dist = (skierRace.distanceKm > 0 ? '${skierRace.distanceKm}km ' : '' )+ (skierRace.technique == 'C' ? 'Classic' : (skierRace.technique == 'F' ? 'Skate' : '')).trim();

                  return ListTile(
                    onTap: () {
                      final tbModel = Provider.of<FilterTabbarModel>(ctx);
                      tbModel.addTab(type: TAB_RACE_DETAILS, race: skierRace.race);
                    },
                      dense:true,
                      title: Row(children: [
                          Expanded(child: Tooltip(message: name, child: Text(name, overflow: TextOverflow.ellipsis,))),
                          Text(formatDate(skierRace.date, [mm, '/', dd, '/', yy]), overflow: TextOverflow.ellipsis,)
                        ]),
                      subtitle: Row(children: [
                          Expanded(child: Tooltip(message: skierRace.location, child:Text(skierRace.location, overflow: TextOverflow.ellipsis,))),
                          Text(
                            '$dist Ref: ${skierRace.pointsReference.toStringAsFixed(3)}',
                            style: TextStyle(fontWeight: FontWeight.w100),
                          )
                        ]),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 10),
                          child:Column(
                        children: <Widget>[
                          Text(skierRace.points.toString(), textScaleFactor: .85,),
                          Text(skierRace.rank.toString(), textScaleFactor: .85,)
                        ],
                      )));
                });

          case FutureStatus.pending:
            return Column(
              children: <Widget>[
                LinearProgressIndicator(),
                Text('Fetching Races'),
              ],
            );
            break;
          case FutureStatus.rejected:
            return Text('Error');
            break;
        }

        return Text('err');
      }),
    );
  }
}