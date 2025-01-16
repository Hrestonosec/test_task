import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/task/task_bloc.dart';

class TaskListWithControls extends StatelessWidget {
  final TaskLoaded state;

  TaskListWithControls({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<TaskBloc>().add(DeleteCompletedTasksEvent());
              },
              child: Text("Очистити виконані"),
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                final filterOptions = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) {
                    final selectedCategories = <String>{
                      ...state.selectedCategories
                    };
                    String selectedStatus = 'Всі';
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Зніміть всі категорії, щоб показати всі задачі.",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
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
                            TextButton(
                              onPressed: () => Navigator.pop(context, null),
                              child: Text("Скасувати"),
                            ),
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
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: Icon(task.isCompleted ? Icons.check : Icons.clear),
                  onPressed: () {
                    context
                        .read<TaskBloc>()
                        .add(ToggleTaskCompletionEvent(taskId: index));
                  },
                ),
                onLongPress: () {
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
