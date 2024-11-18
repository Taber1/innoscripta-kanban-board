import 'package:innoscripta_test_kanban/data/models/task_model.dart';

import '../services/api_service.dart';

class TaskApiProvider {
  final ApiService _apiService;

  TaskApiProvider([ApiService? apiService])
      : _apiService = apiService ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await _apiService.getRequest('tasks');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchTaskByProject(
      String projectId) async {
    final response = await _apiService.getRequest(
      'tasks',
      params: {'project_id': projectId},
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> addTask(Task task, String projectId) async {
    final Map<String, dynamic> payload = {
      'content': task.content,
      'description': task.description,
      'project_id': projectId,
      'priority': task.priority,
      'labels': task.labels,
    };

    // Add due date if it exists
    if (task.dueDate != null) {
      payload['due_date'] = task.dueDate;
    }

    final response = await _apiService.postRequest('tasks', body: payload);
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> updateTask(Task task) async {
    final Map<String, dynamic> payload = {
      'content': task.content,
      'description': task.description,
      'priority': task.priority,
      'labels': task.labels,
    };

    // Add due date if it exists
    if (task.dueDate != null) {
      payload['due_date'] = task.dueDate;
    }

    final response =
        await _apiService.postRequest('tasks/${task.id}', body: payload);
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> deleteTask(String taskId) async {
    await _apiService.deleteRequest('tasks/$taskId');
  }

  Future<void> closeTask(String taskId) async {
    await _apiService.postRequest('tasks/$taskId/close');
  }
}
