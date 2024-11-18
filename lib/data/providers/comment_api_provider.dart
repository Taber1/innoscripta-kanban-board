import '../services/api_service.dart';
import '../models/comment_model.dart';

class CommentApiProvider {
  final ApiService _apiService;

  CommentApiProvider([ApiService? apiService]) 
      : _apiService = apiService ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchComments(String taskId) async {
    final response = await _apiService.getRequest(
      'comments',
      params: {'task_id': taskId},
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> addComment({
    required String taskId,
    required String content,
    Attachment? attachment,
  }) async {
    final Map<String, dynamic> data = {
      'task_id': taskId,
      'content': content,
    };

    if (attachment != null) {
      data['attachment'] = attachment.toJson();
    }

    final response = await _apiService.postRequest('comments', body: data);
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> updateComment({
    required String commentId,
    required String content,
  }) async {
    final response = await _apiService.postRequest(
      'comments/$commentId',
      body: {'content': content},
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> deleteComment(String commentId) async {
    await _apiService.deleteRequest('comments/$commentId');
  }
}
