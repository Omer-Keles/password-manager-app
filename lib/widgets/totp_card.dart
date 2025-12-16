import 'dart:ui';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/totp_account.dart';

class TotpCard extends StatelessWidget {
  const TotpCard({
    super.key,
    required this.account,
    required this.code,
    required this.progress,
    required this.onCopy,
    required this.onEdit,
    required this.onDelete,
  });

  final TotpAccount account;
  final String code;
  final double progress;
  final VoidCallback onCopy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final digitsSplit = _splitCode(code);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withOpacity(.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, 12),
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
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(.2),
                  child: Text(
                    (account.issuer.isNotEmpty
                            ? account.issuer[0]
                            : account.label[0])
                        .toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (account.issuer.isNotEmpty)
                        Text(
                          account.issuer,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white.withOpacity(.85)),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: digitsSplit
                  .map(
                    (chunk) => Expanded(
                      child: Text(
                        chunk,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              letterSpacing: 4,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 6,
                      color: Colors.white,
                      backgroundColor: Colors.white.withOpacity(.25),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${account.period}s',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy, color: Colors.white),
                  label: Text(
                    l10n.copy,
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  tooltip: l10n.edit,
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _splitCode(String code) {
    if (code.length <= 3) return [code];
    final midpoint = (code.length / 2).ceil();
    return [code.substring(0, midpoint), code.substring(midpoint)];
  }
}
