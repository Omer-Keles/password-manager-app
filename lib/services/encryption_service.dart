import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';

/// Veri şifreleme/çözme servisi (AES-GCM-256)
/// Repository'lerde kullanılacak
class EncryptionService {
  EncryptionService();

  final Cipher _cipher = AesGcm.with256bits();
  final Random _random = Random.secure();

  /// Verilen master key ile JSON verisini şifreler
  /// Returns: Base64 encoded {nonce, ciphertext, mac}
  Future<String> encrypt(String jsonData, SecretKey masterKey) async {
    final plainText = utf8.encode(jsonData);
    final nonce = _randomBytes(12);

    final secretBox = await _cipher.encrypt(
      plainText,
      secretKey: masterKey,
      nonce: nonce,
    );

    // Paketleme: nonce + ciphertext + mac
    final map = {
      'nonce': base64Encode(nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    return base64Encode(utf8.encode(jsonEncode(map)));
  }

  /// Verilen master key ile şifreli veriyi çözer
  /// Returns: JSON string
  Future<String> decrypt(String encryptedData, SecretKey masterKey) async {
    try {
      // Base64 → JSON parse
      final jsonString = utf8.decode(base64Decode(encryptedData.trim()));
      final map = jsonDecode(jsonString) as Map<String, dynamic>;

      // Bileşenleri ayır
      final nonce = base64Decode(map['nonce'] as String);
      final cipherText = base64Decode(map['ciphertext'] as String);
      final macBytes = base64Decode(map['mac'] as String);

      // Şifre çöz
      final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));
      final clearBytes = await _cipher.decrypt(secretBox, secretKey: masterKey);

      return utf8.decode(clearBytes);
    } on SecretBoxAuthenticationError {
      throw EncryptionException('Veri bütünlüğü hatası: MAC doğrulanamadı');
    } catch (e) {
      throw EncryptionException('Şifre çözme hatası: $e');
    }
  }

  List<int> _randomBytes(int length) {
    return List<int>.generate(length, (i) => _random.nextInt(256));
  }
}

class EncryptionException implements Exception {
  EncryptionException(this.message);
  final String message;
  @override
  String toString() => message;
}
