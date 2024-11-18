import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/data/services/task_storage_service.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository = TaskRepository();
  final TaskStorageService _taskStorageService = TaskStorageService();
  StreamSubscription<dynamic>? _timerSubscription;
  String? _activeTaskId;
  Stopwatch? _activeStopwatch;

  TaskBloc() : super(TaskInitial()) {
    on<MoveTask>((event, emit) async {
      log('MoveTask event triggered');
      log('Target status: ${event.newStatus}');
      log('Target index: ${event.newIndex}');

      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        log('Current state is TaskLoaded');
        log('Current todo count: ${currentState.todo.length}');
        log('Current inProgress count: ${currentState.inProgress.length}');
        log('Current completed count: ${currentState.completed.length}');

        // Only pause timer if we're moving the task that's currently being timed
        final isMovingTimedTask = _activeTaskId == event.taskId;

        // Find the task in all lists
        Task? taskToMove;
        List<Task> newTodo = List.from(currentState.todo);
        List<Task> newInProgress = List.from(currentState.inProgress);
        List<Task> newCompleted = List.from(currentState.completed);

        // Find and remove task from current list
        if (newTodo.any((t) => t.id == event.taskId)) {
          taskToMove = newTodo.firstWhere((t) => t.id == event.taskId);
          newTodo.removeWhere((t) => t.id == event.taskId);
          log('Task found and removed from todo list');
        } else if (newInProgress.any((t) => t.id == event.taskId)) {
          taskToMove = newInProgress.firstWhere((t) => t.id == event.taskId);
          newInProgress.removeWhere((t) => t.id == event.taskId);
          log('Task found and removed from inProgress list');
        } else if (newCompleted.any((t) => t.id == event.taskId)) {
          taskToMove = newCompleted.firstWhere((t) => t.id == event.taskId);
          newCompleted.removeWhere((t) => t.id == event.taskId);
          log('Task found and removed from completed list');
        }

        if (taskToMove != null) {
          log('Original task: ${taskToMove.toString()}');

          // If we're moving the active task, pause its timer first
          if (isMovingTimedTask) {
            await pauseTimer();
          }

          // Normalize the status
          final normalizedStatus = event.newStatus.toLowerCase().trim();
          log('Normalized status: $normalizedStatus');

          // Update task labels based on new status
          List<String> newLabels;
          switch (normalizedStatus) {
            case 'todo':
            case 'to-do':
            case 'to do':
              newLabels = ['to-do'];
              break;
            case 'in progress':
            case 'in-progress':
              newLabels = ['in-progress'];
              break;
            case 'completed':
            case 'done':
              newLabels = ['done'];
              break;
            default:
              log('Warning: Unknown status, defaulting to to-do');
              newLabels = ['to-do'];
          }

          final updatedTask = taskToMove.copyWith(labels: newLabels);
          log('Updated task with new labels: ${updatedTask.toString()}');

          // Add to new list based on normalized status
          switch (normalizedStatus) {
            case 'todo':
            case 'to-do':
            case 'to do':
              newTodo.insert(
                  event.newIndex.clamp(0, newTodo.length), updatedTask);
              log('Task added to todo list at index ${event.newIndex}');
              break;
            case 'in progress':
            case 'in-progress':
              newInProgress.insert(
                  event.newIndex.clamp(0, newInProgress.length), updatedTask);
              log('Task added to inProgress list at index ${event.newIndex}');
              break;
            case 'completed':
            case 'done':
              newCompleted.insert(
                  event.newIndex.clamp(0, newCompleted.length), updatedTask);
              log('Task added to completed list at index ${event.newIndex}');
              break;
          }

          log('New todo count: ${newTodo.length}');
          log('New inProgress count: ${newInProgress.length}');
          log('New completed count: ${newCompleted.length}');

          // Emit new state
          emit(TaskLoaded(
            todo: newTodo,
            inProgress: newInProgress,
            completed: newCompleted,
            activeTimerTaskId:
                isMovingTimedTask ? null : currentState.activeTimerTaskId,
            taskDurations: currentState.taskDurations,
          ));
          log('New state emitted');

          // Update in repository
          try {
            log('Updating task in repository');
            await _repository.updateTask(updatedTask);
            log('Repository update successful');
          } catch (e) {
            log('Repository update failed: $e');
            add(LoadProjectTasks(updatedTask.projectId!));
          }
        } else {
          log('Task not found with ID: ${event.taskId}');
        }
      } else {
        log('State is not TaskLoaded');
      }
    });

    on<InitializeTimerState>((event, emit) async {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final activeTaskId = _taskStorageService.getRunningTaskId();

        if (activeTaskId != null && activeTaskId.isNotEmpty) {
          final savedDuration =
              _taskStorageService.getTaskDuration(activeTaskId);
          final taskDurations =
              Map<String, int>.from(currentState.taskDurations);
          taskDurations[activeTaskId] = savedDuration;

          emit(TaskLoaded(
            todo: currentState.todo,
            inProgress: currentState.inProgress,
            completed: currentState.completed,
            activeTimerTaskId: activeTaskId,
            taskDurations: taskDurations,
          ));

          // Resume timer if it was running
          _startActiveTimer(activeTaskId);
        }
      }
    });

    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        // Fetch tasks by projectId
        final tasks = await _repository.getAllTasks();
        // Lists to hold tasks based on their labels
        List<Task> toDoTasks = [];
        List<Task> inProgressTasks = [];
        List<Task> doneTasks = [];

        // Separate tasks based on their labels
        for (var task in tasks) {
          if (task.labels!.contains('to-do') || task.labels!.isEmpty) {
            toDoTasks.add(task);
          } else if (task.labels!.contains('in-progress')) {
            inProgressTasks.add(task);
          } else if (task.labels!.contains('done')) {
            doneTasks.add(task);
          }
        }

        final activeTaskId = _taskStorageService.getRunningTaskId();
        final taskDurations = <String, int>{};

        // Load saved durations for all tasks
        for (final task in [...toDoTasks, ...inProgressTasks, ...doneTasks]) {
          if (task.id != null) {
            final duration = _taskStorageService.getTaskDuration(task.id!);
            if (duration > 0) {
              taskDurations[task.id!] = duration;
            }
          }
        }

        emit(TaskLoaded(
          todo: toDoTasks,
          inProgress: inProgressTasks,
          completed: doneTasks,
          activeTimerTaskId: activeTaskId,
          taskDurations: taskDurations,
        ));

        // Resume timer if it was running
        if (activeTaskId != null && activeTaskId.isNotEmpty) {
          _startActiveTimer(activeTaskId);
        }
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<LoadProjectTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await _repository.getTasksByProject(event.projectId);
        final activeTaskId = _taskStorageService.getRunningTaskId();
        final taskDurations = <String, int>{};

        // Load saved durations for all tasks immediately
        for (final task in tasks) {
          if (task.id != null) {
            final duration = _taskStorageService.getTaskDuration(task.id!);
            if (duration > 0) {
              taskDurations[task.id!] = duration;
            }
          }
        }

        // Check if the active task belongs to this project
        final isActiveTaskInProject =
            tasks.any((task) => task.id == activeTaskId);
        final effectiveActiveTaskId =
            isActiveTaskInProject ? activeTaskId : null;

        // If active task is not in this project, clear the active timer state
        if (activeTaskId != null && !isActiveTaskInProject) {
          await _taskStorageService.saveTimerState('');
        }

        emit(TaskLoaded(
          todo: tasks
              .where((task) => task.labels?.contains('to-do') ?? false)
              .toList(),
          inProgress: tasks
              .where((task) => task.labels?.contains('in-progress') ?? false)
              .toList(),
          completed: tasks
              .where((task) => task.labels?.contains('done') ?? false)
              .toList(),
          activeTimerTaskId: effectiveActiveTaskId,
          taskDurations: taskDurations,
        ));

        // Resume timer only if the active task belongs to this project
        if (effectiveActiveTaskId != null) {
          _startActiveTimer(effectiveActiveTaskId);
        }
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        await _repository.createTask(event.task, event.projectId);
        add(LoadProjectTasks(event.projectId));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await _repository.deleteTask(event.taskId);
        add(LoadProjectTasks(event.projectId));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<UpdateTask>((event, emit) async {
      try {
        await _repository.updateTask(event.task);
        add(LoadProjectTasks(event.projectId));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<StartTimer>((event, emit) async {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;

        // Stop any existing timer
        await _stopActiveTimer();

        // Get saved duration
        final savedDuration = _taskStorageService.getTaskDuration(event.taskId);
        final taskDurations = Map<String, int>.from(currentState.taskDurations);
        taskDurations[event.taskId] = savedDuration;

        // Save active timer task ID
        await _taskStorageService.saveTimerState(event.taskId);
        _activeTaskId = event.taskId;

        // Start new timer
        _startActiveTimer(event.taskId);

        emit(TaskLoaded(
          todo: currentState.todo,
          inProgress: currentState.inProgress,
          completed: currentState.completed,
          activeTimerTaskId: event.taskId,
          taskDurations: taskDurations,
        ));
      }
    });

    on<StopTimer>((event, emit) async {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;

        // Save current duration before stopping
        if (_activeTaskId != null) {
          final currentDuration =
              currentState.taskDurations[_activeTaskId] ?? 0;
          await _taskStorageService.saveTaskDuration(
              _activeTaskId!, currentDuration);
        }

        await _stopActiveTimer();
        await _taskStorageService.saveTimerState('');

        emit(TaskLoaded(
          todo: currentState.todo,
          inProgress: currentState.inProgress,
          completed: currentState.completed,
          activeTimerTaskId: null,
          taskDurations: currentState.taskDurations,
        ));
      }
    });

    on<ResumeTimer>((event, emit) async {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final savedDuration = _taskStorageService.getTaskDuration(event.taskId);

        final taskDurations = Map<String, int>.from(currentState.taskDurations);
        taskDurations[event.taskId] = savedDuration;

        emit(TaskLoaded(
          todo: currentState.todo,
          inProgress: currentState.inProgress,
          completed: currentState.completed,
          activeTimerTaskId: currentState.activeTimerTaskId,
          taskDurations: taskDurations,
        ));

        _startActiveTimer(event.taskId);
      }
    });

    on<UpdateTimerDuration>((event, emit) {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final taskDurations = Map<String, int>.from(currentState.taskDurations);
        taskDurations[event.taskId] = event.duration;

        emit(TaskLoaded(
          todo: event.todo,
          inProgress: event.inProgress,
          completed: event.completed,
          activeTimerTaskId: currentState.activeTimerTaskId,
          taskDurations: taskDurations,
        ));
      }
    });

    on<CloseTask>((event, emit) async {
      try {
        if (state is TaskLoaded) {
          final currentState = state as TaskLoaded;
          final task = currentState.completed
              .firstWhere((task) => task.id == event.taskId);

          // Get the accumulated time for this task
          final timeSpent = currentState.taskDurations[event.taskId] ?? 0;

          // Create updated task with completion data
          final completedTask = task.copyWith(
            timeSpent: timeSpent,
            completedAt: DateTime.now(),
            isCompleted: true,
          );

          // Save to local storage
          await _taskStorageService.addCompletedTask(completedTask);

          // Clear the timer data for this task
          await _taskStorageService.clearTaskTimer(event.taskId);

          // Update the task in the API
          await _repository.closeTask(event.taskId);

          // Reload the task list
          add(LoadProjectTasks(event.projectId));
        }
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<PauseTimer>((event, emit) async {
      if (state is TaskLoaded && _activeTaskId != null) {
        final currentState = state as TaskLoaded;
        final currentDuration = currentState.taskDurations[_activeTaskId] ?? 0;

        // Save the current duration
        await _taskStorageService.saveTaskDuration(
            _activeTaskId!, currentDuration);

        // Stop the timer but keep the task ID in storage
        await _timerSubscription?.cancel();
        _timerSubscription = null;
        _activeStopwatch?.stop();
        _activeStopwatch = null;
        _activeTaskId = null;

        // Update the state to reflect paused timer
        emit(TaskLoaded(
          todo: currentState.todo,
          inProgress: currentState.inProgress,
          completed: currentState.completed,
          activeTimerTaskId: null,
          taskDurations: currentState.taskDurations,
        ));
      }
    });
  }

  void _startActiveTimer(String taskId) {
    final savedDuration = _taskStorageService.getTaskDuration(taskId);
    _activeTaskId = taskId;

    _activeStopwatch = Stopwatch();
    _activeStopwatch!.start();

    var lastEmittedDuration = savedDuration;

    _timerSubscription =
        Stream.periodic(const Duration(seconds: 1)).listen((_) {
      if (_activeTaskId == taskId && !isClosed) {
        final newDuration = savedDuration + _activeStopwatch!.elapsed.inSeconds;

        if (newDuration > lastEmittedDuration) {
          lastEmittedDuration = newDuration;

          if (state is TaskLoaded) {
            final currentState = state as TaskLoaded;
            _taskStorageService.saveTaskDuration(taskId, newDuration);

            add(UpdateTimerDuration(
              taskId: taskId,
              duration: newDuration,
              todo: currentState.todo,
              inProgress: currentState.inProgress,
              completed: currentState.completed,
            ));
          }
        }
      }
    });
  }

  Future<void> _stopActiveTimer() async {
    await _timerSubscription?.cancel();
    _timerSubscription = null;
    _activeStopwatch?.stop();
    _activeStopwatch = null;
    _activeTaskId = null;
    await _taskStorageService.saveTimerState('');
  }

  @override
  Future<void> close() async {
    // Save timer state before closing
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      if (_activeTaskId != null) {
        final currentDuration = currentState.taskDurations[_activeTaskId] ?? 0;
        await _taskStorageService.saveTaskDuration(
            _activeTaskId!, currentDuration);
        await _stopActiveTimer();
      }
    }
    return super.close();
  }

  Future<void> pauseTimer() async {
    add(PauseTimer());
  }
}
