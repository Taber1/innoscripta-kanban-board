import '../providers/project_api_provider.dart';
import '../models/project_model.dart';

class ProjectRepository {
  final ProjectApiProvider _provider;

  ProjectRepository([ProjectApiProvider? provider]) 
      : _provider = provider ?? ProjectApiProvider();

  Future<List<Project>> getProjects() async {
    final projectData = await _provider.fetchProjects();
    return projectData.map((data) => Project.fromJson(data)).toList();
  }

  Future<List<Project>> getProjectsByIds(List<String> projectIds) async {
    try {
      final projects = await Future.wait(
        projectIds.map((id) => getProjectById(id))
      );
      return projects.whereType<Project>().toList();
    } catch (e) {
      throw Exception('Failed to fetch projects: $e');
    }
  }

  Future<Project?> getProjectById(String id) async {
    final projectData = await _provider.fetchProjectById(id);
    return Project.fromJson(projectData);
  }

  Future<Project> createProject(Project project) async {
    final projectData = await _provider.addProject(project);
    return Project.fromJson(projectData);
  }

  Future<void> deleteProject(String projectId) async {
    await _provider.deleteProject(projectId);
  }

  Future<Project> updateProject(Project project) async {
    final projectData = await _provider.updateProject(project);
    return Project.fromJson(projectData);
  }
}
