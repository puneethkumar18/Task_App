part of "tasks_cubit.dart";

sealed class TasksState {
  const TasksState();
}

final class TasksInitial extends TasksState {}

final class TasksLoading extends TasksState {}

final class TasksSuccess extends TasksState {
  final TaskModel task;
  const TasksSuccess(this.task);
}

final class TasksError extends TasksState {
  final String error;
  const TasksError(this.error);
}

final class TasksList extends TasksState {
  final List<TaskModel> tasks;
  const TasksList(this.tasks);
}
