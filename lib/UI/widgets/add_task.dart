import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/task/task_bloc.dart';

class AddTaskWidget extends StatefulWidget {
  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController titleController =
      TextEditingController(); // Controller for the task title input
  final TextEditingController descriptionController =
      TextEditingController(); // Controller for the task description input
  String selectedCategory = 'Робота'; // Default task category

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Padding around the entire widget
      child: Column(
        children: [
          // TextField for the task title
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Назва задачі",
              border: OutlineInputBorder(),
            ),
            maxLength: 40, // Maximum character length for the task title
          ),
          SizedBox(height: 10),
          // TextField for the task description
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Опис задачі",
              border: OutlineInputBorder(),
            ),
            maxLength: 100, // Maximum character length for the description
            maxLines: 1, // Single line input for the description
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // DropdownButton for selecting the task category
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (newCategory) {
                  if (newCategory != null) {
                    setState(() {
                      selectedCategory =
                          newCategory; // Update the selected category
                    });
                  }
                },
                items: [
                  'Робота',
                  'Особисті справи',
                  'Навчання'
                ] // Category options
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
              ),
              // ElevatedButton to add the task
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;

                  // If both title and description are not empty, add the task
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
