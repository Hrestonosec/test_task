import 'package:http/http.dart' as http;
import 'package:test_task/repositories/api_keys.dart';
import 'dart:convert';

import 'package:test_task/services/location_service.dart';

class WeatherRepository {
  final String apiKey = weatherKey; // The API key for fetching weather data

  // Fetches weather data based on the current location of the user
  Future<Weather> fetchWeather() async {
    final location = await LocationService().getCurrentLocation();

    // Sends a GET request to the OpenWeather API with the user's location and the API key
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey',
      ),
    );

    // Checks if the API response was successful (status code 200)
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Returns a Weather object with the fetched data
      return Weather(
          temperature: data['main']['temp'],
          description: data['weather'][0]
              ['description'], // Extracts the weather description
          city: data['name']);
    } else {
      throw Exception('Помилка завантаження погоди');
    }
  }
}

class Weather {
  final double temperature;
  final String
      description; // Description of the weather (e.g., clear sky, rainy
  final String city;

  Weather(
      {required this.temperature,
      required this.description,
      required this.city});
}
