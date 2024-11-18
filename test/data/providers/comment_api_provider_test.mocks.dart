// Mocks generated by Mockito 5.4.4 from annotations
// in innoscripta_test_kanban/test/data/providers/comment_api_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dio/dio.dart' as _i2;
import 'package:innoscripta_test_kanban/data/services/api_service.dart' as _i3;
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

class _FakeResponse_0<T> extends _i1.SmartFake implements _i2.Response<T> {
  _FakeResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiService extends _i1.Mock implements _i3.ApiService {
  @override
  _i4.Future<_i2.Response<dynamic>> getRequest(
    String? endpoint, {
    Map<String, dynamic>? params,
    bool? showLoader = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRequest,
          [endpoint],
          {
            #params: params,
            #showLoader: showLoader,
          },
        ),
        returnValue:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #getRequest,
            [endpoint],
            {
              #params: params,
              #showLoader: showLoader,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #getRequest,
            [endpoint],
            {
              #params: params,
              #showLoader: showLoader,
            },
          ),
        )),
      ) as _i4.Future<_i2.Response<dynamic>>);

  @override
  _i4.Future<_i2.Response<dynamic>> postRequest(
    String? endpoint, {
    Map<String, dynamic>? body,
    bool? showLoader = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #postRequest,
          [endpoint],
          {
            #body: body,
            #showLoader: showLoader,
          },
        ),
        returnValue:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #postRequest,
            [endpoint],
            {
              #body: body,
              #showLoader: showLoader,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #postRequest,
            [endpoint],
            {
              #body: body,
              #showLoader: showLoader,
            },
          ),
        )),
      ) as _i4.Future<_i2.Response<dynamic>>);

  @override
  _i4.Future<_i2.Response<dynamic>> putRequest(
    String? endpoint, {
    Map<String, dynamic>? body,
    bool? showLoader = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #putRequest,
          [endpoint],
          {
            #body: body,
            #showLoader: showLoader,
          },
        ),
        returnValue:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #putRequest,
            [endpoint],
            {
              #body: body,
              #showLoader: showLoader,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #putRequest,
            [endpoint],
            {
              #body: body,
              #showLoader: showLoader,
            },
          ),
        )),
      ) as _i4.Future<_i2.Response<dynamic>>);

  @override
  _i4.Future<_i2.Response<dynamic>> deleteRequest(
    String? endpoint, {
    bool? showLoader = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteRequest,
          [endpoint],
          {#showLoader: showLoader},
        ),
        returnValue:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #deleteRequest,
            [endpoint],
            {#showLoader: showLoader},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<dynamic>>.value(_FakeResponse_0<dynamic>(
          this,
          Invocation.method(
            #deleteRequest,
            [endpoint],
            {#showLoader: showLoader},
          ),
        )),
      ) as _i4.Future<_i2.Response<dynamic>>);
}
