import 'package:equatable/equatable.dart';

class Task extends Equatable {
  String? id;
  String? creatorId;
  DateTime? createdAt;
  String? assigneeId;
  String? assignerId;
  int? commentCount;
  bool? isCompleted;
  String? content;
  String? description;
  TaskDue? due;
  String? dueDate;
  TaskDuration? duration;
  List<String>? labels;
  int? order;
  int? priority;
  String? projectId;
  String? sectionId;
  String? parentId;
  String? url;
  final int? timeSpent;
  final DateTime? completedAt;

  Task({
    this.id,
    this.creatorId,
    this.createdAt,
    this.assigneeId,
    this.assignerId,
    this.commentCount,
    this.isCompleted,
    this.content,
    this.description,
    this.due,
    this.dueDate,
    this.duration,
    this.labels,
    this.order,
    this.priority,
    this.projectId,
    this.sectionId,
    this.parentId,
    this.url,
    this.timeSpent,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        creatorId,
        createdAt,
        assigneeId,
        assignerId,
        commentCount,
        isCompleted,
        content,
        description,
        due,
        dueDate,
        duration,
        labels,
        order,
        priority,
        projectId,
        sectionId,
        parentId,
        url,
        timeSpent,
        completedAt,
      ];

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      creatorId: json['creator_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      assigneeId: json['assignee_id'],
      assignerId: json['assigner_id'],
      commentCount: json['comment_count'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      due: json['due'] != null ? TaskDue.fromJson(json['due']) : null,
      labels: json['labels'] != null ? List<String>.from(json['labels']) : [],
      order: json['order'] ?? 0,
      priority: json['priority'] ?? 1,
      projectId: json['project_id'],
      sectionId: json['section_id'],
      parentId: json['parent_id'],
      url: json['url'],
      timeSpent: json['time_spent'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'created_at': createdAt?.toIso8601String(),
      'assignee_id': assigneeId,
      'assigner_id': assignerId,
      'comment_count': commentCount,
      'is_completed': isCompleted,
      'content': content,
      'description': description,
      'due': due,
      'due_date': dueDate,
      'duration': duration?.toJson(), // Ensure TaskDuration has a toJson method
      'labels': labels,
      'order': order,
      'priority': priority,
      'project_id': projectId,
      'section_id': sectionId,
      'parent_id': parentId,
      'url': url,
      'time_spent': timeSpent,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? creatorId,
    DateTime? createdAt,
    String? assigneeId,
    String? assignerId,
    int? commentCount,
    bool? isCompleted,
    String? content,
    String? description,
    TaskDue? due,
    String? dueDate,
    TaskDuration? duration,
    List<String>? labels,
    int? order,
    int? priority,
    String? projectId,
    String? sectionId,
    String? parentId,
    String? url,
    int? timeSpent,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      assigneeId: assigneeId ?? this.assigneeId,
      assignerId: assignerId ?? this.assignerId,
      commentCount: commentCount ?? this.commentCount,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
      description: description ?? this.description,
      due: due ?? this.due,
      dueDate: dueDate ?? this.dueDate,
      duration: duration ?? this.duration,
      labels: labels ?? this.labels,
      order: order ?? this.order,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      sectionId: sectionId ?? this.sectionId,
      parentId: parentId ?? this.parentId,
      url: url ?? this.url,
      timeSpent: timeSpent ?? this.timeSpent,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class TaskDue extends Equatable {
  final String date;
  final bool isRecurring;
  final String string;
  DateTime? datetime;
  String? timezone;

  TaskDue({
    required this.date,
    required this.isRecurring,
    required this.string,
    this.datetime,
    this.timezone,
  });

  @override
  List<Object?> get props => [date, isRecurring, string, datetime, timezone];

  factory TaskDue.fromJson(Map<String, dynamic> json) {
    return TaskDue(
      date: json['date'],
      isRecurring: json['is_recurring'],
      string: json['string'],
      datetime:
          json['datetime'] != null ? DateTime.parse(json['datetime']) : null,
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'is_recurring': isRecurring,
      'datetime': datetime,
      'string': string,
      'timezone': timezone,
    };
  }
}

class TaskDuration {
  final int amount;
  final String unit;

  TaskDuration({
    required this.amount,
    required this.unit,
  });

  factory TaskDuration.fromJson(Map<String, dynamic> json) {
    return TaskDuration(
      amount: json['amount'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}
