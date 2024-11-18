import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../blocs/task/task_event.dart';
import '../../../../data/models/task_model.dart';
import '../../../../blocs/task/task_bloc.dart';
import 'package:go_router/go_router.dart';

class AddUpdateTaskScreen extends StatefulWidget {
  final String projectId;
  final Task? task;
  final String initialStatus;

  const AddUpdateTaskScreen({
    super.key,
    required this.projectId,
    required this.initialStatus,
    this.task,
  });

  @override
  State<AddUpdateTaskScreen> createState() => _AddUpdateTaskScreenState();
}

class _AddUpdateTaskScreenState extends State<AddUpdateTaskScreen> {
  late final TextEditingController _contentController;
  late final TextEditingController _descriptionController;
  DateTime? _dueDate;
  int _priority = 1;
  late final String _status;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.task?.content ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _dueDate = widget.task?.due != null
        ? DateTime.parse(widget.task!.due!.date)
        : null;
    _priority = widget.task?.priority ?? 1;
    _status = widget.task?.labels?.first ?? widget.initialStatus;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Update Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              value: _priority,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Low')),
                DropdownMenuItem(value: 2, child: Text('Medium')),
                DropdownMenuItem(value: 3, child: Text('High')),
              ],
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_dueDate == null
                  ? 'Select Due Date'
                  : 'Due Date: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final task = widget.task?.copyWith(
                        content: _contentController.text,
                        description: _descriptionController.text,
                        priority: _priority,
                        labels: [_status],
                        dueDate: _dueDate != null
                            ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                            : null) ??
                    Task(
                      content: _contentController.text,
                      description: _descriptionController.text,
                      projectId: widget.projectId,
                      priority: _priority,
                      labels: [_status],
                      dueDate: _dueDate != null
                          ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                          : null,
                    );

                if (widget.task == null) {
                  context.read<TaskBloc>().add(AddTask(
                        task: task,
                        projectId: widget.projectId,
                      ));
                } else {
                  context.read<TaskBloc>().add(UpdateTask(
                        task: task,
                        projectId: widget.projectId,
                      ));
                }

                context.pop(true);
              },
              child: Text(widget.task == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
