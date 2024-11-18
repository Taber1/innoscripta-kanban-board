import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_event.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_state.dart';
import 'package:innoscripta_test_kanban/blocs/theme/theme_event.dart';
import 'package:innoscripta_test_kanban/ui/screens/projects/widgets/project_card.dart';
import '../../../blocs/theme/theme_bloc.dart';
import 'widgets/add_update_project_dialog.dart';
import 'package:go_router/go_router.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.task_alt_outlined),
            tooltip: 'Completed Tasks',
            onPressed: () => context.push('/completed-tasks'),
          ),
          IconButton(
            icon: Icon(
              context.watch<ThemeBloc>().state.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddUpdateProjectDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Projects',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProjectLoaded) {
                  return ListView.builder(
                    itemCount: state.projects.length,
                    itemBuilder: (context, index) {
                      final project = state.projects[index];
                      return ProjectCard(
                        project: project,
                        onEdit: () => showDialog(
                          context: context,
                          builder: (_) =>
                              AddUpdateProjectDialog(project: project),
                        ),
                        onDelete: () => context
                            .read<ProjectBloc>()
                            .add(DeleteProject(project.id!)),
                      );
                    },
                  );
                }

                if (state is ProjectError) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                return const Center(child: Text('No projects available.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
