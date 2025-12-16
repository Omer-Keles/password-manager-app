import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/secure_note.dart';
import '../services/notes_repository.dart';
import '../widgets/add_note_sheet.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesRepository _repository = NotesRepository();
  final TextEditingController _searchController = TextEditingController();
  List<SecureNote> _notes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final notes = await _repository.loadNotes();
    if (!mounted) return;
    setState(() {
      _notes = notes..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _isLoading = false;
    });
  }

  // Public method to reload data (used after import)
  Future<void> reloadData() async {
    await _loadNotes();
  }

  Future<void> _saveNotes() async {
    await _repository.saveNotes(_notes);
  }

  Future<void> _createOrUpdate({SecureNote? note}) async {
    final result = await showModalBottomSheet<SecureNote>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddNoteSheet(initialNote: note),
    );

    if (result != null) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _notes = [result, ..._notes.where((n) => n.id != result.id)]
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      });
      await _saveNotes();
      _showSnackBar(
        note == null
            ? l10n.noteSaved(result.title)
            : l10n.noteUpdated(result.title),
      );
    }
  }

  Future<void> _deleteNote(SecureNote note) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _notes.removeWhere((n) => n.id == note.id);
    });
    await _saveNotes();
    _showSnackBar(l10n.noteDeleted(note.title));
  }

  Future<bool> _confirmDelete(SecureNote note) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteNoteConfirmMessage(note.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    return confirm ?? false;
  }

  Future<void> _requestDelete(SecureNote note) async {
    final confirmed = await _confirmDelete(note);
    if (!confirmed) return;
    await _deleteNote(note);
  }

  Future<void> _showNoteDetails(SecureNote note) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.category,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              SelectableText(
                note.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '${l10n.updatedAt}: ${_formatDateTime(note.updatedAt)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: note.content));
              _showSnackBar(l10n.contentCopied);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.copy),
            label: Text(l10n.copy),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade400 : null,
        ),
      );
  }

  String _formatDateTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    final l10n = AppLocalizations.of(context)!;

    if (diff.inDays >= 1) return l10n.daysAgo(diff.inDays);
    if (diff.inHours >= 1) return l10n.hoursAgo(diff.inHours);
    if (diff.inMinutes >= 1) return l10n.minutesAgo(diff.inMinutes);
    return l10n.justNow;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notes = _notes
        .where((note) => note.matchesQuery(_searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.note_outlined, size: 24),
            const SizedBox(width: 12),
            Text(l10n.secureNotes),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_notes.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                enabled: !_isLoading,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: l10n.searchNotesHint,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notes.isEmpty
                  ? Center(
                      child: EmptyState(
                        icon: Icons.note_outlined,
                        title: l10n.noNotesYet,
                        subtitle: l10n.emptyNotesMessage,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Dismissible(
                            key: ValueKey(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (_) => _confirmDelete(note),
                            onDismissed: (_) => _deleteNote(note),
                            child: NoteCard(
                              note: note,
                              onTap: () => _showNoteDetails(note),
                              onEdit: () => _createOrUpdate(note: note),
                              onDelete: () => _requestDelete(note),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
