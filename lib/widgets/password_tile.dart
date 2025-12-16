import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/password_entry.dart';

class PasswordTile extends StatelessWidget {
  const PasswordTile({
    super.key,
    required this.entry,
    required this.isRevealed,
    required this.subtitle,
    required this.onRevealToggle,
    required this.onEdit,
    required this.onDelete,
    this.onCopy,
  });

  final PasswordEntry entry;
  final bool isRevealed;
  final String subtitle;
  final VoidCallback onRevealToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onCopy;

  String get _maskedPassword {
    if (entry.password.isEmpty) return '••••';
    // Sabit uzunlukta maskeleme yaparak güvenlik sağlıyoruz.
    // Şifrenin gerçek uzunluğunun tahmin edilmesini engeller.
    return '•' * 8;
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Sosyal Medya':
        return Icons.public;
      case 'Banka / Finans':
        return Icons.account_balance_wallet;
      case 'E-Ticaret':
        return Icons.shopping_cart;
      case 'İş / Kurumsal':
        return Icons.work;
      case 'E-Posta':
        return Icons.email;
      case 'Oyun':
        return Icons.videogame_asset;
      case 'Kart / Kimlik':
        return Icons.credit_card;
      case 'Genel':
      case 'Diğer':
      default:
        return Icons.vpn_key;
    }
  }

  String _getCategoryDisplay(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'Genel':
        return l10n.categoryGeneral;
      case 'Sosyal Medya':
        return l10n.categorySocial;
      case 'Banka / Finans':
        return l10n.categoryBanking;
      case 'E-Ticaret':
        return l10n.categoryEcommerce;
      case 'İş / Kurumsal':
        return l10n.categoryWork;
      case 'E-Posta':
        return l10n.categoryEmail;
      case 'Oyun':
        return l10n.categoryGaming;
      case 'Kart / Kimlik':
        return l10n.categoryCard;
      case 'Diğer':
        return l10n.categoryOther;
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    _getIconForCategory(entry.category),
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _getCategoryDisplay(context, entry.category),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isRevealed ? l10n.hide : l10n.show,
                  onPressed: onRevealToggle,
                  icon: Icon(
                    isRevealed ? Icons.visibility_off : Icons.visibility,
                    color: colors.primary,
                  ),
                ),
                IconButton(
                  tooltip: l10n.edit,
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red.shade400,
                ),
              ],
            ),
            if (entry.username.isNotEmpty) ...[
              const SizedBox(height: 12),
              _InfoRow(label: l10n.user, value: entry.username),
            ],
            const SizedBox(height: 8),
            _InfoRow(
              label: l10n.passwordPin,
              value: isRevealed ? entry.password : _maskedPassword,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (onCopy != null)
                  TextButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: Text(l10n.copy),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
