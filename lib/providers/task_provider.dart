import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Initialize the provider (called once in main.dart)
  Future<void> init() async {
    await syncTasks();
  }

  // Sync tasks between local storage and backend
  Future<void> syncTasks() async {
    try {
      // Fetch tasks from the backend
      final backendTasks = await _apiService.fetchTasks();
      final localTasks = _dbService.getTasks();

      // Sync local tasks to backend if they don’t exist there
      for (var localTask in localTasks) {
        if (localTask.id == null || !backendTasks.any((bt) => bt.id == localTask.id)) {
          final newTask = await _apiService.createTask(localTask);
          await _dbService.updateTask(localTask.id, newTask); // Update local task with backend ID
        }
      }

      // Update local storage with backend tasks
      _tasks = backendTasks;
      for (var task in _tasks) {
        await _dbService.addTask(task); // Ensure local storage matches backend
      }
    } catch (e) {
      print('Sync Error: $e');
      // Fallback to local tasks if backend sync fails
      _tasks = _dbService.getTasks();
    }
    notifyListeners(); // Notify UI of changes
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    try {
      final newTask = await _apiService.createTask(task);
      await _dbService.addTask(newTask);
      _tasks.add(newTask);
    } catch (e) {
      print('Failed to add task to backend: $e');
      // Save locally if API fails
      await _dbService.addTask(task);
      _tasks.add(task);
    }
    notifyListeners();
  }

  // Update an existing task
  Future<void> updateTask(String? id, Task task) async {
    try {
      if (id != null) {
        // Update task on backend if it has an ID
        final updatedTask = await _apiService.updateTask(id, task);
        await _dbService.updateTask(id, updatedTask);
        final index = _tasks.indexWhere((t) => t.id == id);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
      } else {
        // If no ID, treat it as a new task
        final newTask = await _apiService.createTask(task);
        await _dbService.addTask(newTask);
        _tasks.add(newTask);
      }
    } catch (e) {
      print('Update Error: $e');
      // Update locally even if API fails
      await _dbService.updateTask(id, task);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = task;
      } else {
        _tasks.add(task); // Add if it’s a new local task
      }
    }
    notifyListeners();
  }

  // Delete a task
  Future<void> deleteTask(String? id) async {
    try {
      if (id != null) {
        // Delete from backend if it has an ID
        await _apiService.deleteTask(id);
      }
      await _dbService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
    } catch (e) {
      print('Delete Error: $e');
      // Delete locally even if API fails
      await _dbService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
    }
    notifyListeners();
  }
}