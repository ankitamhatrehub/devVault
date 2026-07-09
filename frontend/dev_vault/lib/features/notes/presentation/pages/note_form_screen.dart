import 'package:dev_vault/data/models/notes_model.dart';
import 'package:dev_vault/data/services/notes_service.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';


class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key, this.note, });

  final NotesModel? note;


  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  bool _pinned = false;
  String _category = 'Learning';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
    _pinned = widget.note?.pinned ?? false;
    _category = widget.note?.category ?? 'Learning';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

 Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.note == null) {
        // CREATE
        await NotesService.createNote(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          category: _category,
          pinned: _pinned,
        );
      } else {
        // UPDATE
        await NotesService.updateNote(
          id: widget.note!.id,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          category: _category,
          pinned: _pinned,
        );
      }

      // widget.onSave();

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
          title: Text(widget.note == null ? 'Create note' : 'Edit note'),
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
                          controller: _bodyController,
                          labelText: 'Note content',
                          maxLines: 5,
                          maxLength: 280,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Add the note content.'
                                  : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: _category,
                          items: const [
                            DropdownMenuItem(
                              value: 'Career',
                              child: Text('Career'),
                            ),
                            DropdownMenuItem(
                              value: 'Learning',
                              child: Text('Learning'),
                            ),
                            DropdownMenuItem(
                              value: 'Planning',
                              child: Text('Planning'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _category = value;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SwitchListTile(
                          value: _pinned,
                          onChanged: (value) {
                            setState(() {
                              _pinned = value;
                            });
                          },
                          title: const Text('Pin this note'),
                          contentPadding: EdgeInsets.zero,
                        ),
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
                      label: const Text('Save note'),
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
