import '../../data/models/task_model.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class LoadProjectTasks extends TaskEvent {
  final String projectId;
  LoadProjectTasks(this.projectId);
}

class AddTask extends TaskEvent {
  final Task task;
  final String projectId;
  AddTask({required this.task, required this.projectId});
}

class DeleteTask extends TaskEvent {
  final String taskId;
  final String projectId;
  DeleteTask({required this.taskId, required this.projectId});
}

class UpdateTask extends TaskEvent {
  final Task task;
  final String projectId;
  UpdateTask({required this.task, required this.projectId});
}

class MoveTask extends TaskEvent {
  final String taskId;
  final int newIndex;
  final String newStatus;

  MoveTask(this.taskId, this.newIndex, this.newStatus);
}

class StartTimer extends TaskEvent {
  final String taskId;
  StartTimer(this.taskId);
}

class StopTimer extends TaskEvent {
  final String taskId;
  StopTimer(this.taskId);
}

class ResumeTimer extends TaskEvent {
  final String taskId;
  ResumeTimer(this.taskId);
}

class UpdateTimerDuration extends TaskEvent {
  final String taskId;
  final int duration;
  final List<Task> todo;
  final List<Task> inProgress;
  final List<Task> completed;

  UpdateTimerDuration({
    required this.taskId,
    required this.duration,
    required this.todo,
    required this.inProgress,
    required this.completed,
  });
}

class UpdateTaskDuration extends TaskEvent {
  final String taskId;
  final int duration;
  UpdateTaskDuration(this.taskId, this.duration);
}

class CloseTask extends TaskEvent {
  final String taskId;
  final String projectId;

  CloseTask({required this.taskId, required this.projectId});
}

class InitializeTimerState extends TaskEvent {}

class PauseTimer extends TaskEvent {}
