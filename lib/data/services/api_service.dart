import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:innoscripta_test_kanban/routes/app_router.dart';
import '../../ui/utils/loader_dialog.dart';
import '../../ui/utils/toast_widget.dart';

class ApiService {
  static const String baseUrl = 'https://api.todoist.com/rest/v2/';
  static const String token = 'Bearer 66f843ac31bff4c0005aef09bffa8a4c49731733';

  final Dio _dio;

  ApiService([Dio? dio]) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    ),
  ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log("URL: ${options.uri.toString()}");
        if (options.queryParameters.isNotEmpty) {
          log("Data: ${options.queryParameters.toString()}");
        }
        if (options.data != null) {
          log("Data: ${options.data}");
        }
        final showLoader = options.extra['showLoader'] ?? false;
        if (showLoader) {
          final context = navigatorKey.currentContext;
          if (context != null) {
            LoaderDialog.show(context); // Show loader
          }
        }
        return handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        log("Response: ${response.data.toString()}");
        final showLoader = response.requestOptions.extra['showLoader'] ?? false;
        if (showLoader) {
          final context = navigatorKey.currentContext;
          if (context != null) {
            LoaderDialog.hide(context); // Hide loader
          }
        }
        return handler.next(response); // Continue with the response
      },
      onError: (DioException error, handler) {
        final showLoader = error.requestOptions.extra['showLoader'] ?? false;
        if (showLoader) {
          final context = navigatorKey.currentContext;
          if (context != null) {
            LoaderDialog.hide(context); // Ensure loader is hidden
          }
        }
        log('Error: ${error.message}');
        ToastWidget.show('Error: ${error.message}');
        return handler.next(error); // Continue with the error
      },
    ));
  }

  Future<Response> getRequest(
    String endpoint, {
    Map<String, dynamic>? params,
    bool showLoader = false,
  }) async {
    return _dio.get(endpoint,
        queryParameters: params,
        options: Options(extra: {'showLoader': showLoader}));
  }

  Future<Response> postRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    bool showLoader = false,
  }) async {
    return _dio.post(
      endpoint,
      data: body,
      options: Options(extra: {'showLoader': showLoader}),
    );
  }

  Future<Response> putRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    bool showLoader = false,
  }) async {
    return _dio.put(
      endpoint,
      data: body,
      options: Options(extra: {'showLoader': showLoader}),
    );
  }

  Future<Response> deleteRequest(
    String endpoint, {
    bool showLoader = false,
  }) async {
    return _dio.delete(
      endpoint,
      options: Options(extra: {'showLoader': showLoader}),
    );
  }
}
