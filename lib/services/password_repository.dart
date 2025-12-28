import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/password_entry.dart';
import 'encryption_service.dart';
import 'session_key_manager.dart';

class PasswordRepository {
  PasswordRepository({
    FlutterSecureStorage? storage,
    EncryptionService? encryptionService,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _encryption = encryptionService ?? EncryptionService();

  final FlutterSecureStorage _storage;
  final EncryptionService _encryption;
  static const _passwordKey = 'password_entries';

  Future<List<PasswordEntry>> loadEntries() async {
    final raw = await _storage.read(key: _passwordKey);
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
                PasswordEntry.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (e) {
      throw Exception('Şifreler yüklenemedi: $e');
    }
  }

  Future<void> saveEntries(List<PasswordEntry> entries) async {
    // Master key kontrolü
    final masterKey = SessionKeyManager.instance.masterKey;
    if (masterKey == null) {
      throw Exception('Master key yok - önce PIN doğrulayın');
    }

    try {
      final jsonData = jsonEncode(
        entries.map((entry) => entry.toJson()).toList(),
      );
      // Şifrele
      final encrypted = await _encryption.encrypt(jsonData, masterKey);
      await _storage.write(key: _passwordKey, value: encrypted);
    } catch (e) {
      throw Exception('Şifreler kaydedilemedi: $e');
    }
  }

  Future<void> clear() => _storage.delete(key: _passwordKey);
}
