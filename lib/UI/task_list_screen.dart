import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/task/task_bloc.dart';
import 'package:test_task/blocs/weather/weather_bloc.dart';

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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "Назва задачі",
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 50, // Обмеження на кількість символів
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: "Опис задачі",
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 100, // Обмеження на кількість символів
                          maxLines: 1, // Однорядковий текст
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: selectedCategory,
                                onChanged: (newCategory) {
                                  if (newCategory != null) {
                                    setState(() {
                                      selectedCategory = newCategory;
                                    });
                                  }
                                },
                                items: ['Робота', 'Особисті справи', 'Навчання']
                                    .map((category) => DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(category),
                                        ))
                                    .toList(),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final title = titleController.text;
                                  final description =
                                      descriptionController.text;

                                  if (title.isNotEmpty &&
                                      description.isNotEmpty) {
                                    context.read<TaskBloc>().add(
                                          AddTaskEvent(
                                            title: title,
                                            description: description,
                                            category: selectedCategory,
                                          ),
                                        );
                                    titleController.clear();
                                    descriptionController.clear();
                                  }
                                },
                                child: Text("Додати задачу"),
                              ),
                            ]) // Ваші TextField, DropdownButton і кнопки
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<TaskBloc>()
                              .add(DeleteCompletedTasksEvent());
                        },
                        child: Text("Очистити виконані"),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () async {
                          final selectedCategories =
                              await showDialog<List<String>>(
                            context: context,
                            builder: (context) {
                              final selected = <String>{
                                ...state.selectedCategories
                              };
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text("Обрати категорії"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Зніміть всі категорії, щоб показати всі задачі.",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        ...[
                                          'Робота',
                                          'Особисті справи',
                                          'Навчання'
                                        ].map((category) {
                                          return CheckboxListTile(
                                            title: Text(category),
                                            value: selected.contains(category),
                                            onChanged: (isChecked) {
                                              setState(() {
                                                if (isChecked!) {
                                                  selected.add(category);
                                                } else {
                                                  selected.remove(category);
                                                }
                                              });
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, null),
                                        child: Text("Скасувати"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            context, selected.toList()),
                                        child: Text("ОК"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                          if (selectedCategories != null) {
                            context.read<TaskBloc>().add(
                                FilterTasksByCategoryEvent(selectedCategories));
                          }
                        },
                      ),
                    ],
                  ),
                  // Список задач
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = state.filteredTasks[index];
                        return ListTile(
                          title: Row(
                            children: [
                              Text("${task.title}   "),
                              Text(
                                task.category,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          subtitle: Text(task.description),
                          trailing: IconButton(
                            icon: Icon(
                                task.isCompleted ? Icons.check : Icons.clear),
                            onPressed: () {
                              context.read<TaskBloc>().add(
                                  ToggleTaskCompletionEvent(taskId: index));
                            },
                          ),
                          onLongPress: () {
                            context
                                .read<TaskBloc>()
                                .add(DeleteTaskEvent(taskId: index));
                          },
                        );
                      },
                    ),
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
