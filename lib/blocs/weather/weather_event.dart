part of 'weather_bloc.dart'; // Specifies that this part belongs to the weather_bloc.dart file

// Abstract class for weather-related events, extends Equatable for value comparison
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props =>
      []; // Defines equality based on properties (currently empty)
}

// Event to load weather data (triggers the fetching process)
class LoadWeather extends WeatherEvent {}
