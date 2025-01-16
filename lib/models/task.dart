import 'package:hive/hive.dart';

part 'task.g.dart'; // This file is for code generation using Hive's build_runner (task.g.dart will be generated)

@HiveType(
    typeId:
        0) // Annotates the class to register it with Hive as a custom type with typeId 0
class Task {
  @HiveField(0) // Maps this field to the 0th index in Hive storage
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String category; // The category of the task (e.g., work, personal)

  @HiveField(3)
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false, // Default value for completing task is false
  });

  Task copyWith({
    // Method to create a new Task instance with updated values
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
  }) {
    return Task(
      title: title ??
          this.title, // Uses the provided title, or the current title if null
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
