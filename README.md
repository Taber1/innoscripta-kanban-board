# Time Tracking App

## Overview
The Time Tracking App is a Flutter-based application that helps users manage projects and tasks efficiently. It features project management, task tracking, time management, and offline capabilities. The app also supports light and dark themes for better user experience.

## Features
- **Project Management**: Create, fetch, update, and delete projects.
- **Task Management**:
  - Add, fetch, update, delete tasks.
  - Move tasks between columns (To Do, In Progress, Completed).
- **Task Details**: View detailed task information, including comments.
- **Timer Functionality**: Play/pause timer to track time spent on tasks.
- **Comments**: Add, get, update, and delete task comments.
- **Completed Tasks**: View completed tasks by project and clear completed tasks.
- **Theme Switching**: Toggle between light and dark themes.

## Technologies Used
- **Flutter**: Cross-platform mobile development.
- **flutter_bloc**: State management.
- **go_router**: Routing.
- **dio**: API handling.
- **shared_preferences**: Offline data storage.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Taber1/innoscripta-kanban-board.git
   ```
2. Navigate to the project directory:
   ```bash
   cd innoscripta-kanban-board
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Folder Structure
```
project/lib
    blocs/
    core/theme/app_theme.dart
    data/
        models/
        providers/
        repositories/
        services/
            api_service.dart
            local_storage_service.dart
            task_storage_service.dart
    routes/app_router.dart
    ui/screens/
        main_screen/
            widgets/widget_main_screen.dart
            main_screen.dart
    utils/
main.dart
```

## Usage
- Create and manage projects.
- Track tasks with start/stop timer functionality.
- View detailed task information and comments.
- Change the app theme as needed.