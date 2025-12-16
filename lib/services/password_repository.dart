import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/password_entry.dart';

class PasswordRepository {
  PasswordRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _passwordKey = 'password_entries';

  Future<List<PasswordEntry>> loadEntries() async {
    final raw = await _storage.read(key: _passwordKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) =>
              PasswordEntry.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> saveEntries(List<PasswordEntry> entries) async {
    final payload = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    await _storage.write(key: _passwordKey, value: payload);
  }

  Future<void> clear() => _storage.delete(key: _passwordKey);
}
