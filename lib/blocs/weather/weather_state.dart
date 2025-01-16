part of 'weather_bloc.dart'; // Specifies that this part belongs to the weather_bloc.dart file

// Base class for weather-related states, extends Equatable for value comparison
class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props =>
      []; // Defines equality based on properties (currently empty)
}

// Initial state when weather data hasn't been loaded yet
class WeatherInitial extends WeatherState {}

// State when weather data is being loaded (e.g., showing a loading indicator)
class WeatherLoading extends WeatherState {}

// State when weather data has been successfully loaded
class WeatherLoaded extends WeatherState {
  final double temperature;
  final String description; // Weather description (e.g., 'clear sky')
  final String city;

  const WeatherLoaded(
      {required this.temperature,
      required this.description,
      required this.city});

  @override
  List<Object> get props => [
        temperature,
        description,
        city
      ]; // Defines equality based on temperature, description, and city
}

// State when there's an error loading weather data
class WeatherError extends WeatherState {
  final String message; // Error message

  const WeatherError(this.message);

  @override
  List<Object> get props =>
      [message]; // Defines equality based on the error message
}
