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

  Future<void> deleteCompletedTasks() async {
    // Отримуємо всі задачі, залишаємо лише невиконані
    final remainingTasks =
        _taskBox.values.where((task) => !task.isCompleted).toList();

    // Видаляємо все з боксу
    await _taskBox.clear();

    // Додаємо назад тільки невиконані задачі
    for (final task in remainingTasks) {
      await _taskBox.add(task);
    }
  }
}
