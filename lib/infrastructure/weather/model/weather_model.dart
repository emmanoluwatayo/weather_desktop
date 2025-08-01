class WeatherModel {
  final double temperature;
  final double windSpeed;
  final String time;
  final double humidity;
  final double tempMin;
  final double tempMax;
  final String sunrise;
  final String sunset;
  final List<String> hourlyTime;
  final List<double> hourlyTemp;

  // 🔥 Add these for 7-day trend
  final List<String> dailyTime;
  final List<double> dailyTempMax;

  WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.time,
    required this.humidity,
    required this.tempMin,
    required this.tempMax,
    required this.sunrise,
    required this.sunset,
    required this.hourlyTime,
    required this.hourlyTemp,
    required this.dailyTime,
    required this.dailyTempMax,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    final hourly = json['hourly'];
    final daily = json['daily'];

    final List<String> hourlyTime = List<String>.from(hourly['time']);
    final List<double> hourlyTemp = List<double>.from(
      hourly['temperature_2m'].map((t) => (t as num).toDouble()),
    );

    final List<String> dailyTime = List<String>.from(daily['time']);
    final List<double> dailyTempMax = List<double>.from(
      daily['temperature_2m_max'].map((t) => (t as num).toDouble()),
    );

    final index = hourlyTime.indexOf(current['time']);

    return WeatherModel(
      temperature: (current['temperature'] as num).toDouble(),
      windSpeed: (current['windspeed'] as num).toDouble(),
      time: current['time'],
      humidity:
          index != -1
              ? (hourly['relative_humidity_2m'][index] as num).toDouble()
              : 0.0,
      tempMin: (daily['temperature_2m_min'][0] as num).toDouble(),
      tempMax: (daily['temperature_2m_max'][0] as num).toDouble(),
      sunrise: daily['sunrise'][0],
      sunset: daily['sunset'][0],
      hourlyTime: hourlyTime,
      hourlyTemp: hourlyTemp,
      dailyTime: dailyTime,
      dailyTempMax: dailyTempMax,
    );
  }
}
