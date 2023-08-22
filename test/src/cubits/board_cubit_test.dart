import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/src/cubits/board_cubit.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repositories/board_repository.dart';
import 'package:todo/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit = BoardCubit(repository);
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group('fetchTasks |', () {
    test('it should fetch all tasks', () async {
      when(() => repository.fetch()).thenAnswer(
        (_) async => [
          const Task(id: 1, description: 'Teste', check: false),
        ],
      );

      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<GettedTasksBoardState>(),
        ]),
      );

      await cubit.fetchTasks();
    });

    test('it should return an error state', () async {
      when(() => repository.fetch()).thenThrow(Exception('Error'));

      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.fetchTasks();
    });
  });

  group('addTask |', () {
    test('it should add a task', () async {
      when(() => repository.update(any())).thenAnswer(
        (_) async => [],
      );

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      const task = Task(id: 1, description: 'New task', check: false);
      await cubit.addTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    test('it should return an error state when add a task', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );
      const task = Task(id: 1, description: 'New task', check: false);
      await cubit.addTask(task);
    });
  });

  group('removeTask |', () {
    test('it should remove a task', () async {
      when(() => repository.update(any())).thenAnswer(
        (_) async => [],
      );

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      const task = Task(id: 1, description: 'New task', check: false);
      cubit.addTasks([task]);

      await cubit.removeTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 0);
    });

    test('it should return an error state when remove a task', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      const task = Task(id: 1, description: 'New task', check: false);
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.removeTask(task);
    });
  });

  group('checkTask |', () {
    test('it should check a task', () async {
      when(() => repository.update(any())).thenAnswer(
        (_) async => [],
      );

      const task = Task(id: 1, description: 'New task', check: false);
      cubit.addTasks([task]);
      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);
      expect((cubit.state as GettedTasksBoardState).tasks.first.check, false);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);
      expect((cubit.state as GettedTasksBoardState).tasks.first.check, true);
    });

    test('it should return an error state when check a task', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      const task = Task(id: 1, description: 'New task', check: false);
      cubit.addTasks([task]);
      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);
      expect((cubit.state as GettedTasksBoardState).tasks.first.check, false);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
    });
  });
}
