import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';
import 'note_detail_screen.dart';
import 'note_form_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late List<NoteItem> _notes;

  @override
  void initState() {
    super.initState();
    _notes = [
      const NoteItem(
        id: 'n1',
        title: 'Interview reflection',
        body:
            'Focus on communication and calm pacing. Bring a short story that proves impact.',
        category: 'Career',
        updatedAt: 'Updated 2h ago',
        pinned: true,
      ),
      const NoteItem(
        id: 'n2',
        title: 'Flutter performance checklist',
        body:
            'Avoid unnecessary rebuilds, keep widgets focused, and split large pages into smaller units.',
        category: 'Learning',
        updatedAt: 'Updated yesterday',
        pinned: false,
      ),
      const NoteItem(
        id: 'n3',
        title: 'Roadmap ideas',
        body:
            'Create monthly review rituals and keep them lightweight so they remain sustainable.',
        category: 'Planning',
        updatedAt: 'Updated 3 days ago',
        pinned: false,
      ),
    ];
    unawaited(_loadNotes());
  }

  Future<void> _loadNotes() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _refreshNotes() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _addNote(NoteItem note) {
    setState(() {
      _notes.insert(0, note);
      _isLoading = false;
    });
  }

  void _updateNote(NoteItem updatedNote) {
    setState(() {
      final index = _notes.indexWhere((item) => item.id == updatedNote.id);
      if (index >= 0) {
        _notes[index] = updatedNote;
      }
    });
  }

  void _deleteNote(String id) {
    final removed = _notes.firstWhere((item) => item.id == id);
    setState(() => _notes.removeWhere((item) => item.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted successfully'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () => setState(() => _notes.insert(0, removed)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _notes.where((note) {
      final query = _searchQuery.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
          note.body.toLowerCase().contains(query) ||
          note.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _openNoteForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New note'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notes', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Capture ideas, reminders, and lessons from your day.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _searchController,
                hintText: 'Search notes',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _isLoading
                    ? const NoteSkeletonList()
                    : RefreshIndicator(
                        onRefresh: _refreshNotes,
                        child: filteredNotes.isEmpty
                            ? const EmptyNotesState()
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: filteredNotes.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, index) {
                                  final note = filteredNotes[index];
                                  return NoteTile(
                                    title: note.title,
                                    body: note.body,
                                    category: note.category,
                                    updatedAt: note.updatedAt,
                                    pinned: note.pinned,
                                    onTap: () =>
                                        _openNoteDetail(context, note),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openNoteDetail(BuildContext context, NoteItem note) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => NoteDetailScreen(
          note: note,
          onEdit: (updatedNote) async {
            final result = await Navigator.of(context).push<NoteItem?>(
              MaterialPageRoute<NoteItem?>(
                builder: (context) => NoteFormScreen(
                  note: updatedNote,
                  onSave: (savedNote) {
                    _updateNote(savedNote);
                    Navigator.of(context).pop(savedNote);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Note \'${savedNote.title}\' updated successfully!',
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ),
            );
            if (result != null) {
              _updateNote(result);
            }
          },
          onDelete: (id) {
            _deleteNote(id);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openNoteForm(BuildContext context, {NoteItem? note}) async {
    await Navigator.of(context).push<NoteItem?>(
      MaterialPageRoute<NoteItem?>(
        builder: (context) => NoteFormScreen(
          note: note,
          onSave: (savedNote) {
            final isCreate = note == null;
            if (isCreate) {
              _addNote(savedNote);
            } else {
              _updateNote(savedNote);
            }
            Navigator.of(context).pop(savedNote);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isCreate
                      ? 'Note \'${savedNote.title}\' created successfully!'
                      : 'Note \'${savedNote.title}\' updated successfully!',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          },
        ),
      ),
    );
  }
}

class NoteItem {
  const NoteItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.updatedAt,
    required this.pinned,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final String updatedAt;
  final bool pinned;
}
