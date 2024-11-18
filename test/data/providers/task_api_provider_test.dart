import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:innoscripta_test_kanban/data/providers/task_api_provider.dart';
import 'package:innoscripta_test_kanban/data/services/api_service.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';

// Generate mock class
@GenerateNiceMocks([MockSpec<ApiService>()])
import 'task_api_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TaskApiProvider taskApiProvider;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    taskApiProvider = TaskApiProvider(
        mockApiService); // Update constructor to accept mockApiService
  });

  group('TaskApiProvider', () {
    test('fetchTasks returns list of tasks', () async {
      // Arrange
      when(mockApiService.getRequest('tasks')).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'tasks'),
            data: [
              {'id': '1', 'content': 'Task 1'},
              {'id': '2', 'content': 'Task 2'},
            ],
          ));

      // Act
      final result = await taskApiProvider.fetchTasks();

      // Assert
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
      verify(mockApiService.getRequest('tasks')).called(1);
    });

    test('fetchTaskByProject returns list of tasks for specific project',
        () async {
      // Arrange
      final projectId = 'project-123';
      when(mockApiService.getRequest(
        'tasks',
        params: {'project_id': projectId},
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'tasks'),
            data: [
              {'id': '1', 'content': 'Task 1', 'project_id': projectId},
            ],
          ));

      // Act
      final result = await taskApiProvider.fetchTaskByProject(projectId);

      // Assert
      expect(result, isA<List<dynamic>>());
      expect(result.length, 1);
      verify(mockApiService.getRequest(
        'tasks',
        params: {'project_id': projectId},
      )).called(1);
    });

    test('addTask creates new task', () async {
      // Arrange
      final task = Task(
        id: '1',
        content: 'New Task',
        description: 'Description',
        priority: 1,
        labels: ['label1'],
        dueDate: DateTime(2024, 3, 20).toIso8601String(),
      );
      final projectId = 'project-123';

      final expectedBody = {
        'content': task.content,
        'description': task.description,
        'project_id': projectId,
        'priority': task.priority,
        'labels': task.labels,
        'due_date': task.dueDate,
      };

      when(mockApiService.postRequest(
        'tasks',
        body: expectedBody,
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'tasks'),
            data: {
              'id': '1',
              'content': 'New Task',
              'project_id': projectId,
            },
          ));

      // Act
      final result = await taskApiProvider.addTask(task, projectId);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      verify(mockApiService.postRequest(
        'tasks',
        body: expectedBody,
      )).called(1);
    });

    test('updateTask updates existing task', () async {
      // Arrange
      final task = Task(
        id: '1',
        content: 'Updated Task',
        description: 'Updated Description',
        priority: 2,
        labels: ['label2'],
      );

      final expectedBody = {
        'content': task.content,
        'description': task.description,
        'priority': task.priority,
        'labels': task.labels,
      };

      when(mockApiService.postRequest(
        'tasks/${task.id}',
        body: expectedBody,
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'tasks/${task.id}'),
            data: {
              'id': '1',
              'content': 'Updated Task',
            },
          ));

      // Act
      final result = await taskApiProvider.updateTask(task);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      verify(mockApiService.postRequest(
        'tasks/${task.id}',
        body: expectedBody,
      )).called(1);
    });

    test('deleteTask deletes task', () async {
      // Arrange
      final taskId = '1';
      when(mockApiService.deleteRequest('tasks/$taskId'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: 'tasks/$taskId'),
                data: null,
              ));

      // Act & Assert
      await expectLater(
        taskApiProvider.deleteTask(taskId),
        completes,
      );
      verify(mockApiService.deleteRequest('tasks/$taskId')).called(1);
    });

    test('closeTask closes task', () async {
      // Arrange
      final taskId = '1';
      when(mockApiService.postRequest('tasks/$taskId/close'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: 'tasks/$taskId/close'),
                data: null,
              ));

      // Act & Assert
      await expectLater(
        taskApiProvider.closeTask(taskId),
        completes,
      );
      verify(mockApiService.postRequest('tasks/$taskId/close')).called(1);
    });
  });
}
