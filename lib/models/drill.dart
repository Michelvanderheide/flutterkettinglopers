import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../endpoint.dart';
import 'dart:convert' as json;


/* class DrillList {
  final List<Drill> drills;

  DrillList({
    this.drills,
  });

  factory DrillList.fromJson(List<Drill> parsedJson) {

    List<Drill> drills = new List<Drill>();
    drills = parsedJson.map((i)=>Drill.fromJson(i)).toList();

    return new DrillList(
       drills: drills,
    );
  }

} */

/// Represents a tourism location a user can visit.
class Drill  {
  final int id;
  final String title;
  final String description;
  final String imgUrl;
  //final List<String> tags;
  final String videoUrl;
  final String thumbimage;

  const Drill({
    this.id,
    this.title,
    this.description,
    this.imgUrl,
    //this.tags,
    this.thumbimage,
    this.videoUrl
  });

  factory Drill.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return new Drill();

    return Drill(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      thumbimage: json['thumbimage'],
      videoUrl: json['videoUrl'],
    );
  }

  static Future<List<Drill>> fetchAll() async {
    var uri = Endpoint.uri('/drills/');

    final response = await http.get(uri.toString());
    //final response = await http.get("https://api.kettinglopers.nl/drills/");
    //final response = await http.get("https://jsonplaceholder.typicode.com/todos/1");

    // print(response.body)

    //return parseDrills(response.body);
    final parsedJson = json.jsonDecode(response.body);

    //print(parsedJson);
/*     parsedJson['data'].forEach((key,value) => (key, value) {
      print("$key");
    });
 */  

    final List<Drill> list = new List<Drill>();
    parsedJson['data']['drills'].forEach((v) {
      var drill = Drill.fromJson(v);
      list.add(drill);
    });
    
    
/*     parsedJson['data']['drills'].map((i) {
      var drill = Drill.fromJson(i);
            return drill;
    }).toList();
 */
    //print(list);
    return list;
  }

}
