part of "add_new_task_cubit.dart";

sealed class AddNewTaskState {
  const AddNewTaskState();
}

final class AddNewTaskInitial extends AddNewTaskState {}

final class AddNewTaskLoading extends AddNewTaskState {}

final class AddNewTaskSuccess extends AddNewTaskState {
  final TaskModel task;
  const AddNewTaskSuccess(this.task);
}

final class AddNewTaskError extends AddNewTaskState {
  final String error;
  const AddNewTaskError(this.error);
}
