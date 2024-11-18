import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_event.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_event.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_state.dart';
import 'package:innoscripta_test_kanban/data/models/task_model.dart';
import 'package:innoscripta_test_kanban/data/repositories/comment_repository.dart';
import 'package:innoscripta_test_kanban/ui/screens/tasks/widgets/task_detail_screen.dart';

class TaskScreen extends StatelessWidget {
  final Task task;
  final CommentRepository commentRepository;

  const TaskScreen({
    super.key,
    required this.task,
    required this.commentRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(
            repository: commentRepository,
          )..add(LoadComments(task.id!)),
        ),
      ],
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final updatedTask = state is TaskLoaded
              ? [...state.todo, ...state.inProgress, ...state.completed]
                  .firstWhere(
                  (t) => t.id == task.id,
                  orElse: () => task,
                )
              : task;

          return PopScope(
            onPopInvoked: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.opaque,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SafeArea(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context.pop();
                            },
                          ),
                          Expanded(
                            child: Text(
                              task.content!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: FloatingActionButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final result = await context.push(
                        '/tasks/${updatedTask.projectId}/edit/${updatedTask.id}',
                        extra: updatedTask,
                      );
                      if (context.mounted && result == true) {
                        context.read<TaskBloc>()
                          ..add(LoadProjectTasks(updatedTask.projectId!))
                          ..add(LoadTasks());
                      }
                    },
                    child: const Icon(Icons.edit),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                body: TaskDetailScreen(task: updatedTask),
              ),
            ),
          );
        },
      ),
    );
  }
}
