import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../services/backup_service.dart';
import '../services/notes_repository.dart';
import '../services/password_repository.dart';
import '../services/twofa_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.onPinReset,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.currentThemeMode,
    required this.currentLocale,
    required this.onDataImported,
  });

  final Future<void> Function() onPinReset;
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;
  final ThemeMode currentThemeMode;
  final Locale currentLocale;
  final Future<void> Function() onDataImported;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PasswordRepository _passwordRepository = PasswordRepository();
  final NotesRepository _notesRepository = NotesRepository();
  final TwoFactorRepository _twoFactorRepository = TwoFactorRepository();
  final BackupService _backupService = BackupService();
  bool _isProcessing = false;

  Future<void> _handleExport() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      // Tüm verileri yükle
      final passwords = await _passwordRepository.loadEntries();
      final notes = await _notesRepository.loadNotes();
      final totpAccounts = await _twoFactorRepository.loadAccounts();

      // En az bir veri kontrolü
      if (passwords.isEmpty && notes.isEmpty && totpAccounts.isEmpty) {
        _showSnackBar(l10n.noRecordsToBackup);
        return;
      }

      // Backup paketini oluştur
      final backupData = BackupData(
        passwords: passwords,
        notes: notes,
        totpAccounts: totpAccounts,
        timestamp: DateTime.now(),
      );

      // Kullanıcıdan şifre al
      final password = await _askPassword(
        title: l10n.encryptBackup,
        confirm: true,
      );
      if (password == null) return;

      // Şifrele
      final payload = await _backupService.encryptData(backupData, password);
      final fileName = _suggestedBackupName();
      final total = passwords.length + notes.length + totpAccounts.length;

      if (Platform.isAndroid || Platform.isIOS) {
        // Mobil: Geçici dosya oluştur ve paylaş
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsString(payload, flush: true);

        await Share.shareXFiles(
          [XFile(tempFile.path)],
          subject: 'Password Vault Backup',
          text: '$total ${l10n.recordsBackedUp}',
        );

        _showSnackBar('$total ${l10n.recordsBackedUp}');
      } else {
        // Desktop: FilePicker ile kaydet
        final bytes = Uint8List.fromList(utf8.encode(payload));
        final savePath = await FilePicker.platform.saveFile(
          dialogTitle: l10n.exportData,
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: const ['vault'],
          bytes: bytes,
        );

        if (savePath == null) return;

        final file = File(savePath);
        await file.writeAsString(payload, flush: true);

        _showSnackBar(
          '${l10n.backupSaved(savePath)}\n$total ${l10n.recordsBackedUp}',
        );
      }
    } on PlatformException catch (error) {
      _showSnackBar(
        error.message ?? 'File system access denied',
        isError: true,
      );
    } catch (e) {
      _showSnackBar('Export error: $e', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleImport() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isProcessing) return;

    // Onay dialog'u
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importData),
        content: Text(l10n.importWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.continueAction),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);

    try {
      // Dosya seç
      final picked = await FilePicker.platform.pickFiles(
        dialogTitle: l10n.importData,
        type: FileType.any,
      );

      if (picked == null || picked.files.isEmpty) return;
      final path = picked.files.single.path;
      if (path == null) {
        _showSnackBar('File path unavailable', isError: true);
        return;
      }

      // Şifre al
      final password = await _askPassword(
        title: l10n.decryptBackup,
        confirm: false,
      );
      if (password == null) return;

      // Dosyayı oku ve şifreyi çöz
      final payload = await File(path).readAsString();
      final backupData = await _backupService.decryptData(payload, password);

      // Tüm verileri kaydet
      await _passwordRepository.saveEntries(backupData.passwords);
      await _notesRepository.saveNotes(backupData.notes);
      await _twoFactorRepository.saveAccounts(backupData.totpAccounts);

      // Diğer sayfaları yenile (veriler repository'den yüklenecek)
      await widget.onDataImported();

      // Başarı mesajı
      final total =
          backupData.passwords.length +
          backupData.notes.length +
          backupData.totpAccounts.length;
      _showSnackBar('${l10n.backupRestored}\n$total ${l10n.recordsImported}');
    } on BackupException catch (e) {
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      _showSnackBar('Import error: $e', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<String?> _askPassword({
    required String title,
    bool confirm = false,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  confirm ? l10n.backupPasswordHint : l10n.decryptPasswordHint,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  obscureText: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.backupPassword,
                    prefixIcon: const Icon(Icons.key),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return l10n.validationPasswordMin6;
                    }
                    return null;
                  },
                ),
                if (confirm) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.confirmPassword,
                      prefixIcon: const Icon(Icons.check_circle_outline),
                    ),
                    validator: (value) {
                      if (value != controller.text) {
                        return l10n.validationPasswordsMismatch;
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: Text(confirm ? l10n.encryptAndSave : l10n.decrypt),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePinReset() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetPin),
        content: Text(l10n.resetPinConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.onPinReset();
    }
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

  String _suggestedBackupName() {
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    return 'password-vault-$timestamp.vault';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader(l10n.appearance),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.theme),
            trailing: DropdownButton<ThemeMode>(
              value: widget.currentThemeMode,
              underline: const SizedBox(),
              dropdownColor: Theme.of(context).cardColor,
              onChanged: (mode) {
                if (mode != null) widget.onThemeChanged(mode);
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.themeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.themeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.themeDark),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: DropdownButton<Locale>(
              value: widget.currentLocale,
              underline: const SizedBox(),
              dropdownColor: Theme.of(context).cardColor,
              onChanged: (locale) {
                if (locale != null) widget.onLocaleChanged(locale);
              },
              items: const [
                DropdownMenuItem(value: Locale('tr'), child: Text('Türkçe')),
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
              ],
            ),
          ),
          const Divider(height: 32),
          _buildSectionHeader(l10n.dataManagement),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(l10n.exportData),
            subtitle: Text(l10n.exportDataSubtitle),
            trailing: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: _isProcessing ? null : _handleExport,
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(l10n.importData),
            subtitle: Text(l10n.importDataSubtitle),
            trailing: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: _isProcessing ? null : _handleImport,
          ),
          const Divider(height: 32),
          _buildSectionHeader(l10n.security),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: Text(l10n.resetPin),
            subtitle: Text(l10n.resetPinSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: _handlePinReset,
          ),
          const Divider(height: 32),
          _buildSectionHeader(l10n.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.appVersion),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
