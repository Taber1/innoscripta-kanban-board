import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/data/models/comment_model.dart';
import 'package:innoscripta_test_kanban/data/providers/comment_api_provider.dart';
import 'package:innoscripta_test_kanban/data/repositories/comment_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([CommentApiProvider])
import 'comment_repository_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CommentRepository repository;
  late MockCommentApiProvider mockProvider;

  setUp(() {
    mockProvider = MockCommentApiProvider();
    repository = CommentRepository(mockProvider);
  });

  group('CommentRepository', () {
    final testComment = {
      'id': '1',
      'task_id': 'task-1',
      'content': 'Test Comment',
      'attachment': null,
      'posted_at': DateTime.now().toIso8601String(),
    };

    test('getComments returns list of comments', () async {
      when(mockProvider.fetchComments('task-1'))
          .thenAnswer((_) async => [testComment]);

      final result = await repository.getComments('task-1');

      expect(result, isA<List<Comment>>());
      expect(result.length, 1);
      expect(result.first.id, testComment['id']);
      expect(result.first.content, testComment['content']);
      verify(mockProvider.fetchComments('task-1')).called(1);
    });

    test('addComment returns created comment', () async {
      when(mockProvider.addComment(
        taskId: 'task-1',
        content: 'Test Comment',
        attachment: null,
      )).thenAnswer((_) async => testComment);

      final result = await repository.addComment(
        taskId: 'task-1',
        content: 'Test Comment',
      );

      expect(result, isA<Comment>());
      expect(result.id, testComment['id']);
      expect(result.content, testComment['content']);
      verify(mockProvider.addComment(
        taskId: 'task-1',
        content: 'Test Comment',
        attachment: null,
      )).called(1);
    });

    test('updateComment returns updated comment', () async {
      when(mockProvider.updateComment(
        commentId: '1',
        content: 'Updated Comment',
      )).thenAnswer((_) async => {
            ...testComment,
            'content': 'Updated Comment',
          });

      final result = await repository.updateComment(
        commentId: '1',
        content: 'Updated Comment',
      );

      expect(result, isA<Comment>());
      expect(result.id, testComment['id']);
      expect(result.content, 'Updated Comment');
      verify(mockProvider.updateComment(
        commentId: '1',
        content: 'Updated Comment',
      )).called(1);
    });

    test('deleteComment completes successfully', () async {
      when(mockProvider.deleteComment('1')).thenAnswer((_) async => {});

      await repository.deleteComment('1');

      verify(mockProvider.deleteComment('1')).called(1);
    });

    test('getComments handles errors', () async {
      when(mockProvider.fetchComments('task-1'))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.getComments('task-1'),
        throwsException,
      );
    });
  });
}
