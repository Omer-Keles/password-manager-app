import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_1/services/encryption_service.dart';
import 'package:cryptography/cryptography.dart';

void main() {
  group('EncryptionService', () {
    late EncryptionService service;
    late SecretKey testKey;

    setUp(() async {
      service = EncryptionService();
      // Test için sabit bir key oluştur
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 1000,
        bits: 256,
      );
      testKey = await pbkdf2.deriveKey(
        secretKey: SecretKey('test1234'.codeUnits),
        nonce: List.filled(16, 42),
      );
    });

    test('encrypt/decrypt round-trip works', () async {
      final originalData = '{"test": "data", "number": 123}';

      final encrypted = await service.encrypt(originalData, testKey);
      expect(encrypted, isNotEmpty);
      expect(encrypted, isNot(contains('test')));

      final decrypted = await service.decrypt(encrypted, testKey);
      expect(decrypted, equals(originalData));
    });

    test('decrypt with wrong key throws error', () async {
      final originalData = '{"test": "secret"}';
      final encrypted = await service.encrypt(originalData, testKey);

      // Farklı bir key oluştur
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 1000,
        bits: 256,
      );
      final wrongKey = await pbkdf2.deriveKey(
        secretKey: SecretKey('wrongpass'.codeUnits),
        nonce: List.filled(16, 99),
      );

      expect(
        () async => await service.decrypt(encrypted, wrongKey),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('tampered data throws error', () async {
      final originalData = '{"test": "data"}';
      final encrypted = await service.encrypt(originalData, testKey);

      // Şifreli veriyi boz
      final corrupted = encrypted.substring(0, encrypted.length - 5) + 'xxxxx';

      expect(
        () async => await service.decrypt(corrupted, testKey),
        throwsA(isA<EncryptionException>()),
      );
    });
  });
}
