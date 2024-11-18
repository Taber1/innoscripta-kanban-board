// Mocks generated by Mockito 5.4.4 from annotations
// in innoscripta_test_kanban/test/blocs/completed_task/completed_task_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:innoscripta_test_kanban/data/models/project_model.dart' as _i3;
import 'package:innoscripta_test_kanban/data/models/task_model.dart' as _i6;
import 'package:innoscripta_test_kanban/data/repositories/project_repository.dart'
    as _i7;
import 'package:innoscripta_test_kanban/data/services/local_storage_service.dart'
    as _i2;
import 'package:innoscripta_test_kanban/data/services/task_storage_service.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLocalStorageService_0 extends _i1.SmartFake
    implements _i2.LocalStorageService {
  _FakeLocalStorageService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProject_1 extends _i1.SmartFake implements _i3.Project {
  _FakeProject_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TaskStorageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskStorageService extends _i1.Mock
    implements _i4.TaskStorageService {
  MockTaskStorageService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.LocalStorageService get storageService => (super.noSuchMethod(
        Invocation.getter(#storageService),
        returnValue: _FakeLocalStorageService_0(
          this,
          Invocation.getter(#storageService),
        ),
      ) as _i2.LocalStorageService);

  @override
  _i5.Future<void> addCompletedTask(_i6.Task? task) => (super.noSuchMethod(
        Invocation.method(
          #addCompletedTask,
          [task],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  List<_i6.Task> getCompletedTasks() => (super.noSuchMethod(
        Invocation.method(
          #getCompletedTasks,
          [],
        ),
        returnValue: <_i6.Task>[],
      ) as List<_i6.Task>);

  @override
  _i5.Future<void> saveTimerStartTime(String? timeString) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveTimerStartTime,
          [timeString],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> clearCompletedTasks() => (super.noSuchMethod(
        Invocation.method(
          #clearCompletedTasks,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> saveTimerState(String? taskId) => (super.noSuchMethod(
        Invocation.method(
          #saveTimerState,
          [taskId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> saveTaskDuration(
    String? taskId,
    int? duration,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveTaskDuration,
          [
            taskId,
            duration,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  int getTaskDuration(String? taskId) => (super.noSuchMethod(
        Invocation.method(
          #getTaskDuration,
          [taskId],
        ),
        returnValue: 0,
      ) as int);

  @override
  _i5.Future<void> clearTaskTimer(String? taskId) => (super.noSuchMethod(
        Invocation.method(
          #clearTaskTimer,
          [taskId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [ProjectRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockProjectRepository extends _i1.Mock implements _i7.ProjectRepository {
  MockProjectRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<_i3.Project>> getProjects() => (super.noSuchMethod(
        Invocation.method(
          #getProjects,
          [],
        ),
        returnValue: _i5.Future<List<_i3.Project>>.value(<_i3.Project>[]),
      ) as _i5.Future<List<_i3.Project>>);

  @override
  _i5.Future<List<_i3.Project>> getProjectsByIds(List<String>? projectIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #getProjectsByIds,
          [projectIds],
        ),
        returnValue: _i5.Future<List<_i3.Project>>.value(<_i3.Project>[]),
      ) as _i5.Future<List<_i3.Project>>);

  @override
  _i5.Future<_i3.Project?> getProjectById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getProjectById,
          [id],
        ),
        returnValue: _i5.Future<_i3.Project?>.value(),
      ) as _i5.Future<_i3.Project?>);

  @override
  _i5.Future<_i3.Project> createProject(_i3.Project? project) =>
      (super.noSuchMethod(
        Invocation.method(
          #createProject,
          [project],
        ),
        returnValue: _i5.Future<_i3.Project>.value(_FakeProject_1(
          this,
          Invocation.method(
            #createProject,
            [project],
          ),
        )),
      ) as _i5.Future<_i3.Project>);

  @override
  _i5.Future<void> deleteProject(String? projectId) => (super.noSuchMethod(
        Invocation.method(
          #deleteProject,
          [projectId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i3.Project> updateProject(_i3.Project? project) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateProject,
          [project],
        ),
        returnValue: _i5.Future<_i3.Project>.value(_FakeProject_1(
          this,
          Invocation.method(
            #updateProject,
            [project],
          ),
        )),
      ) as _i5.Future<_i3.Project>);
}
