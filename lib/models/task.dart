import 'package:hive/hive.dart';

part 'task.g.dart'; // Generated file after running build_runner

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String? id; // MongoDB _id (optional for local tasks)

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  String priority;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
    };
  }
}