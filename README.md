# Task Manager App

A simple and elegant task management application built with Flutter, designed to help users organize their daily tasks efficiently. Create, edit, and delete tasks with ease, set priorities, and stay on top of your schedule—all wrapped in a sleek, modern dark theme.

Developed by **Lalit Kumar**.

---

## Features

- **Add Tasks**: Create new tasks with a title, optional description, due date, and priority (Low, Medium, High).
- **Edit Tasks**: Update existing tasks seamlessly.
- **Delete Tasks**: Remove tasks with an "Undo" option via a SnackBar.
- **Priority Visualization**: Tasks are color-coded based on priority (Red for High, Blue for Medium, Green for Low).
- **Dark Theme**: A modern dark UI with purple accents for a visually appealing experience.
- **Local Storage**: Tasks are persisted using Hive, a lightweight NoSQL database.
- **Feedback**: SnackBars provide confirmation for adding, updating, and deleting tasks.
- **Info Screen**: Learn about the app and its creator via an info button.

---

## Functional Video

Below is a short video demonstrating the app’s functionality:

![Task Manager Demo]()


https://github.com/user-attachments/assets/da6ff83d-d60a-4270-98d6-e5a41305514f



---

## Project Structure

### Database Structure

The app uses **Hive**, a lightweight, NoSQL key-value database for local storage on the device. Here’s how it’s structured:

- **Box**: A single Hive box named `tasks` stores all task data.
- **Data Model**: The `Task` class represents a task with the following fields:
    - `id` (String): A unique identifier generated using `Uuid` (if a server is not used).
    - `title` (String): The task’s title (required).
    - `description` (String?): An optional description.
    - `dueDate` (DateTime): The task’s due date.
    - `priority` (String): Priority level ("Low", "Medium", "High").
- **Storage**: Tasks are serialized/deserialized using a Hive adapter (`TaskAdapter`) and stored as key-value pairs in the `tasks` box, where the key is the `id` and the value is the `Task` object.

**Why Hive?**
- Lightweight and fast, ideal for mobile apps with simple data needs.
- No external server dependency, ensuring offline functionality.
- Easy integration with Flutter via `hive_flutter`.

### File Structure

```
task_manager_app/
├── android/                # Android-specific files
├── ios/                    # iOS-specific files
├── lib/
│   ├── models/
│   │   └── task.dart       # Task model and Hive adapter
│   ├── providers/
│   │   └── task_provider.dart  # TaskProvider for state management
│   ├── screens/
│   │   ├── task_list_screen.dart  # Main screen with task list
│   │   ├── task_form_screen.dart  # Form for adding/editing tasks
│   │   └── info_screen.dart       # Info/about screen
│   └── main.dart           # App entry point with theme and provider setup
├── assets/
│   ├── icons/
│   │   └── app_icon.png    # Custom app icon
│   └── videos/
│       └── task_manager_demo.mp4  # Demo video (to be added)
├── pubspec.yaml            # Dependencies and assets configuration
└── README.md               # This file
```

---

## Dependencies

Here are the dependencies used in `pubspec.yaml`, along with their purposes:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2          # State management for tasks
  hive: ^2.2.3              # Local NoSQL database for task storage
  hive_flutter: ^1.1.0      # Flutter integration for Hive
  intl: ^0.19.0             # Date formatting (e.g., due date display)

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1  # Generate app icons for Android/iOS
  hive_generator: ^2.0.0    # Generate Hive adapters
  build_runner: ^2.4.9      # Run code generation for Hive
```

---

## How to Run the App

### Prerequisites

- Flutter SDK (version 3.0.0 or higher recommended)
- Dart SDK (included with Flutter)
- An IDE (e.g., VS Code, Android Studio) with Flutter plugins
- An emulator or physical device

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/task_manager_app.git
   cd task_manager_app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters**:
   ```bash
   flutter pub run build_runner build
   ```

4. **Generate App Icons** (if you’ve updated `app_icon.png`):
   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. **Run the App**:
   ```bash
   flutter run
   ```

---

## Contributing

Feel free to fork this repository, submit pull requests, or open issues for bugs and feature requests.

---

## License

This project is licensed under the MIT License.
