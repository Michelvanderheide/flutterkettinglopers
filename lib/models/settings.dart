import 'package:http/http.dart' as http;
import '../endpoint.dart';
import 'dart:convert' as json;

class Settings  {
  final String modified;

  const Settings({
    this.modified
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    print("fromJson");
    if (json == null)
      return new Settings();

    return Settings(
      modified: json['modified'],
    );
  }

  Map<String, dynamic>toJson() {
    print("toJson");
    return {
      "modified": modified,
    };
  }

  static Future<Settings> fetch() async {
    var uri = Endpoint.uri('/settings/');

    final response = await http.get(uri.toString());
    final parsedJson = json.jsonDecode(response.body);
print("settings:");
print(parsedJson);
    final Settings settings = Settings.fromJson(parsedJson['data']);
print(settings);

    return settings;
  }


}