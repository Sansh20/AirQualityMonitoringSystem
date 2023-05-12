import 'dart:html';

import 'package:airqualitymonitor/services/fetch_data.dart';
import 'package:airqualitymonitor/services/sensor_data.dart';
import 'package:flutter/material.dart';
import 'package:airqualitymonitor/widgets/air_quality_comp.dart';
import 'package:airqualitymonitor/widgets/historical_data_comp.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<SensorData> sensorData;
  bool showHistData = false;

  double histPositionIdx = 0;

  @override
  void initState() {
    super.initState();
    sensorData = fetchSensorData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool tinyWindow = size.height < window.screen!.height! - 100;

    if (size.height >= size.width || tinyWindow) {
      // height = (tinyWindow) ? size.height / 1.6 : size.height / 3.8;
      // width = size.width - 30;
      // countOfColums = 3;
      // aspectRatio = 1 / 0.6;
      // // aspectRatio = 1;
      // addValH = -10;
      // addValW = 0;
      histPositionIdx = 0;
    } else {
      // height = size.height / 4.0;
      // width = size.width - 30;
      // countOfColums = 5;
      // aspectRatio = 1;
      // addValH = 0;
      // addValW = 250;
      histPositionIdx = -20;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Air Quality Monitor"),
        titleTextStyle: Theme.of(context).textTheme.headline1,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              height: 330,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  if (showHistData)
                    Align(
                      alignment: Alignment.bottomCenter,
                      // top: 100,
                      child: FutureBuilder(
                        future: fetchHistoricalData(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return HistoricalDataComponent(
                                // onPressed: () {
                                //   print(
                                //       "${snapshot.data![1]!["sensorData"].aqi} ${snapshot.data![1]!["isTapped"]}");
                                // },
                                histData: snapshot.data!,
                              );
                            } else if (snapshot.hasError) {
                              return const Text("Failed to Load Data");
                            }
                          }
                          return const CircularProgressIndicator();
                        }),
                      ),
                    ),
                  FutureBuilder(
                    future: sensorData,
                    builder: (BuildContext context,
                        AsyncSnapshot<SensorData> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          return AirQualityComponent(
                            sensorData: snapshot.data!,
                            reloadOnPressed: () {
                              setState(() {
                                sensorData = fetchSensorData();
                              });
                            },
                            histDataOnPressed: () {
                              setState(
                                () {
                                  showHistData = !showHistData;
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Text("Failed to Load Data");
                        }
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
