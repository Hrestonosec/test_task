part of 'task_bloc.dart'; // Specifies that this part belongs to the task_bloc.dart file

abstract class TaskEvent extends Equatable {
  // Abstract class for Task events, extends Equatable for value comparison
  @override
  List<Object?> get props =>
      []; // Defines equality based on properties (currently empty)
}

// Event to load tasks from the repository (triggers loading process)
class LoadTasksEvent extends TaskEvent {}

// Event to filter tasks based on selected categories and status
class FilterTasksByCategoryAndStatusEvent extends TaskEvent {
  final List<String>
      selectedCategories; // List of selected categories for filtering
  final String
      status; // The status (e.g., 'completed' or 'incomplete') for filtering

  FilterTasksByCategoryAndStatusEvent(this.selectedCategories, this.status);
}

// Event to add a new task to the repository
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
  List<Object?> get props =>
      [title, description, category]; // Defines equality based on task details
}

// Event to toggle the completion status of a task (mark as completed or incomplete)
class ToggleTaskCompletionEvent extends TaskEvent {
  final int taskId; // ID of the task to toggle completion status

  ToggleTaskCompletionEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId]; // Defines equality based on task ID
}

// Event to delete a task from the repository
class DeleteTaskEvent extends TaskEvent {
  final int taskId; // ID of the task to be deleted

  DeleteTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId]; // Defines equality based on task ID
}

// Event to delete all completed tasks from the repository
class DeleteCompletedTasksEvent extends TaskEvent {}
