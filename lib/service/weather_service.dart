import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/model/current.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
const URL = "https://api.weatherapi.com/v1/forecast.json";


class WeatherService {
  String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> fetchData(String cityName) async {
    final lastUrl = "$URL?key=$apiKey&q=$cityName&days=1&aqi=no&alerts=no";
    var response = await http.get(Uri.parse(lastUrl));

    try {
      if (response.statusCode == 200) {
        var jsonVal = json.decode(response.body);
        return Weather.fromJson(jsonVal);
      } else {
        throw Exception("Failed to fetch the data");
      }
    } catch (e) {
      throw Exception("Failed to fetch the data: $e");
    }
  }

  Future<String?> getCurrentCity() async {
     String city;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
           city = placemarks.first.locality!;
           return city;
      }
    } catch (e) {
      throw Exception("Failed to fetch the location $e");
    }

  }

}
