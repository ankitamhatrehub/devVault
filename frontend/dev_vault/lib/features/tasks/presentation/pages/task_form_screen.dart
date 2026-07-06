import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'tasks_screen.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task, required this.onSave});

  final TaskItem? task;
  final ValueChanged<TaskItem> onSave;

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
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDateController =
        TextEditingController(text: widget.task?.dueDate ?? '');
    _priority = widget.task?.priority ?? 'Medium';
    _status = widget.task?.status ?? 'In Progress';
    _category = widget.task?.category ?? 'Learning';
    _progress = widget.task?.progress ?? 0.5;
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final task = TaskItem(
      id: widget.task?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      progress: _progress,
      dueDate: _dueDateController.text.trim(),
      status: _status,
      category: _category,
      createdAt: widget.task?.createdAt ?? 'Just now',
    );
    widget.onSave(task);
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
            content:
                const Text('Your edits will be lost if you leave this screen.'),
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
          title: Text(
            widget.task == null ? 'Create task' : 'Edit task',
          ),
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
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Task title is required.'
                                  : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _descriptionController,
                          labelText: 'Description',
                          maxLength: 200,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          onChanged: (_) => setState(() => _isDirty = true),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Add a description.'
                                  : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _priority,
                          items: const [
                            DropdownMenuItem(
                              value: 'Low',
                              child: Text('Low'),
                            ),
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
