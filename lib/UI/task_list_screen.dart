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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar contains the weather information
        title: BlocBuilder<WeatherBloc, WeatherState>(
          // Using BlocBuilder to listen for weather state changes
          builder: (context, state) {
            if (state is WeatherLoaded) {
              // If the weather is loaded, display the weather widget with data
              return WeatherWidget(
                temperature: state.temperature.toInt().toString(),
                weatherCondition: state.description,
                city: state.city,
              );
            } else if (state is WeatherLoading) {
              // While weather is loading, show loading text
              return Text('Завантаження погоди...');
            } else if (state is WeatherError) {
              // If there's an error with fetching weather, show an error message
              return Text('Помилка погоди');
            } else {
              // Default title when there's no weather data
              return Text('Погода');
            }
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          // Using BlocBuilder to listen for task state changes
          builder: (context, state) {
            if (state is TaskLoading) {
              // While tasks are loading, show loading indicator
              return Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              // If tasks are loaded, display task management widgets
              return Column(
                children: [
                  // Widget to add a new task
                  AddTaskWidget(),
                  // Display the list of tasks with controls
                  Expanded(
                    child: TaskListWithControls(state: state),
                  ),
                ],
              );
            } else if (state is TaskError) {
              // If there's an error with loading tasks, show error message
              return Center(child: Text('Помилка: ${state.message}'));
            }
            // Default case when the state is unknown
            return Center(child: Text('Невідомий стан'));
          },
        ),
      ),
    );
  }
}
