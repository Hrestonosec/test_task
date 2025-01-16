part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class FilterTasksByCategoryAndStatusEvent extends TaskEvent {
  final List<String> selectedCategories;
  final String status;

  FilterTasksByCategoryAndStatusEvent(this.selectedCategories, this.status);
}

class AddTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final String category;

  AddTaskEvent({
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  List<Object?> get props => [title, description, category];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final int taskId;

  ToggleTaskCompletionEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;

  DeleteTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class DeleteCompletedTasksEvent extends TaskEvent {}
