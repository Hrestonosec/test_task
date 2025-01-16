part of 'task_bloc.dart'; // Specifies that this part belongs to the task_bloc.dart file

abstract class TaskState extends Equatable {
  // Abstract class for Task states, extends Equatable for value comparison
  @override
  List<Object?> get props =>
      []; // Defines equality based on properties (currently empty)
}

// Initial state for the Task BLoC, indicates that no tasks have been loaded yet
class TaskInitial extends TaskState {}

// State when tasks are being loaded (e.g., showing a loading indicator)
class TaskLoading extends TaskState {}

// State when tasks have been successfully loaded
class TaskLoaded extends TaskState {
  final List<Task>
      filteredTasks; // List of tasks that match any filtering criteria
  final List<String>
      selectedCategories; // List of selected categories for filtering
  final List<Task> allTasks; // List of all tasks (unfiltered)

  // Constructor to initialize the TaskLoaded state with data
  TaskLoaded(this.filteredTasks, this.allTasks,
      {this.selectedCategories = const []});

  @override
  List<Object?> get props =>
      [filteredTasks]; // Defines equality based on filtered tasks
}

// State when there is an error loading tasks
class TaskError extends TaskState {
  final String message;

  TaskError(this.message);

  @override
  List<Object?> get props =>
      [message]; // Defines equality based on the error message
}
