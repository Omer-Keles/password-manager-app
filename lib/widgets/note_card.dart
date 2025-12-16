import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/secure_note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final SecureNote note;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Wi-Fi':
        return Icons.wifi;
      case 'Crypto':
        return Icons.currency_bitcoin;
      case 'Tax':
        return Icons.account_balance;
      case 'Documents':
        return Icons.description;
      case 'Personal':
      case 'Other':
      default:
        return Icons.note;
    }
  }

  String _getCategoryDisplay(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'Personal':
        return l10n.noteCategoryPersonal;
      case 'Wi-Fi':
        return l10n.noteCategoryWifi;
      case 'Crypto':
        return l10n.noteCategoryCrypto;
      case 'Tax':
        return l10n.noteCategoryTax;
      case 'Documents':
        return l10n.noteCategoryDocuments;
      case 'Other':
        return l10n.noteCategoryOther;
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final preview = note.content.length > 80
        ? '${note.content.substring(0, 80)}...'
        : note.content;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: isDark
            ? Border.all(color: const Color(0xFF2A2A2A), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.4)
                : Colors.black.withOpacity(.05),
            blurRadius: isDark ? 12 : 18,
            offset: Offset(0, isDark ? 4 : 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getIconForCategory(note.category),
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _getCategoryDisplay(context, note.category),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.edit,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.delete,
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                preview,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
