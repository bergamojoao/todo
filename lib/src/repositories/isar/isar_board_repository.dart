import 'package:todo/src/models/task.dart';
import 'package:todo/src/repositories/board_repository.dart';
import 'package:todo/src/repositories/isar/isar_datasource.dart';
import 'package:todo/src/repositories/isar/task_model.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource datasource;

  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() async {
    final models = await datasource.getTasks();
    return models
        .map((model) => Task(
              id: model.id,
              description: model.description,
              check: model.check,
            ))
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((task) {
      final model = TaskModel()
        ..check = task.check
        ..description = task.description;
      if (task.id != -1) {
        model.id = task.id;
      }
      return model;
    }).toList();

    await datasource.deleteAll();
    await datasource.putAllTasks(models);
    return tasks;
  }
}
