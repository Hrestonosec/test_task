import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_task/models/task.dart';
import 'package:test_task/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<DeleteCompletedTasksEvent>(_onDeleteCompletedTasks);
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await repository.loadTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
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
      final updatedTasks = [...currentState.tasks, newTask];
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      final updatedTask = currentState.tasks[event.taskId];

      updatedTask.isCompleted = !updatedTask.isCompleted;

      await repository.updateTask(event.taskId, updatedTask);

      final updatedTasks = List<Task>.from(currentState.tasks)
        ..[event.taskId] = updatedTask;

      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      await repository.deleteTask(event.taskId);

      final updatedTasks = List<Task>.from(currentState.tasks)
        ..removeAt(event.taskId);

      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onDeleteCompletedTasks(
      DeleteCompletedTasksEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      await repository.deleteCompletedTasks();

      final updatedTasks =
          currentState.tasks.where((task) => !task.isCompleted).toList();

      emit(TaskLoaded(updatedTasks));
    }
  }
}
