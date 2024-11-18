import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:innoscripta_test_kanban/blocs/completed_task/completed_task_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/completed_task/completed_task_event.dart';
import 'package:innoscripta_test_kanban/blocs/completed_task/completed_task_state.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';
import 'package:innoscripta_test_kanban/data/models/project_model.dart';
import 'package:innoscripta_test_kanban/data/services/task_storage_service.dart';
import 'package:innoscripta_test_kanban/data/repositories/project_repository.dart';

@GenerateMocks([TaskStorageService, ProjectRepository])
import 'completed_task_bloc_test.mocks.dart';

void main() {
  late CompletedTaskBloc bloc;
  late MockTaskStorageService mockTaskStorageService;
  late MockProjectRepository mockProjectRepository;

  setUp(() {
    mockTaskStorageService = MockTaskStorageService();
    mockProjectRepository = MockProjectRepository();
    bloc = CompletedTaskBloc(
      taskStorageService: mockTaskStorageService,
      projectRepository: mockProjectRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('CompletedTaskBloc', () {
    final testTask = Task(
      id: '1',
      content: 'Test Task',
      description: 'Test Description',
      projectId: 'project-1',
      isCompleted: true,
      completedAt: DateTime.now(),
      timeSpent: 60,
    );

    final testProject = Project(
      id: 'project-1',
      name: 'Test Project',
      color: '#FF0000',
    );

    blocTest<CompletedTaskBloc, CompletedTaskState>(
      'emits [Loading, Loaded] when LoadCompletedTasks is added',
      build: () {
        when(mockTaskStorageService.getCompletedTasks()).thenReturn([testTask]);
        when(mockProjectRepository.getProjectsByIds(['project-1']))
            .thenAnswer((_) async => [testProject]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadCompletedTasks()),
      expect: () => [
        isA<CompletedTaskLoading>(),
        isA<CompletedTaskLoaded>().having(
          (state) => state.tasks,
          'tasks',
          [testTask],
        ).having(
          (state) => state.projects,
          'projects',
          {'project-1': testProject},
        ),
      ],
      verify: (_) {
        verify(mockTaskStorageService.getCompletedTasks()).called(1);
        verify(mockProjectRepository.getProjectsByIds(['project-1'])).called(1);
      },
    );

    blocTest<CompletedTaskBloc, CompletedTaskState>(
      'emits [Loading, Error] when LoadCompletedTasks fails',
      build: () {
        when(mockTaskStorageService.getCompletedTasks())
            .thenThrow(Exception('Failed to load tasks'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadCompletedTasks()),
      expect: () => [
        isA<CompletedTaskLoading>(),
        isA<CompletedTaskError>().having(
          (state) => state.message,
          'message',
          'Exception: Failed to load tasks',
        ),
      ],
    );

    blocTest<CompletedTaskBloc, CompletedTaskState>(
      'adds task and reloads when AddCompletedTask is added',
      build: () {
        when(mockTaskStorageService.addCompletedTask(any))
            .thenAnswer((_) async {});
        when(mockTaskStorageService.getCompletedTasks()).thenReturn([testTask]);
        when(mockProjectRepository.getProjectsByIds(['project-1']))
            .thenAnswer((_) async => [testProject]);
        return bloc;
      },
      act: (bloc) => bloc.add(AddCompletedTask(testTask, 60)),
      expect: () => [
        isA<CompletedTaskLoading>(),
        isA<CompletedTaskLoaded>().having(
          (state) => state.tasks,
          'tasks',
          [testTask],
        ).having(
          (state) => state.projects,
          'projects',
          {'project-1': testProject},
        ),
      ],
      verify: (_) {
        verify(mockTaskStorageService.addCompletedTask(any)).called(1);
        verify(mockTaskStorageService.getCompletedTasks()).called(1);
      },
    );

    blocTest<CompletedTaskBloc, CompletedTaskState>(
      'clears tasks when ClearCompletedTasks is added',
      build: () {
        when(mockTaskStorageService.clearCompletedTasks())
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(ClearCompletedTasks()),
      expect: () => [
        isA<CompletedTaskLoaded>().having(
          (state) => state.tasks,
          'tasks',
          [],
        ).having(
          (state) => state.projects,
          'projects',
          {},
        ),
      ],
      verify: (_) {
        verify(mockTaskStorageService.clearCompletedTasks()).called(1);
      },
    );

    blocTest<CompletedTaskBloc, CompletedTaskState>(
      'emits Error when ClearCompletedTasks fails',
      build: () {
        when(mockTaskStorageService.clearCompletedTasks())
            .thenThrow(Exception('Failed to clear tasks'));
        return bloc;
      },
      act: (bloc) => bloc.add(ClearCompletedTasks()),
      expect: () => [
        isA<CompletedTaskError>().having(
          (state) => state.message,
          'message',
          'Exception: Failed to clear tasks',
        ),
      ],
    );
  });
}
