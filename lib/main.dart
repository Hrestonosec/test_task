import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_task/UI/task_list_screen.dart';
import 'package:test_task/blocs/task/task_bloc.dart';
import 'package:test_task/blocs/weather/weather_bloc.dart';
import 'package:test_task/models/task.dart';
import 'package:test_task/repositories/task_repository.dart';
import 'package:test_task/repositories/weather_repository.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that Flutter bindings are initialized before using any other code
  await Hive.initFlutter(); // Initializes Hive storage for Flutter

  Hive.registerAdapter(
      TaskAdapter()); // Registers a custom Hive adapter for Task model
  final taskBox = await Hive.openBox<Task>(
      'tasksBox'); // Opens or creates a box to store Task objects in Hive

  runApp(MyApp(taskBox)); // Runs the app and passes the taskBox to MyApp widget
}

class MyApp extends StatelessWidget {
  final Box<Task> taskBox;

  const MyApp(this.taskBox, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        // Provides multiple BLoCs to the widget tree
        providers: [
          BlocProvider<TaskBloc>(
            // Provides TaskBloc to the widget tree
            create: (context) {
              final taskBloc = TaskBloc(
                repository: TaskRepository(Hive.box<Task>(
                    'tasksBox')), // Passes a TaskRepository that uses the Hive box
              );
              taskBloc.add(LoadTasksEvent()); // Dispatches event to load tasks
              return taskBloc;
            },
          ),
          BlocProvider<WeatherBloc>(
            // Provides WeatherBloc to the widget tree
            create: (context) {
              final weatherBloc = WeatherBloc(
                repository: WeatherRepository(), // Passes a WeatherRepository
              );
              weatherBloc
                  .add(LoadWeather()); // Dispatches event to load weather data
              return weatherBloc;
            },
          ),
        ],
        child: TaskListScreen(),
      ),
    );
  }
}
