import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_task/repositories/weather_repository.dart';

// Includes weather_event.dart and weather_state.dart, which defines the events and states for this BLoC
part 'weather_event.dart';
part 'weather_state.dart';

// WeatherBloc handles the weather-related events and manages the corresponding states
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository
      repository; // A reference to the WeatherRepository to fetch weather data

  // Constructor to initialize the WeatherBloc with the repository and event handlers
  WeatherBloc({required this.repository}) : super(WeatherInitial()) {
    on<LoadWeather>(_onLoadWeather);
  }

  // Event handler to load weather data
  Future<void> _onLoadWeather(
      LoadWeather event, Emitter<WeatherState> emit) async {
    emit(
        WeatherLoading()); // Emits loading state when starting to load weather data
    try {
      final weather = await repository
          .fetchWeather(); // Fetches weather data from the repository
      // Emits WeatherLoaded state with the fetched weather data (temperature, description, and city)
      emit(WeatherLoaded(
          temperature: weather.temperature,
          description: weather.description,
          city: weather.city));
    } catch (e) {
      emit(WeatherError(
          "Не вдалося завантажити погоду")); // Emits error state if fetching weather fails
    }
  }
}
