import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_test_kanban/ui/screens/splash_screen.dart';
import '../data/models/task_model.dart';
import '../ui/screens/projects/project_list_screen.dart';
import '../ui/screens/task_list/task_list_screen.dart';
import '../ui/screens/tasks/task_screen.dart';
import '../ui/screens/tasks/widgets/add_update_task_screen.dart';
import '../ui/screens/completed_tasks/completed_tasks_screen.dart';
import '../data/repositories/comment_repository.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const ProjectListScreen(),
    ),
    GoRoute(
      path: '/tasks/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final projectName = extra['projectName'] as String;
        return TaskListScreen(
          projectId: projectId,
          projectName: projectName,
        );
      },
    ),
    GoRoute(
      path: '/tasks/:projectId/add',
      builder: (context, state) => AddUpdateTaskScreen(
        projectId: state.pathParameters['projectId']!,
        initialStatus: (state.extra as Map<String, String>)['initialStatus']!,
      ),
    ),
    GoRoute(
      path: '/tasks/:projectId/edit/:taskId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final task = state.extra as Task;
        return AddUpdateTaskScreen(
          projectId: projectId,
          task: task,
          initialStatus: task.labels!.first,
        );
      },
    ),
    GoRoute(
      path: '/tasks/:projectId/:taskId',
      builder: (context, state) => TaskScreen(
        task: state.extra as Task,
        commentRepository: CommentRepository(),
      ),
    ),
    GoRoute(
      path: '/completed-tasks',
      builder: (context, state) => const CompletedTasksScreen(),
    ),
  ],
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
