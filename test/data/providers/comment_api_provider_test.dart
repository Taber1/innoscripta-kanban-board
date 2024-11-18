import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/data/providers/comment_api_provider.dart';
import 'package:innoscripta_test_kanban/data/services/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ApiService>()])
import 'comment_api_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CommentApiProvider commentApiProvider;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    commentApiProvider = CommentApiProvider(mockApiService);
  });

  group('CommentApiProvider', () {
    test('fetchComments returns list of comments', () async {
      // Arrange
      const taskId = 'task-1';
      when(mockApiService.getRequest(
        'comments',
        params: {'task_id': taskId},
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'comments'),
            data: [
              {
                'id': '1',
                'task_id': taskId,
                'content': 'Comment 1',
                'attachment': null,
              },
              {
                'id': '2',
                'task_id': taskId,
                'content': 'Comment 2',
                'attachment': null,
              },
            ],
          ));

      // Act
      final result = await commentApiProvider.fetchComments(taskId);

      // Assert
      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 2);
      verify(mockApiService.getRequest(
        'comments',
        params: {'task_id': taskId},
      )).called(1);
    });

    test('addComment creates new comment without attachment', () async {
      // Arrange
      const taskId = 'task-1';
      const content = 'New Comment';

      when(mockApiService.postRequest(
        'comments',
        body: {
          'task_id': taskId,
          'content': content,
        },
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'comments'),
            data: {
              'id': '1',
              'task_id': taskId,
              'content': content,
              'attachment': null,
            },
          ));

      // Act
      final result = await commentApiProvider.addComment(
        taskId: taskId,
        content: content,
      );

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['content'], content);
      verify(mockApiService.postRequest(
        'comments',
        body: {'task_id': taskId, 'content': content},
      )).called(1);
    });

    test('updateComment modifies existing comment', () async {
      // Arrange
      const commentId = '1';
      const newContent = 'Updated Comment';

      when(mockApiService.postRequest(
        'comments/$commentId',
        body: {'content': newContent},
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: 'comments/$commentId'),
            data: {
              'id': commentId,
              'content': newContent,
              'attachment': null,
            },
          ));

      // Act
      final result = await commentApiProvider.updateComment(
        commentId: commentId,
        content: newContent,
      );

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['content'], newContent);
      verify(mockApiService.postRequest(
        'comments/$commentId',
        body: {'content': newContent},
      )).called(1);
    });
  });
}
