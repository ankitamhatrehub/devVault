import 'package:dev_vault/data/models/projects_model.dart';
import 'package:dev_vault/data/services/projects_service.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key, this.project, });

  final ProjectsModel? project;


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
    _nameController = TextEditingController(text: widget.project?.projectName ?? '');
    _summaryController = TextEditingController(
      text: widget.project?.summary ?? '',
    );
    _deadlineController = TextEditingController(
      text: widget.project?.deadline ?? '',
    );
    _notesController = TextEditingController(text: widget.project?.projectNotes ?? '');
    _status = widget.project?.status ?? 'In review';
    _stack = widget.project?.primaryStack.split(' • ').first ?? 'Flutter';
    _team = widget.project?.teamSize ?? '3 members';
    _progress = (widget.project?.progress ?? 50) / 100;
    _selectedTags.addAll(widget.project?.focusTags ?? <String>[]);
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
Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.project == null) {
        await ProjectsService.createProject(
          projectName: _nameController.text.trim(),
          summary: _summaryController.text.trim(),
          primaryStack: _stack,
          status: _status,
          deadline: _deadlineController.text.trim(),
          teamSize: _team,
          projectNotes: _notesController.text.trim(),
          focusTags: _selectedTags,
          progress: (_progress * 100).round(),
        );
      } else {
        await ProjectsService.updateProject(
          id: widget.project!.id,
          projectName: _nameController.text.trim(),
          summary: _summaryController.text.trim(),
          primaryStack: _stack,
          status: _status,
          deadline: _deadlineController.text.trim(),
          teamSize: _team,
          projectNotes: _notesController.text.trim(),
          focusTags: _selectedTags,
          progress: (_progress * 100).round(),
        );
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
