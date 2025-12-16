import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/secure_note.dart';

class AddNoteSheet extends StatefulWidget {
  const AddNoteSheet({super.key, this.initialNote});

  final SecureNote? initialNote;

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool get _isEditing => widget.initialNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.initialNote?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final note =
        (widget.initialNote ??
                SecureNote(
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                  category: 'Personal',
                ))
            .copyWith(
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
            );
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 48,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text(
                    _isEditing ? l10n.updateNote : l10n.newNote,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.noteTitle,
                      hintText: l10n.noteTitleHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.validationNoteTitleRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 6,
                    minLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.noteContent,
                      hintText: l10n.noteContentHint,
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.validationNoteContentRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isEditing ? l10n.update : l10n.save),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
