import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late String _priority;
  late AnimationController _controller;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _priority = widget.task?.priority ?? 'Medium';

    // Debug prints
    print('Initial Title: ${widget.task?.title ?? ''}');
    print('Initial Description: ${widget.task?.description ?? 'null'}');
    print('Initial Due Date: $_dueDate');
    print('Initial Priority: $_priority');

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();

    // Force rebuild after frame to ensure text renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle: const TextStyle(color: Color(0xFF8B5CF6)),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  validator: (value) => value!.isEmpty ? 'Title is required' : null,
                  onSaved: (value) => _titleController.text = value!,
                ),
                const SizedBox(height: 20),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle: const TextStyle(color: Color(0xFF8B5CF6)),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 3,
                  onSaved: (value) => _descriptionController.text = value ?? '',
                ),
                const SizedBox(height: 20),

                // Due Date Picker
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xFF8B5CF6),
                              onPrimary: Colors.white,
                              surface: Color(0xFF2A2A2A),
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: const Color(0xFF1A1A1A),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) setState(() => _dueDate = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Due Date: ${DateFormat.yMMMd().format(_dueDate)}',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const Icon(Icons.calendar_today, color: Color(0xFF8B5CF6)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Priority Dropdown
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: ['Low', 'Medium', 'High']
                      .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p, style: const TextStyle(color: Colors.white)),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _priority = value!),
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle: const TextStyle(color: Color(0xFF8B5CF6)),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                    ),
                  ),
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 30),

                // Submit Button
                Center(
                  child: ScaleTransition(
                    scale: _buttonAnimation,
                    child: ElevatedButton(
                      onPressed: () => _submitTask(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                      ),
                      child: Text(
                        widget.task == null ? 'Add Task' : 'Update Task',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Submit task and show SnackBar
  void _submitTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        dueDate: _dueDate,
        priority: _priority,
      );
      final provider = Provider.of<TaskProvider>(context, listen: false);
      final isAdding = widget.task == null;

      if (isAdding) {
        provider.addTask(task);
      } else {
        provider.updateTask(widget.task?.id, task);
      }

      // Navigate back and show SnackBar on TaskListScreen
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2A2A2A),
          content: Text(
            isAdding ? 'Task added' : 'Task updated',
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}