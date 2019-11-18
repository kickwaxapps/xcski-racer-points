import 'package:app/models/skier.dart';
import 'package:app/tabs/filter-form/filter-model.dart';


class SkierFilter {

  SkierFilter({

      PointsDiscipline pointsDiscipline,
      PointsListType pointsListType,
      String searchString,
      int sex,
      Set yobs,
      Set nations,
      Set regions
     }):
        this.pointsDiscipline  = pointsDiscipline ?? PointsDiscipline.distance,
        this.pointsListType  = pointsListType ?? PointsListType.lastPublished,

        this.sex = sex ?? 0,
        this.searchString = searchString ?? '',
        this.yobs =  yobs ?? Set<int>(),
        this.nations = nations ?? Set<String>(),
        this.regions = regions ?? Set<String>();


  factory SkierFilter.from( FilterModel filter ) {
    return SkierFilter(
      pointsDiscipline: filter.pointDiscipline,
      pointsListType: filter.pointsListType,
      sex: filter.sex,
      searchString: filter.searchStringController.text,
      yobs: filter.yobs.where((it)=>it.enabled).map((it)=>it.filterValue).toSet(),
      nations: filter.nations.where((it)=>it.enabled).map((it) => it.filterValue).toSet(),
      regions: filter.regions.where((it)=>it.enabled).map((it) => it.filterValue).toSet()

    );
  }

  factory SkierFilter.fromJson( json ) {
    return SkierFilter(
        pointsDiscipline: PointsDiscipline.values[json['pointsDiscipline']??0],
        pointsListType: PointsListType.values[json['pointsListType']??0],
        sex: json['sex'],
        searchString: json['searchString'],
        yobs: Set.from(json['yobs'] as List ?? []),
        nations: Set.from(json['nations'] as List ?? []),
        regions: Set.from(json['regions'] as List ?? []),
    );
  }

  final PointsDiscipline pointsDiscipline;
  final PointsListType pointsListType;


  final Set yobs;
  final Set nations;
  final Set regions;
  final String searchString;
  final int sex;

  List<Skier> getResults(List<Skier> skiers)  {

    final
      sexC =  sex > 0 ? ["F","M"][sex-1] : '',
      test = (s) {
      if (s.distancePoints.avgPoints == null) return false;
      if (sex > 0 && s.sex != sexC) return false;
      if (yobs.length > 0 && !yobs.contains(s.yob)) return false;
      if (regions.length > 0 && !regions.contains(s.club.province ?? 'XX')) return false;
      if (nations.length > 0 && !nations.contains(s.distancePoints.nation)) return false;
      if (searchString.length > 0 && !(s.firstname+s.lastname+s.club.name).contains(searchString)) return false;
      return true;
    };


    final filteredList  = skiers.where((s) => test(s)).toList();
    final pd = pointsDiscipline,
      pt = pointsListType;
    filteredList.sort( (s0,s1) => s1.avgPointsFor(pd,pt).compareTo(s0.avgPointsFor(pd,pt)) );
    return  filteredList;
  }


  Future<List<Skier>> results(List<Skier> skiers) {
    return Future.value(getResults( skiers) );
  }

  String toString() {
    String
        d = pointsDiscipline.toString().split('.').last,
        r = regions.join(','),
        n = nations.join(','),
        s = sex == 1 ? 'F' : (sex == 2) ? 'M' : '',
        b = yobs.map( (it)=>it.toString().substring(2)).join(','),
        t = (s+b+' '+n+' '+r).trim();
    return d+ ' ' + (t.length > 0 ? t : 'All' );
  }

  Map get toJson => {
    'pointsDiscipline': pointsDiscipline.index,
    'pointsListType': pointsListType.index,

    'yobs': yobs.toList(),
    'nations': nations.toList(),
    'regions': regions.toList(),
    'searchString':searchString,
    'sex':sex
  };



}