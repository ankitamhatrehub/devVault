import 'package:dev_vault/data/models/tasks_model.dart';
import 'package:dev_vault/data/services/tasks_service.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_service.dart';
import '../../../../core/widgets/widgets.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task, required this.onSave});

  final TasksModel? task;
  final VoidCallback onSave;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dueDateController;
  String _priority = 'Medium';
  String _status = 'In Progress';
  String _category = 'Learning';
  double _progress = 0.5;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _dueDateController = TextEditingController(
      text: widget.task?.dueDate ?? '',
    );
    _priority = widget.task?.priority ?? 'Medium';
    _status = widget.task?.status ?? 'In Progress';
    _category = widget.task?.category ?? 'Learning';
    _progress = (widget.task?.progress ?? 50) / 100;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() {
        _dueDateController.text = selected.toIso8601String().split('T').first;
        _isDirty = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.task == null) {
        await TasksService.createTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          status: _status,
          dueDate: _dueDateController.text.trim(),
          category: _category,
          progress: (_progress * 100).round(),
        );
      } else {
        await TasksService.updateTask(
          id: widget.task!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          status: _status,
          dueDate: _dueDateController.text.trim(),
          category: _category,
          progress: (_progress * 100).round(),
        );
      }

      widget.onSave();

      if (!mounted) return;

      SnackBarService.showSuccess(
        context,
        message: widget.task == null
          ? 'Task created successfully'
          : 'Task updated successfully',
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      SnackBarService.showErrorFromException(context, error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || !_isDirty) return;
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text(
              'Your edits will be lost if you leave this screen.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Stay'),
              ),
              AppButton(
                variant: AppButtonVariant.tonal,
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        if (shouldLeave ?? false) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.task == null ? 'Create task' : 'Edit task'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: _titleController,
                          labelText: 'Task title',
                          onChanged: (_) => setState(() => _isDirty = true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Task title is required.';
                            }
                            if (value.trim().length < 3) {
                              return 'Title must be at least 3 characters.';
                            }
                            if (value.trim().length > 100) {
                              return 'Title must be less than 100 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _descriptionController,
                          labelText: 'Description',
                          maxLength: 200,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          onChanged: (_) => setState(() => _isDirty = true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Add a description.';
                            }
                            if (value.trim().length < 10) {
                              return 'Description must be at least 10 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _priority,
                          items: const [
                            DropdownMenuItem(value: 'Low', child: Text('Low')),
                            DropdownMenuItem(
                              value: 'Medium',
                              child: Text('Medium'),
                            ),
                            DropdownMenuItem(
                              value: 'High',
                              child: Text('High'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _priority = value;
                                _isDirty = true;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          items: const [
                            DropdownMenuItem(
                              value: 'Pending',
                              child: Text('Pending'),
                            ),
                            DropdownMenuItem(
                              value: 'In Progress',
                              child: Text('In Progress'),
                            ),
                            DropdownMenuItem(
                              value: 'Completed',
                              child: Text('Completed'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _status = value;
                                _isDirty = true;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Status',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _dueDateController,
                          labelText: 'Due date',
                          readOnly: true,
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _category,
                          items: const [
                            DropdownMenuItem(
                              value: 'Learning',
                              child: Text('Learning'),
                            ),
                            DropdownMenuItem(
                              value: 'Project',
                              child: Text('Project'),
                            ),
                            DropdownMenuItem(
                              value: 'Interview',
                              child: Text('Interview'),
                            ),
                            DropdownMenuItem(
                              value: 'Personal',
                              child: Text('Personal'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _category = value;
                                _isDirty = true;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Progress',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Slider(
                          value: _progress,
                          onChanged: (value) {
                            setState(() {
                              _progress = value;
                              _isDirty = true;
                            });
                          },
                          divisions: 10,
                          min: 0,
                          max: 1,
                        ),
                        Text('${(_progress * 100).round()}% complete'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton.icon(
                      fullWidth: true,
                      variant: AppButtonVariant.primary,
                      onPressed: _save,
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save task'),
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
}
