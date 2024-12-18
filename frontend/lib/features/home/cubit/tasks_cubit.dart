import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repositary/task_remote_repositary.dart';
import 'package:frontend/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  final taskRemoteRepositary = TaskRemoteRepositary();
  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepositary.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        dueAt: dueAt,
      );
      emit(TasksSuccess(taskModel));
    } catch (e) {
      emit(
        TasksError(e.toString()),
      );
    }
  }

  Future<void> fetchTasks({
    required String token,
  }) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepositary.fetchTasks(token: token);
      emit(TasksList(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
}
