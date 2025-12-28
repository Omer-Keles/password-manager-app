import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../l10n/app_localizations.dart';

import '../services/pin_service.dart';
import '../services/session_key_manager.dart';
import '../widgets/pin_input.dart';
import 'home_shell.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.currentThemeMode,
    required this.currentLocale,
  });

  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;
  final ThemeMode currentThemeMode;
  final Locale currentLocale;

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final PinService _pinService = PinService();
  final LocalAuthentication _auth = LocalAuthentication();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = true;
  bool _hasPin = false;
  bool _unlocked = false;
  bool _canCheckBiometrics = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final hasPin = await _pinService.hasPin();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics =
          (await _auth.isDeviceSupported()) && (await _auth.canCheckBiometrics);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _hasPin = hasPin;
      _canCheckBiometrics = canCheckBiometrics;
      _isLoading = false;
    });

    if (hasPin && canCheckBiometrics) {
      _authenticateBiometric();
    }
  }

  Future<void> _authenticateBiometric() async {
    bool authenticated = false;
    try {
      final l10n = AppLocalizations.of(context);
      authenticated = await _auth.authenticate(
        localizedReason: l10n?.biometricReason ?? 'Use biometric to unlock',
      );
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) return;
    if (authenticated) {
      // Biyometrik başarılı - master key'i de yüklememiz gerekiyor
      // Ancak PIN'i bilmiyoruz, bu nedenle biyometrik sadece UI kilidini açar
      // Veri erişimi için yine de master key gerekecek (ilk PIN girişinde set edilir)
      setState(() {
        _unlocked = true;
        _error = null;
      });
    }
  }

  Future<void> _handleUnlock() async {
    final l10n = AppLocalizations.of(context)!;
    final pin = _pinController.text;
    if (pin.length != 4) {
      setState(() => _error = l10n.pin4Digits);
      return;
    }
    final success = await _pinService.verifyPin(pin);
    if (!mounted) return;
    if (success) {
      // PIN doğru - master key'i türet ve session'a kaydet
      try {
        final masterKey = await _pinService.deriveMasterKey(pin);
        SessionKeyManager.instance.setMasterKey(masterKey);

        setState(() {
          _unlocked = true;
          _error = null;
        });
        _pinController.clear();
      } catch (e) {
        setState(() => _error = 'Master key türetilemedi: $e');
      }
    } else {
      setState(() => _error = l10n.pinIncorrect);
    }
  }

  Future<void> _handleCreatePin() async {
    final l10n = AppLocalizations.of(context)!;
    final pin = _pinController.text;
    final confirm = _confirmController.text;
    if (pin.length != 4) {
      setState(() => _error = l10n.pin4Digits);
      return;
    }
    if (pin != confirm) {
      setState(() => _error = l10n.pinMismatch);
      return;
    }
    await _pinService.savePin(pin);

    // İlk PIN oluşturulduğunda master key'i de türet ve session'a kaydet
    try {
      final masterKey = await _pinService.deriveMasterKey(pin);
      SessionKeyManager.instance.setMasterKey(masterKey);
    } catch (e) {
      setState(() => _error = 'Master key türetilemedi: $e');
      return;
    }

    if (!mounted) return;
    setState(() {
      _hasPin = true;
      _error = null;
    });
    _pinController.clear();
    _confirmController.clear();
  }

  void _lock() {
    // Master key'i temizle (güvenlik)
    SessionKeyManager.instance.clear();

    setState(() {
      _unlocked = false;
      _pinController.clear();
      _isLoading = true;
    });
    _loadState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_unlocked) {
      return HomeShell(
        pinService: _pinService,
        onLockRequested: _lock,
        onThemeChanged: widget.onThemeChanged,
        onLocaleChanged: widget.onLocaleChanged,
        currentThemeMode: widget.currentThemeMode,
        currentLocale: widget.currentLocale,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48, // 24 padding * 2
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        _hasPin ? l10n.unlockVault : l10n.createPin,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _hasPin ? l10n.pinUnlockHint : l10n.pinCreateHint,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      PinInput(
                        controller: _pinController,
                        label: l10n.pinLabel,
                        onSubmitted: _hasPin ? _handleUnlock : null,
                      ),
                      if (!_hasPin) ...[
                        const SizedBox(height: 16),
                        PinInput(
                          controller: _confirmController,
                          label: l10n.pinConfirm,
                          onSubmitted: _handleCreatePin,
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: TextStyle(color: Colors.red.shade400),
                        ),
                      ],

                      if (_hasPin && _canCheckBiometrics) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton.icon(
                            onPressed: _authenticateBiometric,
                            icon: const Icon(Icons.fingerprint),
                            label: Text(l10n.biometricLogin),
                          ),
                        ),
                      ],

                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _hasPin ? _handleUnlock : _handleCreatePin,
                          icon: Icon(_hasPin ? Icons.lock_open : Icons.lock),
                          label: Text(_hasPin ? l10n.unlock : l10n.savePin),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
