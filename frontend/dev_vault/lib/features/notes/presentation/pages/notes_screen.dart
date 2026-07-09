import 'dart:async';

import 'package:dev_vault/data/models/notes_model.dart';
import 'package:dev_vault/data/services/notes_service.dart';
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
  late List<NotesModel> notes = [];

  @override
  void initState() {
    super.initState();

    unawaited(_loadNotes());
  }

  Future<void> _loadNotes() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final notesData = await NotesService.getAllNotes();

      if (!mounted) return;

      setState(() {
        notes = notesData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _refreshNotes() async {
    await _loadNotes();
  }

  Future<void> _deleteNote(String id) async {
    try {
      await NotesService.deleteNote(id);

      await _loadNotes();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note deleted successfully"),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';

    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = notes.where((note) {
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
                                    updatedAt: formatDate(note.updatedAt),
                                    pinned: note.pinned,
                                    onTap: () => _openNoteDetail(context, note),
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

  Future<void> _openNoteDetail(BuildContext context, NotesModel note) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => NoteDetailScreen(
          note: note,
          onEdit: (note) async {
            await _openNoteForm(context, note: note);
          },
          onDelete: (id) async {
            await _deleteNote(id);

            if (!mounted) return;

            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _openNoteForm(BuildContext context, {NotesModel? note}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NoteFormScreen(note: note)),
    );

    if (result == true) {
      await _loadNotes();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            note == null
                ? "Note created successfully"
                : "Note updated successfully",
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
