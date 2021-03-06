import 'package:xcp/models/skier.dart';
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/filter-form/filter-model.dart';
import 'package:xcp/tabs/filter-form/region-filter-model.dart';
import 'package:xcp/tabs/filter-form/yob-filter-model.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:xcp/classes/filter.dart';



class Filter extends StatelessWidget {
  Filter(this.filterContextModel):
      model = FilterModel(filterContextModel.skierFilter);
  final SkierFilterContextModel filterContextModel;
  final FilterModel model;

  @override
  Widget build(BuildContext ctx) =>
      MultiProvider( providers: [
        Provider<FilterModel>.value(value: model),
        Provider<SkierFilterContextModel>.value(value: filterContextModel)
      ],
      child: FilterMenu());
}

class FilterMenu extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
   return  PopupMenuButton(

       tooltip:'Tap for more options',
       offset: Offset(50,50),
       icon: Icon(Icons.filter_list, color: Colors.blueAccent,),
       itemBuilder: (_)=> [
         PopupMenuItem(child: Center(child: Text('Fitler Settings'))),
         PopupMenuItem(child: ClearFilter(ctx)),
         PopupMenuItem(child: SearchString(ctx)),
         PopupMenuItem(child: ChipOptions(ctx)),
         PopupMenuItem(child: ChipFilters(ctx)),
      ]
   );

  }
}


abstract class FilterItem extends StatelessWidget {

  FilterItem(this.ctx);
  final ctx;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return doBuild(ctx);
  }

  doBuild(BuildContext ctx);

}

class ClearFilter extends FilterItem {
  ClearFilter(ctx) : super(ctx);

  @override
  Widget doBuild(BuildContext ctx) {
    final filter = Provider.of<FilterModel>(ctx);
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);

    return ActionChip(
      label: Wrap(children:[Text('Clear Filter',),Icon(Icons.clear_all)]),
      onPressed: () {
        filter.clear();
        filterContext.skierFilter = SkierFilter();
      },
    );
  }
}


class ChipOptions extends FilterItem {
  ChipOptions(ctx) : super(ctx);


  @override
  Widget doBuild(BuildContext ctx) {
    return Wrap(children:getPointsConfig(ctx));
  }

  List<Widget> getPointsConfig(ctx) {
    final filter = Provider.of<FilterModel>(ctx),
        filterContext = Provider.of<SkierFilterContextModel>(ctx);
        filter.pointDiscipline = filterContext.skierFilter.pointsDiscipline;
        filter.pointsListType = filterContext.skierFilter.pointsListType;
        filter.sex = filterContext.skierFilter.sex;
    return [
      ...List.generate(PointsDiscipline.values.length, (i) {
        return Observer(
          builder: (_) => ChoiceChip(
              label:
              Text(PointsDiscipline.values[i].toString().split('.').last),
              selected: filterContext.skierFilter.pointsDiscipline == PointsDiscipline.values[i],
              onSelected: (b) {
                filter.pointDiscipline = b ? PointsDiscipline.values[i] : null;
                filterContext.skierFilter = SkierFilter.from(filter);
              }),
        );
      }).toList(),
      ...List.generate(PointsListType.values.length, (i) {
        return Observer(
          builder: (_) {
              return ChoiceChip(
              label: Text(PointsListType.values[i].toString().split('.').last),
              selected: filterContext.skierFilter.pointsListType == PointsListType.values[i],
              onSelected: (b) {
                filter.pointsListType = b ? PointsListType.values[i] : null;
                filterContext.skierFilter = SkierFilter.from(filter);
              });},

        );
      }).toList(),
    ];
  }

}

class ChipFilters  extends FilterItem {
  ChipFilters(ctx) : super(ctx);


  @override
  Widget doBuild(BuildContext ctx) => Wrap(children: [
        ...getSexes(ctx),
        ...getYobs(ctx),
        ...getNations(ctx),
        ...getRegions(ctx)
      ]);

