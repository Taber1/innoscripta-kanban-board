import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';
import 'package:innoscripta_test_kanban/data/providers/task_api_provider.dart';
import 'package:innoscripta_test_kanban/data/repositories/task_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([TaskApiProvider])
import 'task_repository_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TaskRepository repository;
  late MockTaskApiProvider mockProvider;

  setUp(() {
    mockProvider = MockTaskApiProvider();
    repository = TaskRepository(mockProvider);
  });

  group('TaskRepository', () {
    final testTask = {
      'id': '1',
      'content': 'Test Task',
      'description': 'Test Description',
      'project_id': 'project-1',
      'created_at': DateTime.now().toIso8601String(),
      'creator_id': 'creator-1',
      'assignee_id': null,
      'assigner_id': null,
      'comment_count': 0,
      'is_completed': false,
      'labels': [],
      'order': 0,
      'priority': 1,
      'section_id': null,
      'parent_id': null,
      'url': null,
      'time_spent': null,
      'completed_at': null,
    };

    test('getAllTasks returns list of tasks', () async {
      when(mockProvider.fetchTasks()).thenAnswer((_) async => [testTask]);

      final result = await repository.getAllTasks();

      expect(result, isA<List<Task>>());
      expect(result.length, 1);
      expect(result.first.id, testTask['id']);
      expect(result.first.content, testTask['content']);
      verify(mockProvider.fetchTasks()).called(1);
    });

    test('getTasksByProject returns list of tasks for project', () async {
      when(mockProvider.fetchTaskByProject('project-1'))
          .thenAnswer((_) async => [testTask]);

      final result = await repository.getTasksByProject('project-1');

      expect(result, isA<List<Task>>());
      expect(result.length, 1);
      expect(result.first.id, testTask['id']);
      verify(mockProvider.fetchTaskByProject('project-1')).called(1);
    });

    test('createTask returns created task', () async {
      final taskToCreate = Task.fromJson(testTask);
      when(mockProvider.addTask(taskToCreate, 'project-1'))
          .thenAnswer((_) async => testTask);

      final result = await repository.createTask(taskToCreate, 'project-1');

      expect(result, isA<Task>());
      expect(result.id, testTask['id']);
      verify(mockProvider.addTask(taskToCreate, 'project-1')).called(1);
    });

    test('updateTask returns updated task', () async {
      final taskToUpdate = Task.fromJson(testTask);
      when(mockProvider.updateTask(taskToUpdate))
          .thenAnswer((_) async => testTask);

      final result = await repository.updateTask(taskToUpdate);

      expect(result, isA<Task>());
      expect(result.id, testTask['id']);
      verify(mockProvider.updateTask(taskToUpdate)).called(1);
    });

    test('deleteTask completes successfully', () async {
      when(mockProvider.deleteTask('1')).thenAnswer((_) async => {});

      await repository.deleteTask('1');

      verify(mockProvider.deleteTask('1')).called(1);
    });

    test('closeTask completes successfully', () async {
      when(mockProvider.closeTask('1')).thenAnswer((_) async => {});

      await repository.closeTask('1');

      verify(mockProvider.closeTask('1')).called(1);
    });

    test('getAllTasks handles errors', () async {
      when(mockProvider.fetchTasks()).thenThrow(Exception('Network error'));

      expect(
        () => repository.getAllTasks(),
        throwsException,
      );
    });
  });
}
