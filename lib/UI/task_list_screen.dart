import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/task/task_bloc.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            // Віджет для введення нової задачі
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final title = titleController.text;
                          final description = descriptionController.text;

                          if (title.isNotEmpty && description.isNotEmpty) {
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
                    ],
                  ),
                ],
              ),
            ),
            BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  final tasks = state.tasks;
                  return Expanded(
                    // Додаємо обгортку Expanded
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: IconButton(
                            icon: Icon(
                                task.isCompleted ? Icons.check : Icons.clear),
                            onPressed: () {
                              context.read<TaskBloc>().add(
                                    ToggleTaskCompletionEvent(taskId: index),
                                  );
                            },
                          ),
                          onLongPress: () {
                            context.read<TaskBloc>().add(
                                  DeleteTaskEvent(taskId: index),
                                );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is TaskError) {
                  return Center(child: Text('Помилка: ${state.message}'));
                }
                return Text("Сталася якась помилка");
              },
            ),
          ],
        ),
      ),
    );
  }
}
