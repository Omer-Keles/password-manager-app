import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/totp_account.dart';
import 'encryption_service.dart';
import 'session_key_manager.dart';

class TwoFactorRepository {
  TwoFactorRepository({
    FlutterSecureStorage? storage,
    EncryptionService? encryptionService,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _encryption = encryptionService ?? EncryptionService();

  final FlutterSecureStorage _storage;
  final EncryptionService _encryption;
  static const _totpKey = 'totp_accounts';

  Future<List<TotpAccount>> loadAccounts() async {
    final raw = await _storage.read(key: _totpKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    // Master key kontrolü
    final masterKey = SessionKeyManager.instance.masterKey;
    if (masterKey == null) {
      throw Exception('Master key yok - önce PIN doğrulayın');
    }

    try {
      // Şifreli veriyi çöz
      final jsonData = await _encryption.decrypt(raw, masterKey);
      final decoded = jsonDecode(jsonData) as List<dynamic>;
      return decoded
          .map(
            (item) =>
                TotpAccount.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (e) {
      throw Exception('2FA hesapları yüklenemedi: $e');
    }
  }

  Future<void> saveAccounts(List<TotpAccount> accounts) async {
    // Master key kontrolü
    final masterKey = SessionKeyManager.instance.masterKey;
    if (masterKey == null) {
      throw Exception('Master key yok - önce PIN doğrulayın');
    }

    try {
      final jsonData = jsonEncode(
        accounts.map((account) => account.toJson()).toList(),
      );
      // Şifrele
      final encrypted = await _encryption.encrypt(jsonData, masterKey);
      await _storage.write(key: _totpKey, value: encrypted);
    } catch (e) {
      throw Exception('2FA hesapları kaydedilemedi: $e');
    }
  }
}
