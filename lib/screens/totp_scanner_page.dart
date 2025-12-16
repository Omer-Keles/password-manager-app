import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/totp_account.dart';
import '../utils/totp_parser.dart';

class TotpScannerPage extends StatefulWidget {
  const TotpScannerPage({super.key});

  @override
  State<TotpScannerPage> createState() => _TotpScannerPageState();
}

class _TotpScannerPageState extends State<TotpScannerPage> {
  bool _isProcessing = false;
  String? _error;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final l10n = AppLocalizations.of(context)!;
    final barcode = capture.barcodes.firstWhere(
      (b) => (b.rawValue ?? '').isNotEmpty,
      orElse: () => Barcode(rawValue: ''),
    );
    final rawValue = barcode.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    final account = parseOtpAuthUri(rawValue);
    if (account == null) {
      setState(() {
        _error = l10n.invalidQRCode;
      });
      return;
    }

    setState(() => _isProcessing = true);
    Navigator.of(context).pop<TotpAccount>(account);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanQR),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: MobileScanner(fit: BoxFit.cover, onDetect: _onDetect),
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                style: TextStyle(color: Colors.red.shade400),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Text(
              l10n.scanQRInstructions,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
