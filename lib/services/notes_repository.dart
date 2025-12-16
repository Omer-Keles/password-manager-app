import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/secure_note.dart';

class NotesRepository {
  static const _storageKey = 'secure_notes_v1';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<SecureNote>> loadNotes() async {
    try {
      final raw = await _storage.read(key: _storageKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((json) => SecureNote.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveNotes(List<SecureNote> notes) async {
    final encoded = jsonEncode(notes.map((n) => n.toJson()).toList());
    await _storage.write(key: _storageKey, value: encoded);
  }
}
