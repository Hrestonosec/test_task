import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_task/models/task.dart';
import 'package:test_task/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<FilterTasksByCategoryAndStatusEvent>(
        _filterTasksByCategoryAndStatusEvent);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<DeleteCompletedTasksEvent>(_onDeleteCompletedTasks);
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final filteredTasks = await repository.loadTasks();
      final allTasks = await repository.loadTasks();

      emit(TaskLoaded(filteredTasks, allTasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  void _filterTasksByCategoryAndStatusEvent(
      FilterTasksByCategoryAndStatusEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      final filteredTasks = currentState.allTasks.where((task) {
        bool matchesCategory = event.selectedCategories.isEmpty ||
            event.selectedCategories.contains(task.category);

        bool matchesStatus = (event.status == 'Всі') ||
            (event.status == 'Виконані' && task.isCompleted) ||
            (event.status == 'Невиконані' && !task.isCompleted);

        return matchesCategory && matchesStatus;
      }).toList();

      emit(TaskLoaded(filteredTasks, currentState.allTasks,
          selectedCategories: event.selectedCategories));
    }
  }

  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final newTask = Task(
        title: event.title,
        description: event.description,
        category: event.category,
      );
      await repository.addTask(newTask);
      final updatedTasks = [...currentState.filteredTasks, newTask];
      emit(TaskLoaded(updatedTasks, currentState.allTasks));
    }
  }

  void _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      final updatedTask = currentState.filteredTasks[event.taskId].copyWith(
        isCompleted: !currentState.filteredTasks[event.taskId].isCompleted,
      );

      await repository.updateTask(event.taskId, updatedTask);

      final updatedTasks = List<Task>.from(currentState.filteredTasks)
        ..[event.taskId] = updatedTask;

      final updatedAllTasks = List<Task>.from(currentState.allTasks)
        ..[event.taskId] = updatedTask;

      emit(TaskLoaded(updatedTasks, updatedAllTasks));
    }
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      await repository.deleteTask(event.taskId);

      final updatedTasks = List<Task>.from(currentState.filteredTasks)
        ..removeAt(event.taskId);

      emit(TaskLoaded(updatedTasks, currentState.allTasks));
    }
  }

  void _onDeleteCompletedTasks(
      DeleteCompletedTasksEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      await repository.deleteCompletedTasks();

      final updatedTasks = currentState.filteredTasks
          .where((task) => !task.isCompleted)
          .toList();

      emit(TaskLoaded(updatedTasks, currentState.allTasks));
    }
  }
}
