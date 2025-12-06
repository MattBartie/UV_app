import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class ApiService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> fetchUV(double lat, double lng) async {
    // construct the URL for Open-Meteo
    final url = Uri.parse(
        '$_baseUrl?latitude=$lat&longitude=$lng&current=uv_index&timezone=auto');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // decode JSON and pass it to our Model
        final jsonMap = json.decode(response.body);
        return WeatherData.fromJson(jsonMap);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}