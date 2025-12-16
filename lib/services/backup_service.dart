import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';

import '../models/password_entry.dart';
import '../models/secure_note.dart';
import '../models/totp_account.dart';

class BackupException implements Exception {
  BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Tüm verileri içeren yedek paketi
class BackupData {
  BackupData({
    required this.passwords,
    required this.notes,
    required this.totpAccounts,
    required this.timestamp,
  });

  final List<PasswordEntry> passwords;
  final List<SecureNote> notes;
  final List<TotpAccount> totpAccounts;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'passwords': passwords.map((e) => e.toJson()).toList(),
    'notes': notes.map((e) => e.toJson()).toList(),
    'totp_accounts': totpAccounts.map((e) => e.toJson()).toList(),
    'timestamp': timestamp.toIso8601String(),
  };

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      passwords: (json['passwords'] as List? ?? [])
          .map(
            (e) => PasswordEntry.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      notes: (json['notes'] as List? ?? [])
          .map((e) => SecureNote.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      totpAccounts: (json['totp_accounts'] as List? ?? [])
          .map((e) => TotpAccount.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}

class BackupService {
  final Cipher _cipher = AesGcm.with256bits();
  final Random _random = Random.secure();

  /// Dışa aktarım: Tüm verileri şifreler ve String döner
  Future<String> encryptData(BackupData backupData, String password) async {
    if (password.length < 6) {
      throw BackupException('Parola en az 6 karakter olmalı.');
    }

    // 1. Veriyi hazırla
    final payload = jsonEncode(backupData.toJson());
    final plainText = utf8.encode(payload);

    // 2. Salt ve Nonce üret
    final salt = _randomBytes(16);
    final nonce = _randomBytes(12);

    // 3. Paroladan anahtar türet (PBKDF2)
    final secretKey = await _deriveKey(password, salt);

    // 4. Şifrele (AES-GCM-256)
    final secretBox = await _cipher.encrypt(
      plainText,
      secretKey: secretKey,
      nonce: nonce,
    );

    // 5. Çıktıyı paketle: {salt, nonce, ciphertext, mac}
    final map = {
      'salt': base64Encode(salt),
      'nonce': base64Encode(nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    // 6. Base64 string olarak dön
    return base64Encode(utf8.encode(jsonEncode(map)));
  }

  /// İçe aktarım: Şifreli veriyi çözer ve BackupData döner
  Future<BackupData> decryptData(String fileContent, String password) async {
    try {
      // 1. Dosya içeriğini çözümle
      final jsonString = utf8.decode(base64Decode(fileContent.trim()));
      final map = jsonDecode(jsonString) as Map<String, dynamic>;

      // 2. Bileşenleri ayır
      final salt = base64Decode(map['salt'] as String);
      final nonce = base64Decode(map['nonce'] as String);
      final cipherText = base64Decode(map['ciphertext'] as String);
      final macBytes = base64Decode(map['mac'] as String);

      // 3. Anahtarı türet
      final secretKey = await _deriveKey(password, salt);

      // 4. Şifreyi çöz
      final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));
      final clearBytes = await _cipher.decrypt(secretBox, secretKey: secretKey);
      final clearText = utf8.decode(clearBytes);

      // 5. BackupData'ya çevir
      final data = jsonDecode(clearText) as Map<String, dynamic>;
      return BackupData.fromJson(data);
    } on SecretBoxAuthenticationError {
      throw BackupException('Parola yanlış veya dosya bozuk.');
    } catch (e) {
      throw BackupException('Yedek dosyası okunamadı: $e');
    }
  }

  Future<SecretKey> _deriveKey(String password, List<int> salt) {
    // PBKDF2 algoritması ile parolayı güçlendir
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000, // Kaba kuvvet saldırısına direnç
      bits: 256,
    );
    return pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  List<int> _randomBytes(int length) {
    return List<int>.generate(length, (i) => _random.nextInt(256));
  }
}
