import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class DatabaseService {
  static const String boxName = 'tasks';

  Box<Task> get _taskBox {
    if (!Hive.isBoxOpen(boxName)) {
      Hive.openBox<Task>(boxName);
    }
    return Hive.box<Task>(boxName);
  }

  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
  }

  Future<void> updateTask(String? id, Task task) async {
    final tasks = _taskBox.values.toList();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      await _taskBox.putAt(index, task);
    }
  }

  Future<void> deleteTask(String? id) async {
    final tasks = _taskBox.values.toList();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      await _taskBox.deleteAt(index);
    } else if (id == null) {
      print('Cannot delete task with null ID from local storage');
    }
  }

  List<Task> getTasks() {
    return _taskBox.values.toList();
  }
}