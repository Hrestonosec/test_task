import 'package:hive/hive.dart';
import 'package:test_task/models/task.dart';

class TaskRepository {
  final Box<Task> _taskBox;

  TaskRepository(this._taskBox);

  Future<List<Task>> loadTasks() async {
    return _taskBox.values.toList();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
  }

  Future<void> updateTask(int index, Task updatedTask) async {
    await _taskBox.putAt(index, updatedTask);
  }

  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
  }
}
