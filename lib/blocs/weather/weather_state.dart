part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final double temperature;
  final String description;
  final String city;

  const WeatherLoaded(
      {required this.temperature,
      required this.description,
      required this.city});

  @override
  List<Object> get props => [temperature, description, city];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
