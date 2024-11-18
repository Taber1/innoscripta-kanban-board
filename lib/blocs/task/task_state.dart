import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskError extends TaskState {
  final String error;
  const TaskError(this.error);

  @override
  List<Object?> get props => [error];
}

class TaskLoaded extends TaskState {
  final List<Task> todo;
  final List<Task> inProgress;
  final List<Task> completed;
  final String? activeTimerTaskId;
  final Map<String, int> taskDurations;

  const TaskLoaded({
    required this.todo,
    required this.inProgress,
    required this.completed,
    this.activeTimerTaskId,
    this.taskDurations = const {},
  });

  @override
  List<Object?> get props => [
        todo,
        inProgress,
        completed,
        activeTimerTaskId,
        taskDurations,
      ];

  TaskLoaded copyWith({
    List<Task>? todo,
    List<Task>? inProgress,
    List<Task>? completed,
    String? activeTimerTaskId,
    Map<String, int>? taskDurations,
  }) {
    return TaskLoaded(
      todo: todo ?? this.todo,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      activeTimerTaskId: activeTimerTaskId ?? this.activeTimerTaskId,
      taskDurations: taskDurations ?? this.taskDurations,
    );
  }
}

class UpdateTaskTime extends TaskState {
  final String taskId;
  final int timeIncrement;

  const UpdateTaskTime(this.taskId, this.timeIncrement);

  @override
  List<Object?> get props => [taskId, timeIncrement];
}
