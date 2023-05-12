import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:airqualitymonitor/services/sensor_data.dart';

Future<SensorData> fetchSensorData() async {
  final response = await http.get(Uri.parse("http://localhost:3000/fetchData"));
  print(response.body);
  if (response.statusCode == 200) {
    return SensorData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to Fetch Data");
  }
}

Future<Map<int, Map<String, dynamic>>> fetchHistoricalData() async {
  final response =
      await http.get(Uri.parse("http://localhost:3000/fetchHistData"));
  print(response.body);
  DateTime today = DateTime.now();
  var histDataMap = <int, Map<String, dynamic>>{};
  if (response.statusCode == 200) {
    var histData = jsonDecode(response.body);
    if (histData.isEmpty) {
      return histDataMap;
    }
    for (Map<String, dynamic> i in histData) {
      var out = <String, dynamic>{};
      out["sensorData"] = SensorData.fromJson(i);
      out["isTapped"] = false;
      histDataMap[today.difference(out["sensorData"].time.toLocal()).inDays] =
          out;
    }

    return histDataMap;
  } else {
    throw Exception("Failed to Fetch Data");
  }
}
