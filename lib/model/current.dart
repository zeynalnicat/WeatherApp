

import 'condition.dart';

class Weather {
  double temp;
  Condition condition;
  double wind_kph;
  int humidity;
  String name ;
  String region ;

  Weather(this.temp, this.condition, this.wind_kph, this.humidity,this.name , this.region);

  factory Weather.fromJson(Map<String, dynamic> json) {
    var name = json["location"]["name"];
    var region = json["location"]["country"];
    json = json["current"];
    Condition cond = Condition.fromJson(json["condition"]);
    return Weather(json["temp_c"] as double, cond, json["wind_kph"] as double,
        json["humidity"] as int,name,region);
  }
}
