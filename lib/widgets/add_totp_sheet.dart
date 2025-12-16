import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/totp_account.dart';

class AddTotpSheet extends StatefulWidget {
  const AddTotpSheet({super.key, this.initialAccount});

  final TotpAccount? initialAccount;

  @override
  State<AddTotpSheet> createState() => _AddTotpSheetState();
}

class _AddTotpSheetState extends State<AddTotpSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _issuerController;
  late final TextEditingController _secretController;

  // Period ve digits varsayılan değerler (6 haneli, 30 saniye - Google Authenticator standardı)
  late final int _period;
  late final int _digits;

  bool get _isEditing => widget.initialAccount != null;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.initialAccount?.label ?? '',
    );
    _issuerController = TextEditingController(
      text: widget.initialAccount?.issuer ?? '',
    );
    _secretController = TextEditingController(
      text: widget.initialAccount?.secret ?? '',
    );
    // Varsayılan değerler veya mevcut hesaptan al
    _period = widget.initialAccount?.period ?? 30;
    _digits = widget.initialAccount?.digits ?? 6;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _issuerController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final secretKey = _secretController.text
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .toUpperCase();

    final account = TotpAccount(
      id: widget.initialAccount?.id, // Düzenleme modunda ID'yi koru
      label: _labelController.text.trim(),
      issuer: _issuerController.text.trim(),
      secret: secretKey,
      period: _period, // Sabit kalır
      digits: _digits, // Sabit kalır
    );
    Navigator.of(context).pop(account);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.only(bottom: padding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
                  _isEditing ? l10n.updateTwoFactor : l10n.newTwoFactor,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _labelController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.accountName,
                    hintText: l10n.accountNameHint,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.validationAccountNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _issuerController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.servicePlatformOptional,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _secretController,
                  textInputAction: TextInputAction.done,
                  // Düzenleme modunda secret key değiştirilemez - güvenlik için
                  enabled: !_isEditing,
                  decoration: InputDecoration(
                    labelText: l10n.secretKey,
                    hintText: _isEditing ? null : l10n.secretKeyHint,
                    // Düzenleme modunda görsel ipucu
                    suffixIcon: _isEditing
                        ? const Icon(Icons.lock_outline, size: 20)
                        : null,
                    helperText: _isEditing
                        ? 'Gizli anahtar değiştirilemez'
                        : null,
                    helperStyle: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.validationSecretKeyRequired;
                    }
                    final cleaned = value
                        .trim()
                        .replaceAll(' ', '')
                        .replaceAll('-', '');
                    if (cleaned.length < 8) {
                      return l10n.validationSecretKeyTooShort;
                    }
                    return null;
                  },
                ),
                // Düzenleme modunda: Sadece görüntüleme (değiştirilemez)
                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_digits} haneli • ${_period} saniye',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    );
  }
}
