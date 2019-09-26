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
  final List<String>tags = [ "Warming up", "Loopscholing", "Core", "Kern","Mobiliteit","Coordinatie","Kracht","Balans","Arminzet","Schaarbeweging","Storende rotatie","Pasfrequentie","Houding","Vlog","Voeding"];
  List<String> tagFilter = [];
  List<Drill> filteredDrills = [];

  Future<List<Drill>> fetchAllCached() async {
    print("fetchAllCached");
    print(this.drills.length);
    if (this.drills.length==0) {
      this.drills = await storage.readDrills();
print("fetchAllCached 2:");
print(this.drills.length);
      if (await this.isModified()) {
        print("modified");
      } else {
        print("not modified");
      }

      if (this.drills.length ==0) {
        print("fetch from server");
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
      print("is after");
      print(serverSettings.modified);
      print(localSettings.modified);
      print((await storage.readSettings()).modified);
      storage.writeSettings(serverSettings);
      return true;
    } 
    return  false;
  }

  static Future<List<Drill>> fetchAll() async {
    var uri = Endpoint.uri('/drills/');

    final response = await http.get(uri.toString());
    //final response = await http.get("https://api.kettinglopers.nl/drills/");
    //final response = await http.get("https://jsonplaceholder.typicode.com/todos/1");

    // print(response.body)

    //return parseDrills(response.body);
    final parsedJson = json.jsonDecode(response.body);

    final List<Drill> list = new List<Drill>();
    parsedJson['data']['drills'].forEach((v) {
      var drill = Drill.fromJson(v);
      list.add(drill);
    });

    return list;
  }

  void addTagFilter(final String tag) {
    print("add filter:"+tag);
    this.tagFilter.add(tag);
    applyTagFilter();
    notifyListeners();
  }

  void removeTagFilter(final int idx) {
    print("remove filter:"+idx.toString());
    this.tagFilter.removeAt(idx);
    applyTagFilter();
    notifyListeners();
  }

  void applyTagFilter() {
    this.filteredDrills = <Drill>[];
    if (this.tagFilter.length>0) {
      print("check"+this.drills.length.toString());
      this.drills.forEach((_drill) {
          var added = false;
          this.tagFilter.forEach((_tag){
            if (!added && _drill.tags.contains(_tag)) {
print("found.."+_tag);
              this.filteredDrills.add(_drill);
              added = true;
            }
          });
      });
    } else {
      this.filteredDrills = this.drills;
    }
    print(this.tagFilter);
    print(this.drills[0].tags);
    print(this.filteredDrills.length.toString());
  }
}