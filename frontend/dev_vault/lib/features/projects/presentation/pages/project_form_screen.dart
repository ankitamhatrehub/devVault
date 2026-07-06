import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'project_detail_screen.dart';

class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key, this.project, required this.onSave});

  final ProjectItem? project;
  final ValueChanged<ProjectItem> onSave;

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _summaryController;
  late final TextEditingController _deadlineController;
  late final TextEditingController _notesController;
  String _status = 'In review';
  String _stack = 'Flutter';
  String _team = '3 members';
  double _progress = 0.5;
  final List<String> _selectedTags = <String>[];
  final List<String> _availableTags = <String>[
    'Flutter',
    'Product',
    'Design',
    'Firebase',
    'Back-end',
    'Charts',
  ];

  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _summaryController = TextEditingController(
      text: widget.project?.summary ?? '',
    );
    _deadlineController = TextEditingController(
      text: widget.project?.deadline ?? '',
    );
    _notesController = TextEditingController(text: widget.project?.notes ?? '');
    _status = widget.project?.status ?? 'In review';
    _stack = widget.project?.stack.split(' • ').first ?? 'Flutter';
    _team = widget.project?.team ?? '3 members';
    _progress = widget.project?.progress ?? 0.5;
    _selectedTags.addAll(widget.project?.tags ?? <String>[]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    _deadlineController.dispose();
    _notesController.dispose();
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
        _deadlineController.text = selected.toIso8601String().split('T').first;
        _isDirty = true;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final project = ProjectItem(
      id: widget.project?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      summary: _summaryController.text.trim(),
      status: _status,
      progress: _progress,
      stack: _stack,
      deadline: _deadlineController.text.trim(),
      team: _team,
      tags: _selectedTags,
      updatedAt: 'Just now',
      notes: _notesController.text.trim(),
    );

    // ✅ Success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.project == null
              ? 'Project "${project.name}" created successfully!'
              : 'Project "${project.name}" updated successfully!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    widget.onSave(project);
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
          title: Text(
            widget.project == null ? 'Create project' : 'Edit project',
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
                          controller: _nameController,
                          labelText: 'Project name',
                          onChanged: (_) => setState(() => _isDirty = true),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Project name is required.'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _summaryController,
                          labelText: 'Summary',
                          maxLength: 140,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          onChanged: (_) => setState(() => _isDirty = true),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Add a short summary.'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _stack,
                          items: const [
                            DropdownMenuItem(
                              value: 'Flutter',
                              child: Text('Flutter'),
                            ),
                            DropdownMenuItem(
                              value: 'Node.js',
                              child: Text('Node.js'),
                            ),
                            DropdownMenuItem(
                              value: 'Design',
                              child: Text('Design'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _stack = value;
                                _isDirty = true;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Primary stack',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          items: const [
                            DropdownMenuItem(
                              value: 'Planning',
                              child: Text('Planning'),
                            ),
                            DropdownMenuItem(
                              value: 'In review',
                              child: Text('In review'),
                            ),
                            DropdownMenuItem(
                              value: 'Shipping soon',
                              child: Text('Shipping soon'),
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
                          controller: _deadlineController,
                          labelText: 'Deadline',
                          readOnly: true,
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _team,
                          items: const [
                            DropdownMenuItem(
                              value: '1 member',
                              child: Text('1 member'),
                            ),
                            DropdownMenuItem(
                              value: '2 members',
                              child: Text('2 members'),
                            ),
                            DropdownMenuItem(
                              value: '3 members',
                              child: Text('3 members'),
                            ),
                            DropdownMenuItem(
                              value: '4 members',
                              child: Text('4 members'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _team = value;
                                _isDirty = true;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Team size',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Focus tags',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          children: _availableTags.map((tag) {
                            final selected = _selectedTags.contains(tag);
                            return ChoiceChip(
                              label: Text(tag),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  if (selected) {
                                    _selectedTags.remove(tag);
                                  } else {
                                    _selectedTags.add(tag);
                                  }
                                  _isDirty = true;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _notesController,
                          labelText: 'Project notes',
                          maxLines: 4,
                          onChanged: (_) => setState(() => _isDirty = true),
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
                      label: const Text('Save project'),
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
