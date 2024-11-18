import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/ui/screens/task_list/widgets/task_column.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_bloc.dart';
import '../../../blocs/task/task_event.dart';
import '../../../blocs/task/task_state.dart';
import 'package:go_router/go_router.dart';

class TaskListScreen extends StatelessWidget {
  final String projectId;
  final String projectName;
  const TaskListScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(LoadProjectTasks(projectId));

    return PopScope(
      onPopInvoked: (didPop) async {
        // Stop any running timer before popping
        if (context.read<TaskBloc>().state is TaskLoaded) {
          final state = context.read<TaskBloc>().state as TaskLoaded;
          if (state.activeTimerTaskId != null) {
            context.read<TaskBloc>().add(StopTimer(state.activeTimerTaskId!));
            // Small delay to ensure timer is stopped
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
      },
      child: BlocConsumer<TaskBloc, TaskState>(
        buildWhen: (previous, current) {
          if (previous.runtimeType != current.runtimeType) {
            return true;
          }
          return current is TaskLoaded;
        },
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is TaskLoaded) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: Text(projectName),
              ),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TaskColumns(
                      title: 'To Do',
                      statusLabel: 'to-do',
                      tasks: state.todo,
                      onMoveTask: (task, targetColumn, targetIndex) async {
                        // Only stop timer if we're moving the task that has an active timer
                        if (context.read<TaskBloc>().state is TaskLoaded) {
                          final state =
                              context.read<TaskBloc>().state as TaskLoaded;
                          if (state.activeTimerTaskId == task.id) {
                            // Only check the task being moved
                            // Stop timer and wait for it to complete
                            context.read<TaskBloc>().add(StopTimer(task.id!));
                            // Small delay to ensure timer is stopped
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                          }
                        }

                        // Then move the task
                        if (context.mounted) {
                          context.read<TaskBloc>().add(
                                MoveTask(
                                  task.id!,
                                  targetIndex,
                                  targetColumn.toLowerCase(),
                                ),
                              );
                        }
                      },
                      onAddTask: () => context.push('/tasks/$projectId/add'),
                      projectId: projectId,
                    ),
                  ),
                  const VerticalDivider(
                      thickness: 1, indent: 16, endIndent: 16),
                  Expanded(
                    child: TaskColumns(
                      title: 'In Progress',
                      statusLabel: 'in-progress',
                      tasks: state.inProgress,
                      onMoveTask: (task, targetColumn, targetIndex) async {
                        // Only stop timer if we're moving the task that has an active timer
                        if (context.read<TaskBloc>().state is TaskLoaded) {
                          final state =
                              context.read<TaskBloc>().state as TaskLoaded;
                          if (state.activeTimerTaskId == task.id) {
                            // Only check the task being moved
                            // Stop timer and wait for it to complete
                            context.read<TaskBloc>().add(StopTimer(task.id!));
                            // Small delay to ensure timer is stopped
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                          }
                        }

                        // Then move the task
                        if (context.mounted) {
                          context.read<TaskBloc>().add(
                                MoveTask(
                                  task.id!,
                                  targetIndex,
                                  targetColumn.toLowerCase(),
                                ),
                              );
                        }
                      },
                      onAddTask: () => context.push('/tasks/$projectId/add'),
                      projectId: projectId,
                    ),
                  ),
                  const VerticalDivider(
                      thickness: 1, indent: 16, endIndent: 16),
                  Expanded(
                    child: TaskColumns(
                      title: 'Completed',
                      statusLabel: 'done',
                      tasks: state.completed,
                      onMoveTask: (task, targetColumn, targetIndex) async {
                        // Only stop timer if we're moving the task that has an active timer
                        if (context.read<TaskBloc>().state is TaskLoaded) {
                          final state =
                              context.read<TaskBloc>().state as TaskLoaded;
                          if (state.activeTimerTaskId == task.id) {
                            // Only check the task being moved
                            // Stop timer and wait for it to complete
                            context.read<TaskBloc>().add(StopTimer(task.id!));
                            // Small delay to ensure timer is stopped
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                          }
                        }

                        // Then move the task
                        if (context.mounted) {
                          context.read<TaskBloc>().add(
                                MoveTask(
                                  task.id!,
                                  targetIndex,
                                  targetColumn.toLowerCase(),
                                ),
                              );
                        }
                      },
                      onAddTask: () => context.push('/tasks/$projectId/add'),
                      projectId: projectId,
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(
            body: Center(child: Text('No tasks available.')),
          );
        },
      ),
    );
  }
}
