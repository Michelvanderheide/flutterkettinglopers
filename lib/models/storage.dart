import 'dart:async';
import 'dart:io';
import 'drill.dart';
import 'settings.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert' as json;

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localDrillsFile async {
    final path = await _localPath;
    return File('$path/drills.json');
  }
  Future<File> get _localSettingsFile async {
    final path = await _localPath;
    return File('$path/settings.json');
  }

  Future<List<Drill>> readDrills() async {
    try {
      final file = await _localDrillsFile;

      // Read the file
      String contents = await file.readAsString();
      print("read drills from local");
      //print(contents);
      List<Drill> list = new List<Drill>();
      json.jsonDecode(contents).forEach((v) {
        var drill = Drill.fromJson(v);
        list.add(drill);
      });
      return list;
    } catch (e) {
      print("error");
      print(e);
      // If encountering an error, return 0
      return new List<Drill>();
    }
  }

  Future<File> writeDrills(List<Drill> drills) async {
    final file = await _localDrillsFile;

    print("write drills to local");
    // Write the file
    return file.writeAsString(json.jsonEncode(drills));
  }

  Future<Settings> readSettings() async {
    try {
      final file = await _localSettingsFile;

      // Read the file
      String contents = await file.readAsString();
print("readSettings.contents");
print(contents);
      Settings result = Settings.fromJson(json.jsonDecode(contents));
print(result);
      return result;
    } catch (e) {

      print("error:");
      print(e);
      // If encountering an error, return 0
      return new Settings();
    }
  }

  Future<File> writeSettings(Settings settings) async {
    final file = await _localSettingsFile;

    // Write the file
    return file.writeAsString(json.jsonEncode(settings));
  }


}