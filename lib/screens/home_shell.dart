import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/pin_service.dart';
import 'notes_page.dart';
import 'password_home_page.dart';
import 'settings_page.dart';
import 'totp_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.pinService,
    required this.onLockRequested,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.currentThemeMode,
    required this.currentLocale,
  });

  final PinService pinService;
  final VoidCallback onLockRequested;
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;
  final ThemeMode currentThemeMode;
  final Locale currentLocale;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  bool _pinResetInProgress = false;
  final GlobalKey<State> _passwordPageKey = GlobalKey();
  final GlobalKey<State> _notesPageKey = GlobalKey();
  final GlobalKey<State> _totpPageKey = GlobalKey();

  Future<void> _refreshAllPages() async {
    // Tüm sayfaların verilerini yeniden yükle
    final passwordState = _passwordPageKey.currentState as dynamic;
    final notesState = _notesPageKey.currentState as dynamic;
    final totpState = _totpPageKey.currentState as dynamic;

    final futures = <Future>[];
    if (passwordState != null) futures.add(passwordState.reloadData());
    if (notesState != null) futures.add(notesState.reloadData());
    if (totpState != null) futures.add(totpState.reloadData());

    await Future.wait(futures);
  }

  Future<void> _resetPin() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pinResetInProgress) return;
    setState(() => _pinResetInProgress = true);
    await widget.pinService.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.pinResetMessage)));
    widget.onLockRequested();
    setState(() => _pinResetInProgress = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      PasswordHomePage(
        key: _passwordPageKey,
        onLockRequested: widget.onLockRequested,
        onPinReset: _resetPin,
      ),
      NotesPage(key: _notesPageKey),
      TotpPage(
        key: _totpPageKey,
        onLockRequested: widget.onLockRequested,
        onPinReset: _resetPin,
      ),
      SettingsPage(
        onPinReset: _resetPin,
        onThemeChanged: widget.onThemeChanged,
        onLocaleChanged: widget.onLocaleChanged,
        currentThemeMode: widget.currentThemeMode,
        currentLocale: widget.currentLocale,
        onDataImported: _refreshAllPages,
      ),
    ];

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: colors.surface,
        indicatorColor: colors.primary.withOpacity(0.15),
        elevation: 3,
        shadowColor: Colors.black26,
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.vpn_key_outlined),
            selectedIcon: Icon(Icons.vpn_key, color: colors.primary),
            label: l10n.passwords,
          ),
          NavigationDestination(
            icon: const Icon(Icons.note_outlined),
            selectedIcon: Icon(Icons.note, color: colors.primary),
            label: l10n.notes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_outlined),
            selectedIcon: Icon(Icons.qr_code, color: colors.primary),
            label: l10n.twoFactor,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: colors.primary),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
