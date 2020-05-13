import 'package:flutter/foundation.dart';
import 'package:xcp/models/skier.dart';
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/filter-tabbar-model.dart';
import 'package:xcp/tabs/list-tab-model.dart';
import 'package:xcp/tabs/points-list-model.dart';
import 'package:xcp/tabs/skier-details.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:xcp/utils.dart';
import 'package:xcp/widgets/PageContextWrapper.dart';
import 'package:xcp/widgets/closable-details.dart';
import 'package:xcp/widgets/padded-card.dart';


class PointsList extends StatelessWidget {
  PointsList() :
        model = PointsListModel();

  final PointsListModel model;

  @override
  Widget build(BuildContext ctx) =>
      Provider<PointsListModel>.value(
          value: model,
          child: body(ctx)
      );

  Widget body(ctx) {
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);

      return Column(
            children: [
              Expanded(
                child:
                Observer(builder: (_) {
                  final gs = Provider.of<GlobalStore>(ctx);
                  return FutureBuilder<List<Skier>>(
                      future: gs.filterResults(filterContext.skierFilter),

                      builder: (ctx, snp) =>
                      snp.hasData
                          ? getListWidgets(ctx, snp.data)
                          : Flex(direction: Axis.vertical,
                        children: <Widget>[LinearProgressIndicator(), Spacer()],));
                })
              )
            ]
      );

  }

  getListWidgets(ctx, List data) {
    final MQ = MediaQuery.of(ctx),
      isLargeScreen  = MQ.size.width > 600 ? true : false;
    return Row(
      children: [
        Expanded(flex: 3, child: Listener(
            onPointerUp: (PointerUpEvent e){
              print(e);
              print(e.buttons);

            },
            child: getPointsList(ctx, data, isLargeScreen))
        ),
        isLargeScreen ? Expanded(flex: 7 , child: DetailsWrapper(data)) : Container()
      ],
    );
  }
}


class DetailsWrapper extends StatelessWidget {
  DetailsWrapper(this.data);

  final List data;
  @override
  Widget build(BuildContext ctx) {
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);
    final gs = Provider.of<GlobalStore>(ctx);


    return Observer(builder: (_) {
      final id = filterContext.selectedSkierId;
      final skier = gs.bundle.value.skiers[id];
      return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: ClosableDetails(
              closable: skier != null,
              options: kIsWeb ? FlatButton( child: Icon(Icons.file_download),  onPressed: ()=> exportList(filterContext.skierFilter.filterName(), data)) : null,
              title: skier == null ?  'Current Filter: ${filterContext.skierFilter.toString()} Skiers in List: ${data.length}' :'Skier Details',
              child: skier == null ? ListSummaryDetails(data: data) :  SkierDetails(skier))
      );
    });
  }
}

exportList(String baseName, List<Skier> data) {

  String line = '';
  String header = 'cplId,firstName,lastName,sex,yob,club,distancePoints,distanceRaceCount,sprintPoints,sprintRaceCount,rollingDistancePoints,rollingDistanceRaceCount,rollingSprintPoints,rollingSprintRaceCount';
  String csv = header + '\n';

  data.forEach((it){
     line = '${it.id}, "${it.firstname}", "${it.lastname}", ${it.sex}, ${it.yob}, "${it.clubCountry}", ${it.distancePoints.cpl.avg}, ${it.distancePoints.cpl.raceCount}, ${it.sprintPoints.cpl.avg}, ${it.sprintPoints.cpl.raceCount}, ${it.distancePoints.rolling.avg}, ${it.distancePoints.rolling.raceCount}, ${it.sprintPoints.rolling.avg}, ${it.sprintPoints.rolling.raceCount}';
     csv += line + '\n';
  });

  listDownload('Skier Points $baseName.csv', csv);

}





class ListSummaryDetails extends StatelessWidget {
  const ListSummaryDetails({
    Key key,
    @required this.data,
  }) : super(key: key);

  final List data;

  @override
  Widget build(BuildContext ctx) {

    return PaddedCard(
      child: SummaryPointsGraph(data),
    );
  }
}

class SummaryPointsGraph extends StatelessWidget {
  SummaryPointsGraph(this.data);

  final List<Skier> data;
  static const MIN_MEASURE = 70.0;

  @override
  Widget build(BuildContext ctx) {
      final dataBy = groupBy<Skier, int>(data, (it) => it.age).entries.where((it)=>it.key < 100).toList();
          dataBy.sort((a,b) => a.key.compareTo(b.key));
      final ts =  charts.Series<MapEntry, String>(
                  id: ' Age',
                  domainFn: (it, _) => it.key.toString(),
                  measureFn: (it, _) => it.value.length,
                  data: dataBy);

      return charts.BarChart([ts], behaviors: [charts.ChartTitle('# Skiers by Age in Years')],);
    }
  }


Widget getPointsList(ctx, List<Skier> data, bool wideScreen) {
    final filterContext = Provider.of<SkierFilterContextModel>(ctx),
        filter = filterContext.skierFilter,
        pd = filter.pointsDiscipline,
        pt = filter.pointsListType;

    return ListView.builder(

        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (_, index) {
          final skier = data[index];
          final club = skier.club;
          final points = skier.avgPointsFor(pd, pt);


          return Observer( builder: (ctx)=>Container(
            decoration: BoxDecoration(
              border:  filterContext.selectedSkierId == skier.id
                  ? Border(top: BorderSide(), bottom: BorderSide())
                  : Border.fromBorderSide(BorderSide.none)
            ),
            child: ListTile(
               dense:true,
               selected: filterContext.selectedSkierId == skier.id,
                onTap: () {
                  filterContext.selectedSkierId = skier.id;
                  if(!wideScreen) {
                      Navigator.push(ctx, MaterialPageRoute(
                        builder: (_) => PageContextWrapper(ctx, 'Skier Details', () => SkierDetails(skier))
                      ));
                  }
                },

                onLongPress: () {
                  final tbModel = Provider.of<FilterTabbarModel>(ctx, listen: false);
                  tbModel.addTab(type: TAB_SKIER_DETAILS, skier: skier);
                },
                leading: Text((index + 1).toString()),
                title: Text(
                    '${skier.firstname + ' ' + skier.lastname + ' `' +
                        skier.yob.toString().substring(2)}', overflow: TextOverflow.ellipsis,),
                subtitle: Text(club.isNone
                    ? skier.nation
                    : club.name + ', ' + club.province, overflow: TextOverflow.ellipsis,),
                trailing: points != null
                    ? Text(points.toStringAsFixed(2))
                    : null),
          ));
        }
    );
  }

