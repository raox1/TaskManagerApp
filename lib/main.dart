import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  // Create and initialize TaskProvider
  final taskProvider = TaskProvider();
  await taskProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: taskProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        // Set brightness to dark for a dark theme
        brightness: Brightness.dark,
        // Primary color for accents (e.g., focused borders, FAB)
        primaryColor: const Color(0xFF8B5CF6), // Vibrant purple
        // Background color for scaffolds
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Deep dark grey
        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          centerTitle: true,
        ),
        // Text theme for general text
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
          titleLarge: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Input decoration theme for TextFormFields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A), // Dark grey for input fields
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFF8B5CF6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Dropdown menu theme
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.white),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFF2A2A2A)),
          ),
        ),
        // Card theme
        cardTheme: CardTheme(
          color: const Color(0xFF2A2A2A),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        // Icon theme
        iconTheme: const IconThemeData(color: Color(0xFF8B5CF6)),
      ),
      home: const TaskListScreen(),
    );
  }
}