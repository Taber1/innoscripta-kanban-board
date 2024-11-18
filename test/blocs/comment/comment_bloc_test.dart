import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_event.dart';
import 'package:innoscripta_test_kanban/blocs/comment/comment_state.dart';
import 'package:innoscripta_test_kanban/data/models/comment_model.dart';
import 'package:innoscripta_test_kanban/data/repositories/comment_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'comment_bloc_test.mocks.dart';

@GenerateMocks([CommentRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CommentBloc commentBloc;
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
    commentBloc = CommentBloc(repository: mockRepository);
  });

  tearDown(() {
    commentBloc.close();
  });

  group('CommentBloc', () {
    final testComment = Comment(
      id: '1',
      taskId: 'task1',
      content: 'Test Comment',
      postedAt: DateTime.now(),
    );
    final testComments = [testComment];

    test('initial state should be CommentInitial', () {
      expect(commentBloc.state, isA<CommentInitial>());
    });

    group('LoadComments', () {
      blocTest<CommentBloc, CommentState>(
        'emits [CommentLoading, CommentLoaded] when successful',
        build: () {
          when(mockRepository.getComments('task1'))
              .thenAnswer((_) async => testComments);
          return commentBloc;
        },
        act: (bloc) => bloc.add(LoadComments('task1')),
        expect: () => [
          isA<CommentLoading>(),
          isA<CommentLoaded>(),
        ],
      );

      blocTest<CommentBloc, CommentState>(
        'emits [CommentLoading, CommentError] when unsuccessful',
        build: () {
          when(mockRepository.getComments('task1'))
              .thenThrow(Exception('Failed to load comments'));
          return commentBloc;
        },
        act: (bloc) => bloc.add(LoadComments('task1')),
        expect: () => [
          isA<CommentLoading>(),
          isA<CommentError>(),
        ],
      );
    });

    group('AddComment', () {
      blocTest<CommentBloc, CommentState>(
        'calls repository and triggers LoadComments when successful',
        build: () {
          when(mockRepository.addComment(
            taskId: 'task1',
            content: 'Test Comment',
            attachment: null,
          )).thenAnswer((_) async => testComment);
          when(mockRepository.getComments('task1'))
              .thenAnswer((_) async => testComments);
          return commentBloc;
        },
        act: (bloc) => bloc.add(AddComment(
          taskId: 'task1',
          content: 'Test Comment',
        )),
        verify: (_) {
          verify(mockRepository.addComment(
            taskId: 'task1',
            content: 'Test Comment',
            attachment: null,
          )).called(1);
          verify(mockRepository.getComments('task1')).called(1);
        },
      );

      blocTest<CommentBloc, CommentState>(
        'emits CommentError when unsuccessful',
        build: () {
          when(mockRepository.addComment(
            taskId: 'task1',
            content: 'Test Comment',
            attachment: null,
          )).thenThrow(Exception('Failed to add comment'));
          return commentBloc;
        },
        act: (bloc) => bloc.add(AddComment(
          taskId: 'task1',
          content: 'Test Comment',
        )),
        expect: () => [isA<CommentError>()],
      );
    });

    group('UpdateComment', () {
      blocTest<CommentBloc, CommentState>(
        'calls repository and triggers LoadComments when successful',
        build: () {
          when(mockRepository.updateComment(
            commentId: '1',
            content: 'Updated Comment',
          )).thenAnswer((_) async => testComment);
          when(mockRepository.getComments('task1'))
              .thenAnswer((_) async => testComments);
          return commentBloc;
        },
        act: (bloc) => bloc.add(UpdateComment(
          commentId: '1',
          content: 'Updated Comment',
        )),
        verify: (_) {
          verify(mockRepository.updateComment(
            commentId: '1',
            content: 'Updated Comment',
          )).called(1);
        },
      );
    });

    group('DeleteComment', () {
      blocTest<CommentBloc, CommentState>(
        'calls repository and triggers LoadComments when successful',
        build: () {
          when(mockRepository.deleteComment('1')).thenAnswer((_) async => null);
          when(mockRepository.getComments('task1'))
              .thenAnswer((_) async => testComments);
          return commentBloc;
        },
        act: (bloc) => bloc.add(DeleteComment('1')),
        verify: (_) {
          verify(mockRepository.deleteComment('1')).called(1);
        },
      );
    });
  });
}
