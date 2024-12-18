import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/home/pages/add_task_page.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TasksCubit>().fetchTasks(token: user.user.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                AddTaskPage.route(),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          )
        ],
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const CircularProgressIndicator();
          } else if (state is TasksList) {
            return Column(
              children: [
                const DateSelector(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TaskCard(
                              color: hexToRGB(task.hexaColor),
                              headerText: task.title,
                              descriptionText: task.description,
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: strengthnColor(
                                hexToRGB(task.hexaColor),
                                0.69,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat.jm().format(task.dueAt),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            );
          } else if (state is TasksError) {
            return Center(
              child: Text(
                state.error,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
