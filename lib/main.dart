import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Basit Root Kontrolü (Sadece Release modda ve test değilse)
  if (kReleaseMode && !Platform.environment.containsKey('FLUTTER_TEST')) {
    bool isUnsafe = false;
    if (Platform.isAndroid) {
      isUnsafe = _checkAndroidRoot();
    }
    // iOS kontrolü için native channel gerekir, şimdilik basit Android kontrolü yeterli.

    if (isUnsafe) {
      runApp(const _UnsafeDeviceApp());
      return;
    }
  }

  runApp(const PasswordKeeperApp());
}

bool _checkAndroidRoot() {
  final paths = [
    '/system/app/Superuser.apk',
    '/sbin/su',
    '/system/bin/su',
    '/system/xbin/su',
    '/data/local/xbin/su',
    '/data/local/bin/su',
    '/system/sd/xbin/su',
    '/system/bin/failsafe/su',
    '/data/local/su',
    '/su/bin/su',
  ];

  for (final path in paths) {
    if (File(path).existsSync()) {
      return true;
    }
  }

  // Test-Keys kontrolü (Custom ROM belirtisi)
  try {
    final buildTags = Process.runSync('getprop', [
      'ro.build.tags',
    ]).stdout.toString();
    if (buildTags.contains('test-keys')) return true;
  } catch (_) {}

  return false;
}

class _UnsafeDeviceApp extends StatelessWidget {
  const _UnsafeDeviceApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Güvenlik Uyarısı',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cihazınızda Root veya güvensiz yapılandırma tespit edildi. Güvenliğiniz için uygulama bu cihazda çalıştırılamaz.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => exit(0),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red.shade900,
                ),
                child: const Text('Kapat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
