import 'package:flutter/material.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';

class TaskDragFeedback extends StatelessWidget {
  final Task task;

  const TaskDragFeedback({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              spreadRadius: 1.0,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
