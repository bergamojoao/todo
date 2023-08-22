import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repositories/isar/isar_board_repository.dart';
import 'package:todo/src/repositories/isar/isar_datasource.dart';
import 'package:todo/src/repositories/isar/task_model.dart';

class IsarDatasourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarDatasource datasource;
  late IsarBoardRepository repository;
  setUp(() {
    datasource = IsarDatasourceMock();
    repository = IsarBoardRepository(datasource);
  });
  test('fetch', () async {
    when(() => datasource.getTasks()).thenAnswer((_) async => [
          TaskModel()..id = 1,
        ]);

    final tasks = await repository.fetch();
    expect(tasks.length, 1);
  });

  test('update', () async {
    when(() => datasource.deleteAll()).thenAnswer((_) async => []);
    when(() => datasource.putAllTasks(any())).thenAnswer((_) async => []);

    final tasks = await repository.update([
      const Task(id: -1, description: 'Novo', check: false),
      const Task(id: 2, description: 'Antigo', check: false),
    ]);
    expect(tasks.length, 2);
  });
}
