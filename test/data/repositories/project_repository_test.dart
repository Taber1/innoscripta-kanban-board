import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/data/models/project_model.dart';
import 'package:innoscripta_test_kanban/data/providers/project_api_provider.dart';
import 'package:innoscripta_test_kanban/data/repositories/project_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ProjectApiProvider])
import 'project_repository_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late ProjectRepository repository;
  late MockProjectApiProvider mockProvider;

  setUp(() {
    mockProvider = MockProjectApiProvider();
    repository = ProjectRepository(mockProvider);
  });

  group('ProjectRepository', () {
    final testProject = {
      'id': '1',
      'name': 'Test Project',
      'description': 'Test Description',
      'status': 'active',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    test('getProjects returns list of projects', () async {
      when(mockProvider.fetchProjects())
          .thenAnswer((_) async => [testProject]);

      final result = await repository.getProjects();

      expect(result, isA<List<Project>>());
      expect(result.length, 1);
      expect(result.first.id, testProject['id']);
      expect(result.first.name, testProject['name']);
      verify(mockProvider.fetchProjects()).called(1);
    });

    test('getProjectById returns single project', () async {
      when(mockProvider.fetchProjectById('1'))
          .thenAnswer((_) async => testProject);

      final result = await repository.getProjectById('1');

      expect(result, isA<Project>());
      expect(result!, isNotNull);
      expect(result.id, testProject['id']);
      verify(mockProvider.fetchProjectById('1')).called(1);
    });

    test('getProjectsByIds returns list of projects', () async {
      when(mockProvider.fetchProjectById(any))
          .thenAnswer((_) async => testProject);

      final result = await repository.getProjectsByIds(['1', '2']);

      expect(result, isA<List<Project>>());
      expect(result.length, 2);
      verify(mockProvider.fetchProjectById('1')).called(1);
      verify(mockProvider.fetchProjectById('2')).called(1);
    });

    test('createProject returns created project', () async {
      final projectToCreate = Project.fromJson(testProject);
      when(mockProvider.addProject(projectToCreate))
          .thenAnswer((_) async => testProject);

      final result = await repository.createProject(projectToCreate);

      expect(result, isA<Project>());
      expect(result.id, testProject['id']);
      verify(mockProvider.addProject(projectToCreate)).called(1);
    });

    test('updateProject returns updated project', () async {
      final projectToUpdate = Project.fromJson(testProject);
      when(mockProvider.updateProject(projectToUpdate))
          .thenAnswer((_) async => testProject);

      final result = await repository.updateProject(projectToUpdate);

      expect(result, isA<Project>());
      expect(result.id, testProject['id']);
      verify(mockProvider.updateProject(projectToUpdate)).called(1);
    });

    test('deleteProject completes successfully', () async {
      when(mockProvider.deleteProject('1'))
          .thenAnswer((_) async => true);

      await repository.deleteProject('1');

      verify(mockProvider.deleteProject('1')).called(1);
    });

    test('getProjectsByIds handles errors', () async {
      when(mockProvider.fetchProjectById('1'))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.getProjectsByIds(['1']),
        throwsException,
      );
    });
  });
} 