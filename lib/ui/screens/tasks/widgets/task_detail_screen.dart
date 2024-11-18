import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_state.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';
import 'package:intl/intl.dart';
import '../widgets/comment_card.dart';
import '../widgets/comment_input.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Priority and Description Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  task.description ?? 'No description',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: (task.priority == 1
                                          ? Colors.blue
                                          : task.priority == 2
                                              ? Colors.orange
                                              : Colors.red)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      size: 16,
                                      color: task.priority == 1
                                          ? Colors.blue
                                          : task.priority == 2
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      task.priority == 1
                                          ? "Low"
                                          : task.priority == 2
                                              ? "Medium"
                                              : "High",
                                      style: TextStyle(
                                        color: task.priority == 1
                                            ? Colors.blue
                                            : task.priority == 2
                                                ? Colors.orange
                                                : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Status and Creation Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: task.labels?.first == 'done'
                                          ? Colors.green.withOpacity(0.2)
                                          : task.labels?.first == 'in-progress'
                                              ? Colors.indigo.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      task.labels?.first == 'to-do'
                                          ? 'TO DO'
                                          : task.labels?.first == 'in-progress'
                                              ? 'IN PROGRESS'
                                              : task.labels?.first == 'done'
                                                  ? 'COMPLETED'
                                                  : 'TO DO',
                                      style: TextStyle(
                                        color: task.labels?.first == 'done'
                                            ? Colors.green
                                            : task.labels?.first ==
                                                    'in-progress'
                                                ? Colors.indigo
                                                : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (task.due != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Due Date: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateFormat('MMM d, yyyy').format(
                                              DateTime.parse(task.due!.date)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Created at',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat('MMM d, yyyy h:mm a').format(
                                        task.createdAt ?? DateTime.now()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Comments Section
                  BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                      if (state is CommentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CommentLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.comment_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Comments',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    state.comments.length.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.comments.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return CommentCard(
                                  comment: state.comments[index],
                                );
                              },
                            ),
                          ],
                        );
                      }
                      return const Center(child: Text('No comments yet'));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        CommentInput(taskId: task.id!),
      ],
    );
  }
}
