// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class Player {
  static const String apiBase = '673e0bb20118dbfe8609eb1e.mockapi.io';

  final String name;
  String? imageUrl;
  String? position;
  DateTime? debut;
  int? totalCaps;

  int rating = 10;

  Player(this.name);

  Future getImageUrl() async {
    if (imageUrl != null) {
      return;
    }
    HttpClient http = HttpClient();

    try {
      var uri = Uri.https(apiBase,'/api/v1/players', {'name': name});
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      List data = json.decode(responseBody);
      imageUrl = data[0]['img'];
      totalCaps = data[0]['totalCaps'];
      position = data[0]['position'];
      debut = dateFromString(data[0]['debut'].toString());

    } catch (exception) {
      print(exception);
    }
  }

  DateTime dateFromString(String date){
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));
    return DateTime(year, month, day);
  }

  @override
  String toString() {
    return 'Player{name: $name, imageUrl: $imageUrl, position: $position, debut: $debut, totalCaps: $totalCaps, rating: $rating}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
