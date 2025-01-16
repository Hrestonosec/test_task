import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/task/task_bloc.dart';

class AddTaskWidget extends StatefulWidget {
  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Робота'; // Категорія за замовчуванням

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Назва задачі",
              border: OutlineInputBorder(),
            ),
            maxLength: 40, // Обмеження на кількість символів
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
    );
  }
}
