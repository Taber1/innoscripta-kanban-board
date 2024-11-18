import 'project_event.dart';
import 'project_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/project_repository.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository repository;

  ProjectBloc({required this.repository}) : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) async {
      emit(ProjectLoading());
      try {
        final projects = await repository.getProjects();
        emit(ProjectLoaded(projects));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    on<AddProject>((event, emit) async {
      try {
        await repository.createProject(event.project);
        add(LoadProjects()); // Refresh list
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    on<DeleteProject>((event, emit) async {
      try {
        await repository.deleteProject(event.projectId);
        add(LoadProjects()); // Refresh the list after deletion
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    on<UpdateProject>((event, emit) async {
      try {
        await repository.updateProject(event.project);
        add(LoadProjects()); // Refresh the list after update
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });
  }
}
