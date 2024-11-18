import 'package:innoscripta_test_kanban/data/models/project_model.dart';

abstract class ProjectEvent {}

class LoadProjects extends ProjectEvent {}

class AddProject extends ProjectEvent {
  final Project project;

  AddProject(this.project);
}

class DeleteProject extends ProjectEvent {
  final String projectId;
  DeleteProject(this.projectId);
}

class UpdateProject extends ProjectEvent {
  final Project project;

  UpdateProject(this.project);
}
