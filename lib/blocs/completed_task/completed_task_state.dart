import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';
import '../../data/models/project_model.dart';

abstract class CompletedTaskState extends Equatable {
  const CompletedTaskState();

  @override
  List<Object?> get props => [];
}

class CompletedTaskInitial extends CompletedTaskState {}

class CompletedTaskLoading extends CompletedTaskState {}

class CompletedTaskLoaded extends CompletedTaskState {
  final List<Task> tasks;
  final Map<String, Project> projects;

  const CompletedTaskLoaded(this.tasks, this.projects);

  @override
  List<Object?> get props => [tasks, projects];
}

class CompletedTaskError extends CompletedTaskState {
  final String message;

  const CompletedTaskError(this.message);

  @override
  List<Object> get props => [message];
} 