  List getSexes(ctx) {
    final filter = Provider.of<FilterModel>(ctx);
    final cbs = [1, 2]
        .map((it) => Observer(
            builder: (_) {
              final filterContext = Provider.of<SkierFilterContextModel>(ctx);
              var sex = filterContext.skierFilter.sex;
              return FilterChip(
                  avatar: CircleAvatar(child: Text('')),
                  label: Text(["Female", "Male"][it - 1]),
                  selected: (it & sex) != 0,
                  onSelected: (v) {
                    filter.sex ^= it;
                    filterContext.skierFilter = SkierFilter.from(filter);
                  });
            }))
        .toList();
    return cbs;
  }



  List getYobs(ctx) {
    final filter = Provider.of<FilterModel>(ctx),
        yobs = filter.yobs,
        filterContext = Provider.of<SkierFilterContextModel>(ctx),
        compiledYobs = filterContext.skierFilter.yobs,
        now = DateTime.now().year;
    yobs.clear();
    yobs.addAll(List<YOBFilterModel>.generate(11, (i) {
      final year = now - (14 + i);
      return YOBFilterModel(
          filterValue: year,
          displayValue: year.toString().substring(2),
          enabled: compiledYobs.contains(year));
    }));

    final cbs =
        filter.yobs.map((it) => makeChip(filterContext, filter, it)).toList();

    return cbs;
  }

  List getNations(ctx) {
    final filter = Provider.of<FilterModel>(ctx),
        filterContext = Provider.of<SkierFilterContextModel>(ctx),
        global = Provider.of<GlobalStore>(ctx),
        nations = global.bundle.
          value.nations.where((it)=> it.abbrev.isNotEmpty && 'CAN,USA,RUS,NOR,USA,SWE,FIN,GER,SUI,ITA'.contains(it.abbrev)).map((it) => RegionFilterModel(
            filterValue: it.abbrev,
            displayValue: it.abbrev,
            enabled: filterContext.skierFilter.nations.contains(it.abbrev))).toList();

    nations.sort((i0,i1)=>i0.displayValue.compareTo(i1.displayValue));
    filter.nations.clear();
    filter.nations.addAll(nations);

    final cbs = filter.nations.map((it) {
      final cb = makeChip(filterContext, filter, it);

      return cb;
    }).toList();

    return cbs;
  }
}

List getRegions(ctx) {
  final filter = Provider.of<FilterModel>(ctx),
      filterContext = Provider.of<SkierFilterContextModel>(ctx),
      global = Provider.of<GlobalStore>(ctx),
      nations = global.bundle.value.regions
          .where((it)=> it.abbrev.isNotEmpty)
          .map((it) => RegionFilterModel(
          filterValue: it.abbrev,
          displayValue: it.abbrev,
          enabled: filterContext.skierFilter.regions.contains(it.abbrev))).toList();

  nations.sort((i0,i1)=>i0.displayValue.compareTo(i1.displayValue));

  filter.regions.clear();
  filter.regions.addAll(nations);

  final cbs = filter.regions.map((it) {
    final cb = makeChip(filterContext, filter, it);

    return cb;
  }).toList();

  return cbs;
}

class SearchString  extends FilterItem {
  SearchString(ctx) : super(ctx);

  @override
  Widget doBuild(BuildContext ctx) {
    final filter = Provider.of<FilterModel>(ctx);
    final ctr = filter.searchStringController;
    final filterContext = Provider.of<SkierFilterContextModel>(ctx);


    final set = (v) {
       // filter.searchString = v;
        filterContext.skierFilter = SkierFilter.from(filter);
      };

    final clear = () {
        ctr.clear();
        filterContext.skierFilter = SkierFilter.from(filter);
      };

    return TextField(
          //initialValue: filter.searchString,
          controller: ctr,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(16),
              labelText: 'Text Filter',
              hintText: 'Enter a search term',
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear), onPressed: () => (Future.microtask( (){clear(); return 0;}) )),
          ),
          onChanged: (v) => Future.microtask( (){set(v); return 0;}));
  }

}

Observer makeChip(
    SkierFilterContextModel filterContext, FilterModel filter, it) {
  return Observer(
      builder: (_) {
        return FilterChip(
            avatar: CircleAvatar(child: Text('')),
            label: Text(it.displayValue),
            selected: it.enabled,
            onSelected: (v) {
              it.enabled = v;
              filterContext.skierFilter = SkierFilter.from(filter);
            });
      });
}