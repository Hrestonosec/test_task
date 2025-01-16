import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Додаємо цей імпорт для роботи з BLoC
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_task/UI/task_list_screen.dart';
import 'package:test_task/blocs/task/task_bloc.dart';
import 'package:test_task/blocs/weather/weather_bloc.dart';
import 'package:test_task/models/task.dart';
import 'package:test_task/repositories/task_repository.dart';
import 'package:test_task/repositories/weather_repository.dart'; // Імпортуємо TaskRepository

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter()); // Реєструємо адаптер
  final taskBox = await Hive.openBox<Task>('tasksBox'); // Відкриваємо сховище

  runApp(MyApp(taskBox)); // Передаємо коробку в MyApp
}

class MyApp extends StatelessWidget {
  final Box<Task> taskBox;

  const MyApp(this.taskBox, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // В обгортці BlocProvider забезпечуємо доступ до TaskBloc
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TaskBloc>(
            create: (context) {
              final taskBloc = TaskBloc(
                repository: TaskRepository(Hive.box<Task>('tasksBox')),
              );
              taskBloc
                  .add(LoadTasksEvent()); // Додаємо подію завантаження задач
              return taskBloc;
            },
          ),
          BlocProvider<WeatherBloc>(
            create: (context) {
              final weatherBloc = WeatherBloc(
                repository: WeatherRepository(),
              );
              weatherBloc
                  .add(LoadWeather()); // Додаємо подію завантаження погоди
              return weatherBloc;
            },
          ),
        ],
        child: TaskListScreen(), // Основний екран
      ),
    );
  }
}
