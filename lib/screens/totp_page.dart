import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:otp/otp.dart';

import '../models/totp_account.dart';
import '../services/twofa_repository.dart';
import '../widgets/add_totp_sheet.dart';
import '../widgets/totp_card.dart';
import 'totp_scanner_page.dart';

class TotpPage extends StatefulWidget {
  const TotpPage({
    super.key,
    required this.onPinReset,
    required this.onLockRequested,
  });

  final Future<void> Function() onPinReset;
  final VoidCallback onLockRequested;

  @override
  State<TotpPage> createState() => _TotpPageState();
}

class _TotpPageState extends State<TotpPage> {
  final TwoFactorRepository _repository = TwoFactorRepository();
  List<TotpAccount> _accounts = [];
  bool _isLoading = true;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    final data = await _repository.loadAccounts();
    if (!mounted) return;
    setState(() {
      _accounts = data;
      _isLoading = false;
    });
  }

  // Public method to reload data (used after import)
  Future<void> reloadData() async {
    await _loadAccounts();
  }

  Future<void> _saveAccounts() async {
    await _repository.saveAccounts(_accounts);
  }

  Future<void> _createOrEdit({TotpAccount? account}) async {
    final result = await showModalBottomSheet<TotpAccount>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTotpSheet(initialAccount: account),
    );

    if (result != null) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _accounts = [
          result,
          ..._accounts.where((item) => item.id != result.id),
        ];
      });
      await _saveAccounts();
      _showMessage(
        account == null
            ? l10n.twoFactorAdded(result.label)
            : l10n.twoFactorUpdated(result.label),
      );
    }
  }

  Future<void> _delete(TotpAccount account) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRecord),
        content: Text(l10n.confirmDelete2FA(account.label)),
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
    if (confirm != true) return;
    final l10n2 = AppLocalizations.of(context)!;
    setState(() {
      _accounts.removeWhere((item) => item.id == account.id);
    });
    await _saveAccounts();
    _showMessage(l10n2.twoFactorDeleted(account.label));
  }

  Future<void> _copyCode(TotpAccount account) async {
    final l10n = AppLocalizations.of(context)!;
    final code = _generateCode(account);
    await Clipboard.setData(ClipboardData(text: code));
    _showMessage(l10n.codeCopied);
  }

  Future<void> _openScanner() async {
    final account = await Navigator.of(context).push<TotpAccount>(
      MaterialPageRoute(builder: (_) => const TotpScannerPage()),
    );
    if (account == null) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _accounts = [
        account,
        ..._accounts.where((item) => item.id != account.id),
      ];
    });
    await _saveAccounts();
    _showMessage(l10n.twoFactorAdded(account.label));
  }

  void _showMessage(String message, {bool isError = false}) {
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

  String _generateCode(TotpAccount account) {
    try {
      return OTP.generateTOTPCodeString(
        account.secret,
        DateTime.now().millisecondsSinceEpoch,
        interval: account.period,
        length: account.digits,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
    } catch (_) {
      return '------';
    }
  }

  double _progress(TotpAccount account) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = account.period - (now % account.period);
    return remaining / account.period;
  }

  Future<void> _showAddOptions() async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showModalBottomSheet<_AddTotpAction>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 48,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.manualAdd),
              onTap: () => Navigator.of(context).pop(_AddTotpAction.manual),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: Text(l10n.scanQR),
              onTap: () => Navigator.of(context).pop(_AddTotpAction.qr),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    switch (action) {
      case _AddTotpAction.manual:
        await _createOrEdit();
        break;
      case _AddTotpAction.qr:
        await _openScanner();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.qr_code_2, size: 24),
            const SizedBox(width: 12),
            Text(l10n.twoFactor),
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
                '${_accounts.length}',
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _accounts.isEmpty
            ? _EmptyTotpState(onAddPressed: () => _createOrEdit())
            : RefreshIndicator(
                onRefresh: _loadAccounts,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: _accounts.length,
                  itemBuilder: (context, index) {
                    final account = _accounts[index];
                    final code = _generateCode(account);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TotpCard(
                        account: account,
                        code: code,
                        progress: _progress(account),
                        onCopy: () => _copyCode(account),
                        onEdit: () => _createOrEdit(account: account),
                        onDelete: () => _delete(account),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyTotpState extends StatelessWidget {
  const _EmptyTotpState({required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_2, size: 64, color: colors.primary),
            const SizedBox(height: 16),
            Text(
              l10n.noTwoFactorYet,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyTwoFactorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
              label: Text(l10n.addFirstAccount),
            ),
          ],
        ),
      ),
    );
  }
}

enum _AddTotpAction { manual, qr }
