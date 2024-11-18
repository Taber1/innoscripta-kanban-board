import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/data/repositories/project_repository.dart';
import '../../data/services/task_storage_service.dart';
import 'completed_task_event.dart';
import 'completed_task_state.dart';

class CompletedTaskBloc extends Bloc<CompletedTaskEvent, CompletedTaskState> {
  final TaskStorageService _taskStorageService;
  final ProjectRepository _projectRepository;

  CompletedTaskBloc({
    TaskStorageService? taskStorageService,
    ProjectRepository? projectRepository,
  })  : _taskStorageService = taskStorageService ?? TaskStorageService(),
        _projectRepository = projectRepository ?? ProjectRepository(),
        super(CompletedTaskInitial()) {
    on<LoadCompletedTasks>((event, emit) async {
      emit(CompletedTaskLoading());
      try {
        final tasks = _taskStorageService.getCompletedTasks();
        final projectIds =
            tasks.map((t) => t.projectId).whereType<String>().toSet();
        final projects =
            await _projectRepository.getProjectsByIds(projectIds.toList());

        final projectsMap = {
          for (var project in projects) project.id!: project
        };

        emit(CompletedTaskLoaded(tasks, projectsMap));
      } catch (e) {
        emit(CompletedTaskError(e.toString()));
      }
    });

    on<AddCompletedTask>((event, emit) async {
      try {
        final taskWithCompletion = event.task.copyWith(
          timeSpent: event.timeSpent,
          completedAt: DateTime.now(),
          isCompleted: true,
        );
        await _taskStorageService.addCompletedTask(taskWithCompletion);
        add(LoadCompletedTasks());
      } catch (e) {
        emit(CompletedTaskError(e.toString()));
      }
    });

    on<ClearCompletedTasks>((event, emit) async {
      try {
        await _taskStorageService.clearCompletedTasks();
        emit(CompletedTaskLoaded([], {}));
      } catch (e) {
        emit(CompletedTaskError(e.toString()));
      }
    });
  }
}
