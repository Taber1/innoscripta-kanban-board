import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/data/models/project_model.dart';
import 'package:innoscripta_test_kanban/data/providers/project_api_provider.dart';
import 'package:innoscripta_test_kanban/data/services/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock class
@GenerateNiceMocks([MockSpec<ApiService>()])
import 'project_api_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProjectApiProvider projectApiProvider;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    projectApiProvider = ProjectApiProvider(mockApiService);
  });

  group('ProjectApiProvider', () {
    test('fetchProjects returns list of projects', () async {
      // Arrange
      when(mockApiService.getRequest('projects'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: 'projects'),
                data: [
                  {'id': '1', 'name': 'Project 1', 'color': '#FF0000'},
                  {'id': '2', 'name': 'Project 2', 'color': '#00FF00'},
                ],
              ));

      // Act
      final result = await projectApiProvider.fetchProjects();

      // Assert
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
      verify(mockApiService.getRequest('projects')).called(1);
    });

    test('fetchProjectById returns single project', () async {
      // Arrange
      const projectId = '1';
      when(mockApiService.getRequest('projects/$projectId'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: 'projects/$projectId'),
                data: {
                  'id': projectId,
                  'name': 'Project 1',
                  'color': '#FF0000'
                },
              ));

      // Act
      final result = await projectApiProvider.fetchProjectById(projectId);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], projectId);
      verify(mockApiService.getRequest('projects/$projectId')).called(1);
    });

    test('addProject creates new project', () async {
      // Arrange
      final project = Project(
        id: '1',
        name: 'New Project',
        color: '#FF0000',
      );
      when(mockApiService.postRequest(
        'projects',
        body: {'name': project.name, 'color': project.color},
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'projects'),
            data: {'id': '1', 'name': project.name, 'color': project.color},
          ));

      // Act
      final result = await projectApiProvider.addProject(project);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], project.name);
      verify(mockApiService.postRequest(
        'projects',
        body: {'name': project.name, 'color': project.color},
      )).called(1);
    });

    test('deleteProject removes project', () async {
      // Arrange
      const projectId = '1';
      when(mockApiService.deleteRequest('projects/$projectId'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: 'projects/$projectId'),
                data: null,
              ));

      // Act & Assert
      await expectLater(
        projectApiProvider.deleteProject(projectId),
        completes,
      );
      verify(mockApiService.deleteRequest('projects/$projectId')).called(1);
    });

    test('updateProject modifies existing project', () async {
      // Arrange
      final project = Project(
        id: '1',
        name: 'Updated Project',
        color: '#00FF00',
      );
      when(mockApiService.postRequest(
        'projects/${project.id}',
        body: {'name': project.name, 'color': project.color},
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'projects/${project.id}'),
            data: {
              'id': project.id,
              'name': project.name,
              'color': project.color
            },
          ));

      // Act
      final result = await projectApiProvider.updateProject(project);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], project.name);
      verify(mockApiService.postRequest(
        'projects/${project.id}',
        body: {'name': project.name, 'color': project.color},
      )).called(1);
    });
  });
}

// Mock Response class to simulate API responses
class MockResponse {
  final dynamic data;
  MockResponse({required this.data});
}
