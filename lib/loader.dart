import 'dart:convert';

import 'package:xcp/db.dart';
import 'package:xcp/models/race-result.dart';
import 'package:xcp/models/race.dart';
import 'package:xcp/models/rolling-points.dart';
import 'package:xcp/models/skier-points.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:xcp/models/bundle.dart';

import 'package:xcp/models/skier-race.dart';
import 'package:xcp/models/skier.dart';



Future<Bundle> fetchBundle() async {
    List<Future<Object>> w = [ getInit(), getRollingPoints()];
    List<Object> f = await Future.wait<Object>(w);
    DB().endBig();
    Bundle bundle = f[0] as Bundle;
    List<RollingPoints> rp = f[1] as List<RollingPoints>;


    rp.forEach((it) {
      final skier = bundle.skiers[it.skierId];
      skier.updateRolling(it.discipline, it.points);
    });
    return bundle;
}

Future<Bundle> getInit() async {
  final db =  DB();
  await db.beginBig();
  String data = await db.getBig('bundle');
  if (data.isEmpty) {
    final response = await http.get('https://www.xcracer.info/api/init4');
    db.setBig('bundle', response.body);
    data = response.body;
  }
  return compute(parseBundle, data);
}

Future<List<RollingPoints>> getRollingPoints() async {
  final response = await http.get('https://www.xcracer.info/api/rollingPoints3');
  return compute(parseRollingPoints, response.body);
}



Bundle parseBundle(String data) {
  final parsed = json.decode(data);
  return  Bundle.fromJson(parsed);
}

List<RollingPoints> parseRollingPoints(String data) {
  final parsed = json.decode(data);
  return  RollingPoints.fromListJson(parsed);
}





Future<List<SkierRace>> fetchSkierRaces(id) async {
  final response =  await http.get('https://www.xcracer.info/api/races3/$id');
  return compute(parseSkierRaces, response.body);
}

Future<List<SkierPointsSeries>> fetchSkierPoints(id) async {
  final response =  await http.get('https://www.xcracer.info/api/timeseries/points/$id');
  return compute(parseSkierPointsSeries, response.body);
}

Future<List<SkierEOSPointsSeries>> fetchEOSPointsSeries(id) async {
  final response =  await http.get('https://www.xcracer.info/api/timeseries/eospoints/$id');
  return compute(parseSkierEOSPointsSeries, response.body);
}

Future<Race> fetchRaceDetails(id) async {
  final response =  await http.get('https://www.xcracer.info/api/race/$id');
  return compute(parseRaceDetails, response.body);
}

Future<List<RaceResult>>fetchRaceResults(id) async {
  final response =  await http.get('https://www.xcracer.info/api/race/results/$id');
  return compute(parseRaceResults, response.body);
}


List<SkierRace> parseSkierRaces(String data) {
  final parsed = json.decode(data);
  return  SkierRace.fromRacesJson(parsed);
}

List<SkierPointsSeries> parseSkierPointsSeries(String data) {
  final parsed = json.decode(data);
  return  SkierPointsSeries.fromListJson(parsed);
}

List<SkierEOSPointsSeries> parseSkierEOSPointsSeries(String data) {
  final parsed = json.decode(data);
  return  SkierEOSPointsSeries.fromListJson(parsed);
}

Race parseRaceDetails(String data) {
  final parsed = json.decode(data);
  return Race.fromJson(parsed['race'][0]);
}

List<RaceResult>  parseRaceResults(String data) {
  final parsed = json.decode(data);
  return RaceResult.fromListJson(parsed)..sort((a,b)=>a.rank.compareTo(b.rank));
}

