import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:innoscripta_test_kanban/data/services/api_service.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<Interceptors>(),
  MockSpec<RequestOptions>(),
  MockSpec<InterceptorsWrapper>()
])
import 'api_service_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late ApiService apiService;
  late MockInterceptors mockInterceptors;

  setUp(() {
    mockDio = MockDio();
    mockInterceptors = MockInterceptors();
    
    // Setup the mock interceptors and options
    when(mockDio.interceptors).thenReturn(mockInterceptors);
    when(mockDio.options).thenReturn(BaseOptions(
      baseUrl: ApiService.baseUrl,
      headers: {
        'Authorization': ApiService.token,
        'Content-Type': 'application/json',
      },
    ));
    
    apiService = ApiService(mockDio);
  });

  group('ApiService Tests', () {
    test('getRequest should make GET request with correct parameters',
        () async {
      // Arrange
      final endpoint = 'tasks';
      final params = {'project_id': '2343651050'};
      
      when(
        mockDio.get(
          endpoint,
          queryParameters: params,
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => Response(
            requestOptions: MockRequestOptions(),
            data: {'success': true},
            statusCode: 200,
          ));

      // Act
      final response = await apiService.getRequest(
        endpoint,
        params: params,
        showLoader: false,
      );

      // Assert
      verify(mockDio.get(
        endpoint,
        queryParameters: params,
        options: anyNamed('options'),
      )).called(1);
      expect(response.statusCode, 200);
      expect(response.data['success'], true);
    });

    test('postRequest should make POST request with correct body', () async {
      // Arrange
      final endpoint = 'tasks';
      final body = {'title': 'Test Task'};
      
      when(
        mockDio.post(
          endpoint,
          data: body,
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => Response(
            requestOptions: MockRequestOptions(),
            data: {'success': true},
            statusCode: 201,
          ));

      // Act
      final response = await apiService.postRequest(
        endpoint,
        body: body,
        showLoader: false,
      );

      // Assert
      verify(mockDio.post(
        endpoint,
        data: body,
        options: anyNamed('options'),
      )).called(1);
      expect(response.statusCode, 201);
      expect(response.data['success'], true);
    });

    test('putRequest should make PUT request with correct body', () async {
      // Arrange
      final endpoint = 'tasks/8596158152';
      final body = {'title': 'Updated Task'};
      
      when(
        mockDio.put(
          endpoint,
          data: body,
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => Response(
            requestOptions: MockRequestOptions(),
            data: {'success': true},
            statusCode: 200,
          ));

      // Act
      final response = await apiService.putRequest(
        endpoint,
        body: body,
        showLoader: false,
      );

      // Assert
      verify(mockDio.put(
        endpoint,
        data: body,
        options: anyNamed('options'),
      )).called(1);
      expect(response.statusCode, 200);
      expect(response.data['success'], true);
    });

    test('deleteRequest should make DELETE request', () async {
      // Arrange
      final endpoint = 'tasks/8596158152';
      
      when(
        mockDio.delete(
          endpoint,
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => Response(
            requestOptions: MockRequestOptions(),
            data: {'success': true},
            statusCode: 200,
          ));

      // Act
      final response = await apiService.deleteRequest(
        endpoint,
        showLoader: false,
      );

      // Assert
      verify(mockDio.delete(
        endpoint,
        options: anyNamed('options'),
      )).called(1);
      expect(response.statusCode, 200);
      expect(response.data['success'], true);
    });
  });
}
