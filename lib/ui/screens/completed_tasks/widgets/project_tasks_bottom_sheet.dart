import 'package:flutter/material.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';
import 'completed_task_card.dart';

class ProjectTasksBottomSheet extends StatelessWidget {
  final List<Task> tasks;

  const ProjectTasksBottomSheet({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) => CompletedTaskCard(task: tasks[index]),
            ),
          ),
        ],
      ),
    );
  }
} 