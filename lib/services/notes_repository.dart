import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/secure_note.dart';
import 'encryption_service.dart';
import 'session_key_manager.dart';

class NotesRepository {
  NotesRepository({
    FlutterSecureStorage? storage,
    EncryptionService? encryptionService,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _encryption = encryptionService ?? EncryptionService();

  static const _storageKey = 'secure_notes_v1';
  final FlutterSecureStorage _storage;
  final EncryptionService _encryption;

  Future<List<SecureNote>> loadNotes() async {
    try {
      final raw = await _storage.read(key: _storageKey);
      if (raw == null || raw.isEmpty) return [];

      // Master key kontrolü
      final masterKey = SessionKeyManager.instance.masterKey;
      if (masterKey == null) {
        throw Exception('Master key yok - önce PIN doğrulayın');
      }

      // Şifreli veriyi çöz
      final jsonData = await _encryption.decrypt(raw, masterKey);
      final List<dynamic> decoded = jsonDecode(jsonData);
      return decoded.map((json) => SecureNote.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveNotes(List<SecureNote> notes) async {
    // Master key kontrolü
    final masterKey = SessionKeyManager.instance.masterKey;
    if (masterKey == null) {
      throw Exception('Master key yok - önce PIN doğrulayın');
    }

    final jsonData = jsonEncode(notes.map((n) => n.toJson()).toList());
    // Şifrele
    final encrypted = await _encryption.encrypt(jsonData, masterKey);
    await _storage.write(key: _storageKey, value: encrypted);
  }
}
