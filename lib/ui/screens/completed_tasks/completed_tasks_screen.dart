import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/data/models/project_model.dart';
import '../../../blocs/completed_task/completed_task_bloc.dart';
import '../../../blocs/completed_task/completed_task_event.dart';
import '../../../blocs/completed_task/completed_task_state.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';
import '../../utils/project_colors.dart';
import 'widgets/project_tasks_bottom_sheet.dart';

/// Screen that displays all completed tasks grouped by project
class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompletedTaskBloc>().add(LoadCompletedTasks());
  }

  Map<String, List<Task>> _groupTasksByProject(List<Task> tasks) {
    final groupedTasks = <String, List<Task>>{};

    for (final task in tasks) {
      final projectId = task.projectId ?? 'No Project';
      if (!groupedTasks.containsKey(projectId)) {
        groupedTasks[projectId] = [];
      }
      groupedTasks[projectId]!.add(task);
    }

    return groupedTasks;
  }

  void _showProjectTasks(BuildContext context, String projectId,
      List<Task> tasks, Map<String, Project> projects) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProjectTasksBottomSheet(tasks: tasks),
    );
  }

  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content:
            const Text('Are you sure you want to clear all completed tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CompletedTaskBloc>().add(ClearCompletedTasks());
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String projectId, List<Task> projectTasks,
      Project? project, Map<String, Project> projects) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showProjectTasks(
          context,
          projectId,
          projectTasks,
          projects,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.folder_outlined,
                color: project?.color != null
                    ? ProjectColors.getColorByKey(project!.color!).color
                    : Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project?.name ?? 'Unassigned Tasks',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${projectTasks.length} completed tasks',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
        actions: [
          BlocBuilder<CompletedTaskBloc, CompletedTaskState>(
            builder: (context, state) {
              if (state is CompletedTaskLoaded && state.tasks.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _showClearConfirmationDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CompletedTaskBloc, CompletedTaskState>(
        builder: (context, state) {
          if (state is CompletedTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CompletedTaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No completed tasks yet'));
            }

            final groupedTasks = _groupTasksByProject(state.tasks);

            return ListView.builder(
              itemCount: groupedTasks.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final projectId = groupedTasks.keys.elementAt(index);
                final projectTasks = groupedTasks[projectId]!;
                final project = state.projects[projectId];

                return _buildProjectCard(
                  projectId,
                  projectTasks,
                  project,
                  state.projects,
                );
              },
            );
          }

          if (state is CompletedTaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
