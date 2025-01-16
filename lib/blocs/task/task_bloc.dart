import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_task/models/task.dart';
import 'package:test_task/repositories/task_repository.dart';

// Includes task_event.dart and task_state.dart, which defines the events and states for this BLoC
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository
      repository; // A reference to the TaskRepository to interact with data

  // Constructor to initialize the TaskBloc with the repository and event handlers
  TaskBloc({required this.repository}) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<FilterTasksByCategoryAndStatusEvent>(
        _filterTasksByCategoryAndStatusEvent);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<DeleteCompletedTasksEvent>(_onDeleteCompletedTasks);
  }

  // Event handler to load tasks
  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading()); // Emits loading state
    try {
      final filteredTasks = await repository
          .loadTasks(); // Loads all tasks that represents filtered tasks in list
      final allTasks = await repository
          .loadTasks(); // Loads all tasks to be able for filtering

      emit(TaskLoaded(filteredTasks, allTasks)); // Emits loaded tasks state
    } catch (e) {
      emit(TaskError(
          'Failed to load tasks')); // Emits error state if loading fails
    }
  }

  // Event handler to filter tasks by category and status
  void _filterTasksByCategoryAndStatusEvent(
      FilterTasksByCategoryAndStatusEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      // Checks if the current state is TaskLoaded
      final currentState = state as TaskLoaded;

      // Filters tasks based on selected categories and status
      final filteredTasks = currentState.allTasks.where((task) {
        bool matchesCategory = event.selectedCategories.isEmpty ||
            event.selectedCategories.contains(task.category);

        bool matchesStatus = (event.status == 'Всі') ||
            (event.status == 'Виконані' && task.isCompleted) ||
            (event.status == 'Невиконані' && !task.isCompleted);

        return matchesCategory && matchesStatus;
      }).toList();

      emit(TaskLoaded(filteredTasks, currentState.allTasks,
          selectedCategories: event
              .selectedCategories)); // Emits updated filtered tasks state and return chosen categories
    }
  }

  // Event handler to add a new task
  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      // Checks if the current state is TaskLoaded
      final currentState = state as TaskLoaded;
      final newTask = Task(
        title: event.title,
        description: event.description,
        category: event.category,
      );
      await repository.addTask(newTask); // Adds the new task to the repository
      final updatedTasks = [
        ...currentState.filteredTasks,
        newTask
      ]; // Adds new task to filtered tasks
      emit(TaskLoaded(
          updatedTasks, currentState.allTasks)); // Emits updated tasks state
    }
  }

  // Event handler to toggle the completion status of a task
  void _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      // Checks if the current state is TaskLoaded
      final currentState = state as TaskLoaded;

      // Toggles completion status of the task at the given taskId
      final updatedTask = currentState.filteredTasks[event.taskId].copyWith(
        isCompleted: !currentState.filteredTasks[event.taskId].isCompleted,
      );

      await repository.updateTask(
          event.taskId, updatedTask); // Updates the task in the repository

      final updatedTasks = List<Task>.from(currentState.filteredTasks)
        ..[event.taskId] = updatedTask; // Updates filtered tasks list

      final updatedAllTasks = List<Task>.from(currentState.allTasks)
        ..[event.taskId] = updatedTask; // Updates all tasks list

      emit(TaskLoaded(
          updatedTasks, updatedAllTasks)); // Emits updated tasks state
    }
  }

  // Event handler to delete a task
  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      // Checks if the current state is TaskLoaded
      final currentState = state as TaskLoaded;

      await repository
          .deleteTask(event.taskId); // Deletes the task from the repository

      final updatedTasks = List<Task>.from(currentState.filteredTasks)
        ..removeAt(event
            .taskId); // Removes the deleted task from the filtered tasks list

      emit(TaskLoaded(
          updatedTasks, currentState.allTasks)); // Emits updated tasks state
    }
  }

  // Event handler to delete all completed tasks
  void _onDeleteCompletedTasks(
      DeleteCompletedTasksEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      // Checks if the current state is TaskLoaded
      final currentState = state as TaskLoaded;

      await repository
          .deleteCompletedTasks(); // Deletes completed tasks from the repository

      // Filters out completed tasks from filtered tasks list
      final updatedTasks = currentState.filteredTasks
          .where((task) => !task.isCompleted)
          .toList();

      emit(TaskLoaded(
          updatedTasks, currentState.allTasks)); // Emits updated tasks state
    }
  }
}
