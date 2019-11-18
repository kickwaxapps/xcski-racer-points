import 'dart:async';
import 'dart:convert';


import 'package:app/models/race-result.dart';
import 'package:app/models/race.dart';
import 'package:app/models/skier-points.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:app/models/bundle.dart';

import 'package:app/models/skier-race.dart';


Future<Bundle> fetchBundle() async {
  final response =  await http.get('https://www.xcracer.info/api/init3');
  return compute(parseBundle, response.body);
}

Bundle parseBundle(String data) {
  final parsed = json.decode(data);
  return  Bundle.fromJson(parsed);
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

