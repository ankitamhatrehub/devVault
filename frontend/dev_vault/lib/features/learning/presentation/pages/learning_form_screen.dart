
import 'package:dev_vault/data/models/learning_model.dart';

import 'package:dev_vault/data/services/learning_service.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

class LearningFormScreen extends StatefulWidget {
  const LearningFormScreen({super.key, this.learning});

  final LearningModel? learning;

  @override
  State<LearningFormScreen> createState() => _LearningFormScreenState();
}

class _LearningFormScreenState extends State<LearningFormScreen> {
  final _formKey = GlobalKey<FormState>();
late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startDateController;
  late final TextEditingController _targetDateController;

  String _category = 'Flutter';
  String _status = 'In Progress';
  String _priority = 'Medium';

  final List<TextEditingController> _stepControllers = [];

@override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.learning?.title ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.learning?.des ?? '',
    );

    _startDateController = TextEditingController(
      text: widget.learning?.startDate ?? '',
    );

    _targetDateController = TextEditingController(
      text: widget.learning?.targetDate ?? '',
    );

    _category = widget.learning?.category ?? 'Flutter';
    _status = widget.learning?.status ?? 'In Progress';
    _priority = widget.learning?.priority ?? 'Medium';

    if (widget.learning != null) {
      for (final step in widget.learning!.steps) {
        _stepControllers.add(TextEditingController(text: step.title));
      }
    }

    if (_stepControllers.isEmpty) {
      _stepControllers.add(TextEditingController());
    }
  }

@override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _targetDateController.dispose();

    for (final c in _stepControllers) {
      c.dispose();
    }

    super.dispose();
  }

Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final steps = _stepControllers
          .where((e) => e.text.trim().isNotEmpty)
          .map(
            (e) => LearningStepModel(title: e.text.trim(), isCompleted: false),
          )
          .toList();

      if (widget.learning == null) {
        await LearningService.createLearning(
          title: _titleController.text.trim(),
          des: _descriptionController.text.trim(),
          category: _category,
          status: _status,
          priority: _priority,
          startDate: _startDateController.text.trim(),
          targetDate: _targetDateController.text.trim(),
          steps: steps,
        );
      } else {
        await LearningService.updateLearning(
          id: widget.learning!.id,
          title: _titleController.text.trim(),
          des: _descriptionController.text.trim(),
          category: _category,
          status: _status,
          priority: _priority,
          startDate: _startDateController.text.trim(),
          targetDate: _targetDateController.text.trim(),
          steps: steps,
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
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.learning == null ? 'Create Learning' : 'Edit Learning'),
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
                          labelText: 'Title',
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Title is required.'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _descriptionController,
                          labelText: 'Description',
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                          initialValue: _category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
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
                              value: 'System Design',
                              child: Text('System Design'),
                            ),
                            DropdownMenuItem(
                              value: 'Docker',
                              child: Text('Docker'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _category = value);
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const SizedBox(height: AppSpacing.md),

                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Not Started',
                              child: Text('Not Started'),
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
                              setState(() => _status = value);
                            }
                          },
                        ),
                     const SizedBox(height: AppSpacing.md),

                        DropdownButtonFormField<String>(
                          initialValue: _priority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                          ),
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
                              setState(() => _priority = value);
                            }
                          },
                        ), ],
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
                      label: const Text('Save Learning'),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  controller: _startDateController,
                  labelText: 'Start Date',
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2035),
                      initialDate: DateTime.now(),
                    );

                    if (date != null) {
                      _startDateController.text = date
                          .toIso8601String()
                          .split('T')
                          .first;
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  controller: _targetDateController,
                  labelText: 'Target Date',
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2035),
                      initialDate: DateTime.now(),
                    );

                    if (date != null) {
                      _targetDateController.text = date
                          .toIso8601String()
                          .split('T')
                          .first;
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                Text(
                  'Learning Steps',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: AppSpacing.sm),

                ...List.generate(
                  _stepControllers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _stepControllers[index],
                            hintText: 'Step ${index + 1}',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _stepControllers.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),

                AppButton.icon(
                  onPressed: () {
                    setState(() {
                      _stepControllers.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Step"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
