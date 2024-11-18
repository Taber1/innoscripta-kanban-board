class Comment {
  final String id;
  final String content;
  final String taskId;
  final String? projectId;
  final DateTime postedAt;
  final Attachment? attachment;

  Comment({
    required this.id,
    required this.content,
    required this.taskId,
    this.projectId,
    required this.postedAt,
    this.attachment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      taskId: json['task_id'],
      projectId: json['project_id'],
      postedAt: DateTime.parse(json['posted_at']),
      attachment: json['attachment'] != null 
          ? Attachment.fromJson(json['attachment']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'task_id': taskId,
      'project_id': projectId,
      'posted_at': postedAt.toIso8601String(),
      'attachment': attachment?.toJson(),
    };
  }
}

class Attachment {
  final String fileName;
  final String fileType;
  final String fileUrl;
  final String resourceType;

  Attachment({
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    required this.resourceType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      fileName: json['file_name'],
      fileType: json['file_type'],
      fileUrl: json['file_url'],
      resourceType: json['resource_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_name': fileName,
      'file_type': fileType,
      'file_url': fileUrl,
      'resource_type': resourceType,
    };
  }
} 