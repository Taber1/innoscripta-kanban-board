import 'package:innoscripta_test_kanban/data/services/local_storage_service.dart';

import '../models/task_model.dart';

class TaskStorageService {
  final LocalStorageService storageService;

  TaskStorageService({LocalStorageService? storageService})
      : storageService = storageService ?? LocalStorageService();

  static const String completedTasksKey = 'completed_tasks';
  static const String runningTaskIdKey = 'running_task_id';
  static const String timerStartKey = 'timer_start_time';
  static const String taskTimerPrefix = 'task_timer_';

  Future<void> addCompletedTask(Task task) async {
    final completedTasks = getCompletedTasks();
    final existingIndex = completedTasks.indexWhere((t) => t.id == task.id);
    if (existingIndex >= 0) {
      completedTasks[existingIndex] = task;
    } else {
      completedTasks.add(task);
    }
    await _saveCompletedTasks(completedTasks);
  }

  List<Task> getCompletedTasks() {
    final tasksList = LocalStorageService.getListMap(completedTasksKey);
    if (tasksList == null) return [];
    return tasksList.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> _saveCompletedTasks(List<Task> tasks) async {
    final tasksList = tasks.map((task) => task.toJson()).toList();
    LocalStorageService.setListMap(completedTasksKey, tasksList);
  }

  Future<void> saveTimerStartTime(String? timeString) async {
    if (timeString == null) {
      LocalStorageService.remove(timerStartKey);
    } else {
      LocalStorageService.setString(timerStartKey, timeString);
    }
  }

  String? getTimerStartTime() {
    return LocalStorageService.getString(timerStartKey);
  }

  Future<void> clearCompletedTasks() async {
    LocalStorageService.remove(completedTasksKey);
  }

  String? getRunningTaskId() {
    final taskId = LocalStorageService.getString(runningTaskIdKey);
    return taskId?.isNotEmpty == true ? taskId : null;
  }

  Future<void> saveTimerState(String? taskId) async {
    if (taskId == null || taskId.isEmpty) {
      LocalStorageService.remove(runningTaskIdKey);
    } else {
      LocalStorageService.setString(runningTaskIdKey, taskId);
    }
  }

  Future<void> saveTaskDuration(String taskId, int duration) async {
    LocalStorageService.setInt('$taskTimerPrefix$taskId', duration);

    final completedTasks = getCompletedTasks();
    final taskIndex = completedTasks.indexWhere((t) => t.id == taskId);
    if (taskIndex >= 0) {
      final updatedTask =
          completedTasks[taskIndex].copyWith(timeSpent: duration);
      completedTasks[taskIndex] = updatedTask;
      await _saveCompletedTasks(completedTasks);
    }
  }

  int getTaskDuration(String taskId) {
    return LocalStorageService.getInt('$taskTimerPrefix$taskId') ?? 0;
  }

  Future<void> clearTaskTimer(String taskId) async {
    LocalStorageService.remove('$taskTimerPrefix$taskId');
  }
}
