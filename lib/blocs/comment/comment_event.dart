import '../../data/models/comment_model.dart';

abstract class CommentEvent {}

class LoadComments extends CommentEvent {
  final String taskId;
  LoadComments(this.taskId);
}

class AddComment extends CommentEvent {
  final String taskId;
  final String content;
  final Attachment? attachment;

  AddComment({
    required this.taskId,
    required this.content,
    this.attachment,
  });
}

class UpdateComment extends CommentEvent {
  final String commentId;
  final String content;

  UpdateComment({
    required this.commentId,
    required this.content,
  });
}

class DeleteComment extends CommentEvent {
  final String commentId;
  DeleteComment(this.commentId);
} 