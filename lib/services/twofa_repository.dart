import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/totp_account.dart';

class TwoFactorRepository {
  TwoFactorRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _totpKey = 'totp_accounts';

  Future<List<TotpAccount>> loadAccounts() async {
    final raw = await _storage.read(key: _totpKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) =>
              TotpAccount.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> saveAccounts(List<TotpAccount> accounts) async {
    final payload = jsonEncode(
      accounts.map((account) => account.toJson()).toList(),
    );
    await _storage.write(key: _totpKey, value: payload);
  }
}
