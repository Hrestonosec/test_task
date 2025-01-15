part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> filteredTasks;
  final List<String> selectedCategories;
  final List<Task> allTasks;

  TaskLoaded(this.filteredTasks, this.allTasks,
      {this.selectedCategories = const []});

  @override
  List<Object?> get props => [filteredTasks];
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
