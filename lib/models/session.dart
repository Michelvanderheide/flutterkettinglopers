import 'package:http/http.dart' as http;
import './drill.dart';
import '../endpoint.dart';

/// Represents a tourism location a user can visit.
class Session {
  final int id;
  final String description;
  final String summary;
  final List<Drill> drills;

  Session(
    this.id,
    this.description,
    this.summary,
    this.drills
  );

/*
interface TrainingSession {
  id: string;
  description: string;
  userGroupName: string;
  show: boolean;
  intervals: string;
  summary: string;
  warmingup: string;
  core: string;
  loopscholing: string;
  kern: string;
  drills: Drill[];
  groups: Group[];
}
*/
  static Future<List<Session>> fetchAll() async {
    var uri = Endpoint.uri('/locations');

    final resp = await http.get(uri.toString());

    print('response is $resp');
    return null;
  }

}
