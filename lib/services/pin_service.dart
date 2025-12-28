import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  PinService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final _random = Random.secure();

  static const _pinHashKey = 'pin_hash';
  static const _pinSaltKey = 'pin_salt';
  static const _masterKeySaltKey = 'master_key_salt';

  Future<bool> hasPin() async {
    final hash = await _storage.read(key: _pinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> savePin(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await _storage.write(key: _pinSaltKey, value: base64Encode(salt));
    await _storage.write(key: _pinHashKey, value: hash);

    // Master key için de salt oluştur (ilk PIN kaydında)
    final masterKeySalt = _generateSalt();
    await _storage.write(
      key: _masterKeySaltKey,
      value: base64Encode(masterKeySalt),
    );
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
    await _storage.delete(key: _masterKeySaltKey);
  }

  List<int> _generateSalt() {
    return List<int>.generate(16, (_) => _random.nextInt(256));
  }

  String _hashPin(String pin, List<int> salt) {
    final digest = crypto.sha256.convert([...salt, ...utf8.encode(pin)]);
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

  /// PIN'den master key türet (PBKDF2 ile)
  /// Bu key veri şifreleme/çözme için kullanılır
  Future<SecretKey> deriveMasterKey(String pin) async {
    // Master key salt'ını oku
    final saltStr = await _storage.read(key: _masterKeySaltKey);
    if (saltStr == null) {
      throw Exception('Master key salt bulunamadı');
    }
    final salt = base64Decode(saltStr);

    // PBKDF2 ile key türet
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000, // Backup ile aynı
      bits: 256,
    );

    return pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
  }
}
