import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/comment_repository.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc({required this.repository}) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
    on<UpdateComment>(_onUpdateComment);
    on<DeleteComment>(_onDeleteComment);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    try {
      final comments = await repository.getComments(event.taskId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      await repository.addComment(
        taskId: event.taskId,
        content: event.content,
        attachment: event.attachment,
      );
      add(LoadComments(event.taskId));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onUpdateComment(
    UpdateComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      await repository.updateComment(
        commentId: event.commentId,
        content: event.content,
      );
      if (state is CommentLoaded) {
        final comments = (state as CommentLoaded).comments;
        add(LoadComments(comments.first.taskId));
      }
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      await repository.deleteComment(event.commentId);
      if (state is CommentLoaded) {
        final comments = (state as CommentLoaded).comments;
        add(LoadComments(comments.first.taskId));
      }
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
