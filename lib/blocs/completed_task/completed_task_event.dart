import '../../data/models/task_model.dart';

abstract class CompletedTaskEvent {}

class LoadCompletedTasks extends CompletedTaskEvent {}

class AddCompletedTask extends CompletedTaskEvent {
  final Task task;
  final int timeSpent;

  AddCompletedTask(this.task, this.timeSpent);
}

class ClearCompletedTasks extends CompletedTaskEvent {} 