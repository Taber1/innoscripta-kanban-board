import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/data/models/project_model.dart';
import 'package:innoscripta_test_kanban/data/repositories/project_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_event.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_state.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'project_bloc_test.mocks.dart';

@GenerateMocks([ProjectRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProjectBloc projectBloc;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    projectBloc = ProjectBloc(repository: mockRepository);
  });

  tearDown(() {
    projectBloc.close();
  });

  group('ProjectBloc', () {
    final testProject = Project(id: '1', name: 'Test Project');
    final testProjects = [testProject];

    test('initial state should be ProjectInitial', () {
      expect(projectBloc.state, isA<ProjectInitial>());
    });

    group('LoadProjects', () {
      blocTest<ProjectBloc, ProjectState>(
        'emits [ProjectLoading, ProjectLoaded] when successful',
        build: () {
          when(mockRepository.getProjects())
              .thenAnswer((_) async => testProjects);
          return projectBloc;
        },
        act: (bloc) => bloc.add(LoadProjects()),
        expect: () => [
          isA<ProjectLoading>(),
          isA<ProjectLoaded>(),
        ],
      );

      blocTest<ProjectBloc, ProjectState>(
        'emits [ProjectLoading, ProjectError] when unsuccessful',
        build: () {
          when(mockRepository.getProjects())
              .thenThrow(Exception('Failed to load projects'));
          return projectBloc;
        },
        act: (bloc) => bloc.add(LoadProjects()),
        expect: () => [
          isA<ProjectLoading>(),
          isA<ProjectError>(),
        ],
      );
    });

    group('AddProject', () {
      blocTest<ProjectBloc, ProjectState>(
        'calls repository and triggers LoadProjects when successful',
        build: () {
          when(mockRepository.createProject(testProject))
              .thenAnswer((_) async => testProject);
          when(mockRepository.getProjects())
              .thenAnswer((_) async => testProjects);
          return projectBloc;
        },
        act: (bloc) => bloc.add(AddProject(testProject)),
        verify: (_) {
          verify(mockRepository.createProject(testProject)).called(1);
          verify(mockRepository.getProjects()).called(1);
        },
      );

      blocTest<ProjectBloc, ProjectState>(
        'emits ProjectError when unsuccessful',
        build: () {
          when(mockRepository.createProject(testProject))
              .thenThrow(Exception('Failed to add project'));
          return projectBloc;
        },
        act: (bloc) => bloc.add(AddProject(testProject)),
        expect: () => [isA<ProjectError>()],
      );
    });

    group('UpdateProject', () {
      blocTest<ProjectBloc, ProjectState>(
        'calls repository and triggers LoadProjects when successful',
        build: () {
          when(mockRepository.updateProject(testProject))
              .thenAnswer((_) async => testProject);
          when(mockRepository.getProjects())
              .thenAnswer((_) async => testProjects);
          return projectBloc;
        },
        act: (bloc) => bloc.add(UpdateProject(testProject)),
        verify: (_) {
          verify(mockRepository.updateProject(testProject)).called(1);
          verify(mockRepository.getProjects()).called(1);
        },
      );
    });

    group('DeleteProject', () {
      blocTest<ProjectBloc, ProjectState>(
        'calls repository and triggers LoadProjects when successful',
        build: () {
          when(mockRepository.deleteProject(testProject.id))
              .thenAnswer((_) async => null);
          when(mockRepository.getProjects())
              .thenAnswer((_) async => testProjects);
          return projectBloc;
        },
        act: (bloc) => bloc.add(DeleteProject(testProject.id!)),
        verify: (_) {
          verify(mockRepository.deleteProject(testProject.id)).called(1);
          verify(mockRepository.getProjects()).called(1);
        },
      );
    });
  });
}
