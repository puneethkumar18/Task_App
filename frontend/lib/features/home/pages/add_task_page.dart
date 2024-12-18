import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddTaskPage(),
      );
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  void submitTask() async {
    if (_formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      await context.read<TasksCubit>().createTask(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            color: selectedColor,
            token: user.user.token,
            dueAt: selectedDate,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Task',
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final _selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(
                    days: 90,
                  ),
                ),
              );
              if (_selectedDate != null) {
                setState(() {
                  selectedDate = _selectedDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat("dd-MM-yyyy").format(selectedDate),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {
            if (state is TasksError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else if (state is TasksSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Task Has been Added Successfully!"),
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is TasksLoading) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title is Invalid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Description",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description is Invalid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ColorPicker(
                      color: selectedColor,
                      pickersEnabled: const {
                        ColorPickerType.accent: true,
                        ColorPickerType.wheel: true,
                      },
                      heading: const Text(
                        "Select color",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subheading: const Text(
                        "Select a diffrent shade",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onColorChanged: (color) {
                        selectedColor = color;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: submitTask,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
