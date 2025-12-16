import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'l10n/app_localizations.dart';
import 'screens/pin_lock_screen.dart';
import 'theme/app_theme.dart';

class PasswordKeeperApp extends StatefulWidget {
  const PasswordKeeperApp({super.key, this.enablePinLock = true});

  final bool enablePinLock;

  @override
  State<PasswordKeeperApp> createState() => _PasswordKeeperAppState();
}

class _PasswordKeeperAppState extends State<PasswordKeeperApp>
    with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('tr');
  bool _isLoading = true;

  // Background koruma için key - değiştiğinde PinLockScreen yeniden oluşturulur
  Key _pinScreenKey = UniqueKey();
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreferences();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Sadece paused: Uygulama tamamen arka plana alındığında
    // (inactive değil - o dialog/klavye için de tetiklenir)
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      // Uygulama ön plana geldi - kilitle
      _wasInBackground = false;
      setState(() {
        _pinScreenKey = UniqueKey();
      });
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final themeStr = await _storage.read(key: 'theme_mode');
      final localeStr = await _storage.read(key: 'locale');

      setState(() {
        if (themeStr != null) {
          _themeMode = ThemeMode.values.firstWhere(
            (e) => e.name == themeStr,
            orElse: () => ThemeMode.system,
          );
        }
        if (localeStr != null) {
          _locale = Locale(localeStr);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    await _storage.write(key: 'theme_mode', value: mode.name);
  }

  Future<void> _changeLocale(Locale locale) async {
    setState(() => _locale = locale);
    await _storage.write(key: 'locale', value: locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final textTheme = GoogleFonts.interTextTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Vault',
      theme: buildLightTheme(textTheme: textTheme),
      darkTheme: buildDarkTheme(textTheme: textTheme),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('tr', '')],
      home: PinLockScreen(
        key: _pinScreenKey,
        onThemeChanged: _changeTheme,
        onLocaleChanged: _changeLocale,
        currentThemeMode: _themeMode,
        currentLocale: _locale,
      ),
    );
  }
}
