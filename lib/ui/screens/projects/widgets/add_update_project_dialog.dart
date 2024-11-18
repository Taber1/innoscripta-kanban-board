import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/project/project_event.dart';
import 'package:innoscripta_test_kanban/data/models/project_model.dart';
import './project_color_picker.dart';

class AddUpdateProjectDialog extends StatefulWidget {
  final Project? project;

  const AddUpdateProjectDialog({super.key, this.project});

  @override
  State<AddUpdateProjectDialog> createState() => _AddUpdateProjectDialogState();
}

class _AddUpdateProjectDialogState extends State<AddUpdateProjectDialog> {
  late final TextEditingController _nameController;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name);
    _selectedColor = widget.project?.color ?? 'berry_red';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.project == null ? 'Add Project' : 'Edit Project',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  hintText: 'Enter project name',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Color',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ProjectColorPicker(
                selectedColor: _selectedColor,
                onColorSelected: (color) {
                  setState(() => _selectedColor = color);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saveProject,
                    child: Text(widget.project == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProject() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (widget.project == null) {
      context.read<ProjectBloc>().add(
            AddProject(Project(
              name: name,
              color: _selectedColor,
            )),
          );
    } else {
      context.read<ProjectBloc>().add(
            UpdateProject(Project(
              id: widget.project!.id!,
              name: name,
              color: _selectedColor,
            )),
          );
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
