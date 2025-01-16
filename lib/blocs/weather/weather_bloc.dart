import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_task/repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc({required this.repository}) : super(WeatherInitial()) {
    on<LoadWeather>(_onLoadWeather);
  }

  Future<void> _onLoadWeather(
      LoadWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await repository.fetchWeather();
      emit(WeatherLoaded(
          temperature: weather.temperature,
          description: weather.description,
          city: weather.city));
    } catch (e) {
      emit(WeatherError("Не вдалося завантажити погоду"));
    }
  }
}
