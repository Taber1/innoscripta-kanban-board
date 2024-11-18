import '../providers/task_api_provider.dart';
import '../models/task_model.dart';

class TaskRepository {
  final TaskApiProvider _provider;
  
  TaskRepository([TaskApiProvider? provider]) 
      : _provider = provider ?? TaskApiProvider();


  Future<List<Task>> getAllTasks() async {
    final taskData = await _provider.fetchTasks();
    return taskData.map((data) => Task.fromJson(data)).toList();
  }

  Future<List<Task>> getTasksByProject(String projectId) async {
    final taskData = await _provider.fetchTaskByProject(projectId);
    return taskData.map((data) => Task.fromJson(data)).toList();
  }

  Future<Task> createTask(Task task, String projectId) async {
    final taskData = await _provider.addTask(task, projectId);
    return Task.fromJson(taskData);
  }

  Future<void> deleteTask(String taskId) async {
    await _provider.deleteTask(taskId);
  }

  Future<Task> updateTask(Task task) async {
    final taskData = await _provider.updateTask(task);
    return Task.fromJson(taskData);
  }

  Future<void> closeTask(String taskId) async {
    await _provider.closeTask(taskId);
  }
}
