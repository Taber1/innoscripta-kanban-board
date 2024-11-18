import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'task_card.dart';
import 'task_drag_feedback.dart';
import '../../../../blocs/task/task_bloc.dart';
import '../../../../blocs/task/task_event.dart';
import '../../../../blocs/task/task_state.dart';
import '../../../../data/models/task_model.dart';

class TaskColumns extends StatelessWidget {
  final String title;
  final String statusLabel;
  final List<Task> tasks;
  final Function(Task, String, int) onMoveTask;
  final VoidCallback onAddTask;
  final String projectId;

  const TaskColumns({
    super.key,
    required this.title,
    required this.statusLabel,
    required this.tasks,
    required this.onMoveTask,
    required this.onAddTask,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, candidateData, rejectedData) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () => context.push(
                  '/tasks/$projectId/add',
                  extra: {'initialStatus': statusLabel},
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add Task'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length + 1,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, index) {
                  if (index == tasks.length) {
                    return DragTarget<Map<String, dynamic>>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          height: 20,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: candidateData.isNotEmpty
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                      onAccept: (data) {
                        onMoveTask(data['task'] as Task, title, index);
                      },
                    );
                  }

                  final task = tasks[index];
                  return Column(
                    children: [
                      DragTarget<Map<String, dynamic>>(
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            height: 20,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: candidateData.isNotEmpty
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                        onAccept: (data) {
                          onMoveTask(data['task'] as Task, title, index);
                        },
                      ),
                      LongPressDraggable<Map<String, dynamic>>(
                        data: {
                          'task': task,
                          'sourceIndex': index,
                        },
                        delay: const Duration(milliseconds: 200),
                        feedback: TaskDragFeedback(task: task),
                        childWhenDragging: TaskListCard(
                          task: task,
                          opacity: 0.5,
                        ),
                        child: BlocBuilder<TaskBloc, TaskState>(
                          builder: (context, state) {
                            if (state is TaskLoaded) {
                              return TaskListCard(
                                task: task,
                                isTimerActive:
                                    state.activeTimerTaskId == task.id,
                                duration: state.taskDurations[task.id] ?? 0,
                                onStartTimer: () {
                                  context
                                      .read<TaskBloc>()
                                      .add(StartTimer(task.id!));
                                },
                                onStopTimer: () {
                                  context
                                      .read<TaskBloc>()
                                      .add(StopTimer(task.id!));
                                },
                              );
                            }
                            return TaskListCard(task: task);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
      onAcceptWithDetails: (details) {
        final data = details.data;
        onMoveTask(data['task'] as Task, title, tasks.length);
      },
    );
  }
}
