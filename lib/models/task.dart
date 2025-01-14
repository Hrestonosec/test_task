import 'package:hive/hive.dart';

part 'task.g.dart'; // Hive генерує код адаптера

@HiveType(typeId: 0) // Унікальний ідентифікатор для адаптера
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
  });
}
