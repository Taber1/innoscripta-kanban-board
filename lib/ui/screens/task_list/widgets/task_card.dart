import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_event.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_state.dart';
import 'package:innoscripta_test_kanban/ui/utils/priority_helper.dart';
import '../../../../data/models/task_model.dart';

class TaskListCard extends StatelessWidget {
  final Task task;
  final double opacity;
  final bool isTimerActive;
  final int duration;
  final VoidCallback? onStartTimer;
  final VoidCallback? onStopTimer;

  const TaskListCard({
    super.key,
    required this.task,
    this.opacity = 1.0,
    this.isTimerActive = false,
    this.duration = 0,
    this.onStartTimer,
    this.onStopTimer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          '/tasks/${task.projectId}/${task.id}',
          extra: task,
        );
      },
      child: Opacity(
        opacity: opacity,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 4.0,
                  color:
                      PriorityHelper.getColorFromPriority(task.priority ?? 0),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task content
                  Text(
                    task.content ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (task.description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      task.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),

                  // Footer with metadata and timer
                  BlocBuilder<TaskBloc, TaskState>(
                    buildWhen: (previous, current) {
                      if (previous is TaskLoaded && current is TaskLoaded) {
                        return previous.taskDurations[task.id] !=
                                current.taskDurations[task.id] ||
                            previous.activeTimerTaskId !=
                                current.activeTimerTaskId;
                      }
                      return true;
                    },
                    builder: (context, state) {
                      if (state is TaskLoaded) {
                        final isActive = state.activeTimerTaskId == task.id;
                        final currentDuration =
                            state.taskDurations[task.id] ?? 0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First row: Priority and Comments
                            Row(
                              children: [
                                // Priority indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PriorityHelper.getColorFromPriority(
                                            task.priority ?? 0)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    PriorityHelper.getPriorityText(
                                        task.priority ?? 0),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          PriorityHelper.getPriorityTextColor(
                                              task.priority ?? 0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Comments count
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.comment_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${task.commentCount ?? 0}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Second row: Timer
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDuration(currentDuration),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                if (task.labels?.contains('in-progress') ??
                                    false)
                                  InkWell(
                                    child: Icon(
                                      isActive
                                          ? Icons.pause_circle_outlined
                                          : Icons.play_circle_outlined,
                                      color:
                                          isActive ? Colors.red : Colors.green,
                                    ),
                                    onTap: () {
                                      if (isActive) {
                                        context
                                            .read<TaskBloc>()
                                            .add(StopTimer(task.id!));
                                      } else {
                                        context
                                            .read<TaskBloc>()
                                            .add(StartTimer(task.id!));
                                      }
                                    },
                                  ),
                                if (task.labels?.contains('done') ?? false)
                                  InkWell(
                                    child: const Icon(
                                        Icons.check_circle_outline,
                                        size: 20),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<TaskBloc>(),
                                          child: AlertDialog(
                                            title:
                                                const Text('Mark as Completed'),
                                            content: const Text(
                                                'Are you sure you want to mark this task as completed?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context.read<TaskBloc>().add(
                                                        CloseTask(
                                                          taskId: task.id!,
                                                          projectId:
                                                              task.projectId!,
                                                        ),
                                                      );
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 5)
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    } else {
      return '${remainingSeconds}s';
    }
  }
}
