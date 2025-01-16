import 'package:hive/hive.dart';
import 'package:test_task/models/task.dart';

class TaskRepository {
  final Box<Task>
      _taskBox; // A reference to the Hive box for storing Task objects

  TaskRepository(this._taskBox);

  // Loads all tasks from the Hive box and returns them as a List<Task>
  Future<List<Task>> loadTasks() async {
    return _taskBox.values.toList();
  }

  // Adds a new task to the Hive box
  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
  }

  // Updates an existing task at the specified index in the Hive box
  Future<void> updateTask(int index, Task updatedTask) async {
    await _taskBox.putAt(index, updatedTask);
  }

  // Deletes a task from the Hive box at the specified index
  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
  }

  // Deletes only completed tasks and keeps the remaining ones in the Hive box
  Future<void> deleteCompletedTasks() async {
    final remainingTasks =
        _taskBox.values.where((task) => !task.isCompleted).toList();

    // Clears the box to remove all tasks
    await _taskBox.clear();

    // Adds back only the incomplete tasks to the box
    for (final task in remainingTasks) {
      await _taskBox.add(task);
    }
  }
}
