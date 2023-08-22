import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/cubits/board_cubit.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/states/board_state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BoardCubit>().fetchTasks();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    final state = cubit.state;

    Widget body = Container();

    if (state is EmptyBoardState) {
      body = const Center(
        key: Key('EmptyState'),
        child: Text('Adicione uma nova task'),
      );
    } else if (state is GettedTasksBoardState) {
      final tasks = state.tasks;
      body = ListView.builder(
        key: const Key('GettedState'),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () {
              cubit.removeTask(task);
            },
            child: CheckboxListTile(
              value: task.check,
              onChanged: (value) {
                cubit.checkTask(task);
              },
              title: Text(task.description),
            ),
          );
        },
      );
    } else if (state is FailureBoardState) {
      body = Center(
        key: const Key('FailureState'),
        child: Text(state.message),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  addTaskDialog() {
    var description = '';
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Sair'),
              ),
              TextButton(
                onPressed: () {
                  var newTask = Task(
                    id: -1,
                    description: description,
                    check: false,
                  );
                  context.read<BoardCubit>().addTask(newTask);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
            content: TextField(
              onChanged: (value) => description = value,
            ),
            title: const Text('Adicionar uma task'),
          );
        });
  }
}
