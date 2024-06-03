import 'package:flutter/material.dart';
import 'package:weather/consts.dart';
import 'package:weather/service/weather_service.dart';
import 'package:weather/model/current.dart';
import 'package:weather/main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late WeatherService weatherService;
  late Future<List<Weather>> weathers;


  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(API_KEY);
    weathers = fetchData();
  }

  Future<List<Weather>> fetchData() async {
    try {
      var listOfCities = ["Moscow", "Istanbul", "Paris", "London", "New York"];
      List<Future<Weather>> futures = listOfCities.map((city) => weatherService.fetchData(city)).toList();
      List<Weather> results = await Future.wait(futures);
      return results;
    } catch (e) {
      print('Error fetching weather: $e');
      return [];
    }
  }


  Future<void> fetchDue(String cityName) async {
    List<Weather> fetchedWeathers = [];
    Weather weather = await weatherService.fetchData(cityName);
    fetchedWeathers.add(weather);

    setState(() {
      weathers = Future.value(fetchedWeathers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Color(0x00FFFFFF),
          elevation: 10,
          title: Text(
            "Search",
          ),
        ),
        body:
            Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF), Color(0xFF4A91FF)],
                    stops: [0.0, 1.0],
                  ),
                ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Card(
                      elevation: 20,
                      child: TextField(
                        onChanged: (text) {
                          if (text.isEmpty) {
                            fetchData();
                          } else {
                            fetchDue(text);
                          }
                        },
                        style: TextStyle(),
                        decoration: InputDecoration(
                          hintText: "Enter desired city or country",
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Color(0x00FFFF))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                        child: FutureBuilder(
                            future: weathers,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyHomePage(
                                                  city:
                                                  snapshot.data![index].name,
                                                  isNavigated: true,
                                                )));
                                      },
                                      child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data![index].temp}°C",
                                                      style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      width: 80,
                                                      height: 80,
                                                      child: Image.network(
                                                        snapshot.data![index]
                                                            .condition.icon,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data![index].name}, ${snapshot.data![index].region}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                    Text(snapshot
                                                        .data![index].condition.text)
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                    );
                                  },
                                );
                              } else {
                                return Text('Error: ${snapshot.error}');
                              }
                            }))
                  ],
                ),
              )) ,
            );

  }
}
