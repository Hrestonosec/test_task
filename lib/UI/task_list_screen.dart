import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/task/task_bloc.dart';
import 'package:test_task/blocs/weather/weather_bloc.dart';

import 'widgets/add_task.dart';
import 'widgets/task_list_with_controls.dart';
import 'widgets/weather_widget.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Робота'; // Категорія за замовчуванням

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoaded) {
              return WeatherWidget(
                temperature: state.temperature.toInt().toString(),
                weatherCondition: state.description,
                city: state.city,
              );
            } else if (state is WeatherLoading) {
              return Text('Завантаження погоди...');
            } else if (state is WeatherError) {
              return Text('Помилка погоди');
            } else {
              return Text('Погода');
            }
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          // Переносимо BlocBuilder сюди
          builder: (context, state) {
            if (state is TaskLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              return Column(
                children: [
                  // Віджети для введення задач, кнопки, тощо
                  AddTaskWidget(),
                  Expanded(
                    child: TaskListWithControls(state: state),
                  ),
                ],
              );
            } else if (state is TaskError) {
              return Center(child: Text('Помилка: ${state.message}'));
            }
            return Center(child: Text('Невідомий стан'));
          },
        ),
      ),
    );
  }
}
