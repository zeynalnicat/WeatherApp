import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather/consts.dart';
import 'package:weather/model/current.dart';
import 'package:intl/intl.dart';
import 'package:weather/ui/search.dart';
import 'service/weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(city: "",isNavigated: false,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String city ;
  bool isNavigated = false;
  MyHomePage({super.key,required this.city,required this.isNavigated});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WeatherService weatherService;
  late Future<Weather> futureWeather;
  late Future<String?> city;


  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(API_KEY);
    if(widget.city.isEmpty){
      city = weatherService.getCurrentCity();
      futureWeather = weatherService.fetchData(city.toString());
    }else{
      futureWeather = weatherService.fetchData(widget.city);
    }

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    final now = DateTime.now();

    final formattedDate = DateFormat('EEEE, d MMMM').format(now);
    return Scaffold(
      appBar: (widget.isNavigated)? AppBar(
        title: Text(""),
        backgroundColor: Color(0xFFF),
        elevation: 10,
      ) : null,

        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF), Color(0xFF4A91FF)],
                stops: [0.0, 1.0],
              ),
            ),
          child: FutureBuilder<Weather>(
              future: futureWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:CircularProgressIndicator() ,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return SafeArea(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          SizedBox(
                              height: 80,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                                },
                                child: Card.filled(
                                    elevation: 4,
                                    color: Color(0xFF4A91FF),
                                    margin: EdgeInsets.all(10),
                                    borderOnForeground: true,
                                    child: Container(
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xFFF), Color(0xFFF)],
                                      stops: [0.0, 1.0],
                                    ),
                                ),
                                      child:Padding(
                                        padding: EdgeInsets.only(right: 12, left: 12),
                                        child: Row(

                                          children: [
                                            Icon(Icons.location_on_outlined,color: Colors.white,),
                                            SizedBox(width: 10,),
                                            Text(
                                              "${snapshot.data!.name} / ${snapshot.data!
                                                  .region}", style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,color: Colors.white),),

                                          ],
                                        ),
                                      ) ,
                                    )
                                ) ,
                              )
                          ),

                          SizedBox(height: 50,),

                          SizedBox(
                            width: 300,
                            height: 200,
                            child: Image.network(
                                snapshot.data!.condition.icon, fit: BoxFit.cover),
                          ),

                          SizedBox(height: 50,),

                          SizedBox(
                            width: width,
                            child: Card.filled(
                              child: Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              gradient: LinearGradient(
                              begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFF), Color(0x00FFFFFF)],
                                stops: [0.0, 1.0],
                              ),
                            ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 15,),
                                    Text(formattedDate),
                                    Text("${snapshot.data!.temp.toInt()}°C",
                                      style: TextStyle(fontSize: 80),),
                                    Text(snapshot.data!.condition.text,
                                      style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Icon(Icons.wind_power_outlined),
                                        SizedBox(width: 10,),
                                        Text("Wind"),
                                        SizedBox(width: 40,),
                                        Divider(height: 10,
                                          thickness: 2,
                                          color: Colors.white,),
                                        Text("${snapshot.data!.wind_kph
                                            .toString()} km/h")

                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.water_drop_outlined),
                                        SizedBox(width: 10,),
                                        Text("Hum"),
                                        SizedBox(width: 80,),


                                        Divider(height: 10,
                                          thickness: 2,
                                          color: Colors.black,),
                                        Text("${snapshot.data!.humidity} %"),

                                      ],
                                    ),

                                    SizedBox(height: 15 ,)

                                  ],
                                ),
                              )
                            ),
                          ),

                        ],
                      )));
                } else {
                  return Text('No data available');
                }
              })) ,
        );
  }
}
