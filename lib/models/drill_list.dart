import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../endpoint.dart';
import 'storage.dart';
import 'settings.dart';
import 'dart:convert' as json;



import 'drill.dart';

class DrillList extends ChangeNotifier {
  final Storage storage = Storage(); 
  List<Drill> drills = [];
  final List<String>tags = [ "Warming up", "Loopscholing", "Core","Mobiliteit","Coordinatie","Kracht","Balans","Arminzet","Schaarbeweging","Storende rotatie","Pasfrequentie","Houding","Vlog","Voeding"];
  List<String> tagFilter = [];
  List<Drill> filteredDrills = [];

  Future<List<Drill>> fetchAllCached() async {
    if (this.drills.length==0) {
      this.drills = await storage.readDrills();
      bool modified = false;
      if (await this.isModified()) {
        modified = true;
      }

      if (modified || this.drills.length ==0) {
        this.drills = await DrillList.fetchAll();
        storage.writeDrills(this.drills);
      } else {
        print ("fetch from local storage");
      }
      this.applyTagFilter();
    }
    return this.filteredDrills;
  }

  Future<bool> isModified() async {
    Settings serverSettings = await Settings.fetch();
    Settings localSettings = await storage.readSettings();
    var serverDate = DateTime.parse(serverSettings.modified);

    if (localSettings.modified == null || serverDate.isAfter(DateTime.parse(localSettings.modified))) {
      storage.writeSettings(serverSettings);
      return true;
    } 
    return  false;
  }

  static Future<List<Drill>> fetchAll() async {
    var uri = Endpoint.uri('/drills/');

    final response = await http.get(uri.toString());
    final parsedJson = json.jsonDecode(response.body);

    final List<Drill> list = new List<Drill>();
    parsedJson['data']['drills'].forEach((v) {
      var drill = Drill.fromJson(v);
      list.add(drill);
    });

    return list;
  }

  void toggleTagFilter(final String tag) {
    if (this.tagFilter.contains(tag)) {
      this.tagFilter.remove(tag);
    } else {
      this.tagFilter.add(tag);
    }
    applyTagFilter();
    notifyListeners();
  }

  void removeTagFilter(final String tag) {
    this.tagFilter.remove(tag);
    applyTagFilter();
    notifyListeners();
  }

  void applyTagFilter() {
    this.filteredDrills = <Drill>[];
    if (this.tagFilter.length>0) {
      this.drills.forEach((_drill) {
        var added = false;
        this.tagFilter.forEach((_tag){
          if (!added && _drill.tags.contains(_tag)) {
            this.filteredDrills.add(_drill);
            added = true;
          }
        });
      });
    } else {
      this.filteredDrills = this.drills;
    }
  }
}