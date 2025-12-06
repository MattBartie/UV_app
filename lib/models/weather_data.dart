class WeatherData {
  final double uvIndex;

  WeatherData({required this.uvIndex});

  // Factory constructor to parse the JSON from Open-Meteo
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final uv = current != null ? current['uv_index'] : 0.0;

    return WeatherData(
      uvIndex: (uv as num).toDouble(), // Handles int or double safety
    );
  }
}