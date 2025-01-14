import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_task/models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<DeleteTaskEvent>(_onDeleteTask);
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
      final updatedTasks = currentState.tasks.map((task) {
        if (currentState.tasks.indexOf(task) == event.taskId) {
          return Task(
            title: task.title,
            description: task.description,
            category: task.category,
            isCompleted: !task.isCompleted,
          );
        }
        return task;
      }).toList();
      await repository.updateTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks = List<Task>.from(currentState.tasks)
        ..removeAt(event.taskId);
      await repository.updateTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    }
  }
}
