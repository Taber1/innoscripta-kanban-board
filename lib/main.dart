import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/completed_task/completed_task_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/completed_task/completed_task_event.dart';
import 'package:innoscripta_test_kanban/blocs/task/task_event.dart';
import 'package:innoscripta_test_kanban/data/repositories/comment_repository.dart';
import 'package:innoscripta_test_kanban/data/services/local_storage_service.dart';
import 'blocs/project/project_bloc.dart';
import 'blocs/project/project_event.dart';
import 'blocs/task/task_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_event.dart';
import 'blocs/theme/theme_state.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/project_repository.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProjectBloc(repository: ProjectRepository())..add(LoadProjects()),
        ),
        BlocProvider(
          create: (context) => TaskBloc()..add(InitializeTimerState()),
        ),
        BlocProvider(
          create: (context) => CommentBloc(repository: CommentRepository()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc()..add(LoadTheme(isDarkMode: true)),
        ),
        BlocProvider<CompletedTaskBloc>(
          create: (context) => CompletedTaskBloc()..add(LoadCompletedTasks()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            routerConfig: appRouter,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
