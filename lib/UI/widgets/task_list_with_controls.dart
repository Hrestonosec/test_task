import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/task/task_bloc.dart';

class TaskListWithControls extends StatelessWidget {
  final TaskLoaded
      state; // State holding the list of tasks and selected categories

  TaskListWithControls({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button to delete completed tasks
            ElevatedButton(
              onPressed: () {
                context.read<TaskBloc>().add(DeleteCompletedTasksEvent());
              },
              child: Text("Очистити виконані"),
            ),
            // IconButton for showing task filter options
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                // Open a dialog for filtering tasks by category and status
                final filterOptions = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) {
                    final selectedCategories = <String>{
                      ...state.selectedCategories
                    }; // Selected categories for filtering
                    String selectedStatus = 'Всі'; // Default status filter
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Informational text for categories
                              Text(
                                "Зніміть всі категорії, щоб показати всі задачі.",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              // Checkbox list for selecting categories
                              ...['Робота', 'Особисті справи', 'Навчання']
                                  .map((category) {
                                return CheckboxListTile(
                                  title: Text(category),
                                  value: selectedCategories.contains(category),
                                  onChanged: (isChecked) {
                                    setState(() {
                                      if (isChecked!) {
                                        selectedCategories.add(category);
                                      } else {
                                        selectedCategories.remove(category);
                                      }
                                    });
                                  },
                                );
                              }),
                              Divider(),
                              Text("Фільтрувати за статусом"),
                              // Radio buttons for selecting task status
                              RadioListTile<String>(
                                title: Text("Всі"),
                                value: 'Всі',
                                groupValue: selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value!;
                                  });
                                },
                              ),
                              RadioListTile<String>(
                                title: Text("Виконані"),
                                value: 'Виконані',
                                groupValue: selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value!;
                                  });
                                },
                              ),
                              RadioListTile<String>(
                                title: Text("Невиконані"),
                                value: 'Невиконані',
                                groupValue: selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            // Cancel button for the dialog
                            TextButton(
                              onPressed: () => Navigator.pop(context, null),
                              child: Text("Скасувати"),
                            ),
                            // OK button to apply the filters
                            TextButton(
                              onPressed: () => Navigator.pop(context, {
                                'categories': selectedCategories.toList(),
                                'status': selectedStatus,
                              }),
                              child: Text("ОК"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                // If filters are selected, apply them
                if (filterOptions != null) {
                  context
                      .read<TaskBloc>()
                      .add(FilterTasksByCategoryAndStatusEvent(
                        filterOptions['categories'],
                        filterOptions['status'],
                      ));
                }
              },
            ),
          ],
        ),
        // Task list display
        Expanded(
          child: ListView.builder(
            itemCount: state.filteredTasks.length, // Number of tasks to display
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index]; // The current task
              return ListTile(
                title: Row(
                  children: [
                    // Task title and category
                    Text("${task.title}   "),
                    Text(
                      task.category,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                subtitle: Text(task.description), // Task description
                trailing: IconButton(
                  // Icon to toggle task completion state
                  icon: Icon(task.isCompleted
                      ? Icons.check_box_outlined
                      : Icons.square_outlined),
                  onPressed: () {
                    // Toggle the completion status of the task
                    context
                        .read<TaskBloc>()
                        .add(ToggleTaskCompletionEvent(taskId: index));
                  },
                ),
                onLongPress: () {
                  // Delete task when long pressed
                  context.read<TaskBloc>().add(DeleteTaskEvent(taskId: index));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
