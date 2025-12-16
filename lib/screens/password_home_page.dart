import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/password_entry.dart';
import '../services/password_repository.dart';
import '../widgets/add_password_sheet.dart';
import '../widgets/empty_state.dart';
import '../widgets/password_tile.dart';

class PasswordHomePage extends StatefulWidget {
  const PasswordHomePage({
    super.key,
    required this.onLockRequested,
    required this.onPinReset,
  });

  final VoidCallback onLockRequested;
  final Future<void> Function() onPinReset;

  @override
  State<PasswordHomePage> createState() => _PasswordHomePageState();
}

class _PasswordHomePageState extends State<PasswordHomePage> {
  final PasswordRepository _repository = PasswordRepository();
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _revealed = {};

  List<PasswordEntry> _entries = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final data = await _repository.loadEntries();
    if (!mounted) return;
    setState(() {
      _entries = data;
      _isLoading = false;
    });
  }

  // Public method to reload data (used after import)
  Future<void> reloadData() async {
    await _loadEntries();
  }

  Future<void> _saveEntries(List<PasswordEntry> entries) async {
    await _repository.saveEntries(entries);
  }

  void _toggleReveal(String id) {
    setState(() {
      if (_revealed.contains(id)) {
        _revealed.remove(id);
      } else {
        _revealed.add(id);
      }
    });
  }

  Future<void> _createOrUpdate({PasswordEntry? entry}) async {
    final result = await showModalBottomSheet<PasswordEntry>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPasswordSheet(initialEntry: entry),
    );

    if (result != null) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _entries = [result, ..._entries.where((e) => e.id != result.id)]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
      await _saveEntries(_entries);
      _showSnackBar(
        entry == null ? l10n.saved(result.label) : l10n.updated(result.label),
      );
    }
  }

  Future<void> _deleteEntry(PasswordEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _entries.removeWhere((e) => e.id == entry.id);
      _revealed.remove(entry.id);
    });
    await _saveEntries(_entries);
    _showSnackBar(l10n.deleted(entry.label));
  }

  Future<bool> _confirmDelete(PasswordEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage(entry.label)),
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

  Future<void> _requestDelete(PasswordEntry entry) async {
    final confirmed = await _confirmDelete(entry);
    if (!confirmed) return;
    await _deleteEntry(entry);
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  Future<void> _copyPassword(PasswordEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: entry.password));
    _showSnackBar(l10n.passwordCopied);
  }

  // Backup methods removed - now in Settings page

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

  String _formatRelativeDate(DateTime time) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays >= 1) return l10n.daysAgo(diff.inDays);
    if (diff.inHours >= 1) return l10n.hoursAgo(diff.inHours);
    if (diff.inMinutes >= 1) return l10n.minutesAgo(diff.inMinutes);
    return l10n.justNow;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = _entries
        .where((entry) => entry.matchesQuery(_searchQuery))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.vpn_key, size: 24),
            const SizedBox(width: 12),
            Text(l10n.passwords),
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
                '${_entries.length}',
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
                  hintText: l10n.searchHint,
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
                  : entries.isEmpty
                  ? const EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Dismissible(
                            key: ValueKey(entry.id),
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
                            confirmDismiss: (_) => _confirmDelete(entry),
                            onDismissed: (_) => _deleteEntry(entry),
                            child: PasswordTile(
                              entry: entry,
                              isRevealed: _revealed.contains(entry.id),
                              subtitle: _formatRelativeDate(entry.createdAt),
                              onRevealToggle: () => _toggleReveal(entry.id),
                              onEdit: () => _createOrUpdate(entry: entry),
                              onCopy: () => _copyPassword(entry),
                              onDelete: () => _requestDelete(entry),
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
        onPressed: _isLoading ? null : () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
