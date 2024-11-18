// Mocks generated by Mockito 5.4.4 from annotations
// in innoscripta_test_kanban/test/data/repositories/project_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:innoscripta_test_kanban/data/models/project_model.dart' as _i4;
import 'package:innoscripta_test_kanban/data/providers/project_api_provider.dart'
    as _i2;
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

/// A class which mocks [ProjectApiProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockProjectApiProvider extends _i1.Mock
    implements _i2.ProjectApiProvider {
  MockProjectApiProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<Map<String, dynamic>>> fetchProjects() => (super.noSuchMethod(
        Invocation.method(
          #fetchProjects,
          [],
        ),
        returnValue: _i3.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i3.Future<List<Map<String, dynamic>>>);

  @override
  _i3.Future<Map<String, dynamic>> fetchProjectById(String? projectId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchProjectById,
          [projectId],
        ),
        returnValue:
            _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i3.Future<Map<String, dynamic>>);

  @override
  _i3.Future<Map<String, dynamic>> addProject(_i4.Project? project) =>
      (super.noSuchMethod(
        Invocation.method(
          #addProject,
          [project],
        ),
        returnValue:
            _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i3.Future<Map<String, dynamic>>);

  @override
  _i3.Future<void> deleteProject(String? projectId) => (super.noSuchMethod(
        Invocation.method(
          #deleteProject,
          [projectId],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<Map<String, dynamic>> updateProject(_i4.Project? project) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateProject,
          [project],
        ),
        returnValue:
            _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i3.Future<Map<String, dynamic>>);
}