import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:xcp/models/skier.dart';
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/filter-tabbar-model.dart';
import 'package:xcp/tabs/free-form-list-builder-model.dart';
import 'package:xcp/tabs/list-tab-model.dart';
import 'package:xcp/tabs/skier-details.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';
import 'package:xcp/widgets/PageContextWrapper.dart';

class FreeFormListBuilder extends StatelessWidget {

  final FreeFormListBuilderModel model = FreeFormListBuilderModel();
  @override
  Widget build(BuildContext context) {


    return Column(children: <Widget>[
      TextField(
        controller: model.controller,
      maxLines: 10,
        onChanged: (v) => model.csvList = v,
    ),
    Expanded(child: GeneratedFreeFormSkierList(model:model))]);


  }

}

class GeneratedFreeFormSkierList  extends StatelessWidget{
  final FreeFormListBuilderModel model;

  const GeneratedFreeFormSkierList({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext ctx) {
   return Observer( builder:(_) {
     final MQ = MediaQuery.of(ctx),
         isLargeScreen  = MQ.size.width > 600 ? true : false;
     final gs = Provider.of<GlobalStore>(ctx);
     final List<Skier> skiers = model.list(gs.skiers, model.parsedNames);

     return getPointsList(ctx, skiers, isLargeScreen);


   });

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
              trailing: points != null
                  ? Text(points.toStringAsFixed(2))
                  : null),
        ));
      }
  );
}