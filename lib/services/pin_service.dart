import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  PinService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final _random = Random.secure();

  static const _pinHashKey = 'pin_hash';
  static const _pinSaltKey = 'pin_salt';

  Future<bool> hasPin() async {
    final hash = await _storage.read(key: _pinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> savePin(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await _storage.write(key: _pinSaltKey, value: base64Encode(salt));
    await _storage.write(key: _pinHashKey, value: hash);
  }

  Future<bool> verifyPin(String pin) async {
    final saltStr = await _storage.read(key: _pinSaltKey);
    final storedHash = await _storage.read(key: _pinHashKey);
    if (saltStr == null || storedHash == null) {
      return false;
    }
    final salt = base64Decode(saltStr);
    final hash = _hashPin(pin, salt);
    return constantTimeEquality(hash, storedHash);
  }

  Future<void> clear() async {
    await _storage.delete(key: _pinSaltKey);
    await _storage.delete(key: _pinHashKey);
  }

  List<int> _generateSalt() {
    return List<int>.generate(16, (_) => _random.nextInt(256));
  }

  String _hashPin(String pin, List<int> salt) {
    final digest = sha256.convert([...salt, ...utf8.encode(pin)]);
    return digest.toString();
  }

  bool constantTimeEquality(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
