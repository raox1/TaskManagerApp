import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.5:5000/api/tasks'; // Adjust for your setup

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('Fetch Tasks Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch Tasks Error: $e');
      rethrow;
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      print('Create Task Request: ${jsonEncode(task.toJson())}');
      print('Create Task Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 201) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      print('Create Task Error: $e');
      rethrow;
    }
  }

  Future<Task> updateTask(String id, Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      print('Update Task Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      print('Update Task Error: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      print('Delete Task Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete Task Error: $e');
      rethrow;
    }
  }
}