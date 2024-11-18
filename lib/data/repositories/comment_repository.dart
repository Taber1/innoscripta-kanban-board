import '../providers/comment_api_provider.dart';
import '../models/comment_model.dart';

class CommentRepository {
  final CommentApiProvider _provider;

  CommentRepository([CommentApiProvider? provider])
      : _provider = provider ?? CommentApiProvider();

  Future<List<Comment>> getComments(String taskId) async {
    final commentData = await _provider.fetchComments(taskId);
    return commentData.map((data) => Comment.fromJson(data)).toList();
  }

  Future<Comment> addComment({
    required String taskId,
    required String content,
    Attachment? attachment,
  }) async {
    final commentData = await _provider.addComment(
      taskId: taskId,
      content: content,
      attachment: attachment,
    );
    return Comment.fromJson(commentData);
  }

  Future<Comment> updateComment({
    required String commentId,
    required String content,
  }) async {
    final commentData = await _provider.updateComment(
      commentId: commentId,
      content: content,
    );
    return Comment.fromJson(commentData);
  }

  Future<void> deleteComment(String commentId) async {
    await _provider.deleteComment(commentId);
  }
}
