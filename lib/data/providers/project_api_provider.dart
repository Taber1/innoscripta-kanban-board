import '../models/project_model.dart';
import '../services/api_service.dart';

class ProjectApiProvider {
  final ApiService _apiService;

  ProjectApiProvider([ApiService? apiService]) 
      : _apiService = apiService ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchProjects() async {
    final response = await _apiService.getRequest('projects');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> fetchProjectById(String projectId) async {
    final response = await _apiService.getRequest('projects/$projectId');
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> addProject(Project project) async {
    final response = await _apiService.postRequest(
      'projects',
      body: {
        'name': project.name,
        'color': project.color,
      },
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> deleteProject(String projectId) async {
    await _apiService.deleteRequest('projects/$projectId');
  }

  Future<Map<String, dynamic>> updateProject(Project project) async {
    final response = await _apiService.postRequest(
      'projects/${project.id}',
      body: {
        'name': project.name,
        'color': project.color,
      },
    );
    return Map<String, dynamic>.from(response.data);
  }
}
