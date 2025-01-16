import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_task/services/location_service.dart';

class WeatherRepository {
  final String apiKey = 'ad8eec9bc063bb04fc5e1e84035a018c';

  Future<Weather> fetchWeather() async {
    // Отримання геолокації, замінити на вашу реалізацію
    final location = await LocationService().getCurrentLocation();

    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather(
          temperature: data['main']['temp'],
          description: data['weather'][0]['description'],
          city: data['name']);
    } else {
      throw Exception('Помилка завантаження погоди');
    }
  }
}

class Weather {
  final double temperature;
  final String description;
  final String city;

  Weather(
      {required this.temperature,
      required this.description,
      required this.city});
}
