import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cryptography/cryptography.dart';

import 'package:flutter_app_1/models/password_entry.dart';
import 'package:flutter_app_1/models/secure_note.dart';
import 'package:flutter_app_1/models/totp_account.dart';
import 'package:flutter_app_1/services/backup_service.dart';
import 'package:flutter_app_1/services/password_repository.dart';
import 'package:flutter_app_1/services/notes_repository.dart';
import 'package:flutter_app_1/services/twofa_repository.dart';
import 'package:flutter_app_1/services/session_key_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Backup Integration Tests', () {
    late SecretKey testMasterKey;

    setUp(() async {
      FlutterSecureStorage.setMockInitialValues({});

      // Master key oluştur
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 1000,
        bits: 256,
      );
      testMasterKey = await pbkdf2.deriveKey(
        secretKey: SecretKey('test1234'.codeUnits),
        nonce: List.filled(16, 42),
      );
      SessionKeyManager.instance.setMasterKey(testMasterKey);
    });

    tearDown(() {
      SessionKeyManager.instance.clear();
    });

    test('Full backup/restore workflow preserves all data', () async {
      // 1. Veri hazırla ve kaydet
      final passwordRepo = PasswordRepository();
      final notesRepo = NotesRepository();
      final totpRepo = TwoFactorRepository();

      final testPassword = PasswordEntry(
        id: 'p1',
        label: 'Test Email',
        username: 'test@example.com',
        password: 'SecurePass123!',
        category: 'E-posta',
        createdAt: DateTime.utc(2025, 1, 1),
      );

      final testNote = SecureNote(
        id: 'n1',
        title: 'WiFi Credentials',
        content: 'SSID: MyWiFi\nPassword: wifi123',
        category: 'Wi‑Fi',
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 1),
      );

      final testTotp = TotpAccount(
        id: 't1',
        label: 'GitHub',
        issuer: 'GitHub',
        secret: 'JBSWY3DPEHPK3PXP',
        period: 30,
        digits: 6,
      );

      await passwordRepo.saveEntries([testPassword]);
      await notesRepo.saveNotes([testNote]);
      await totpRepo.saveAccounts([testTotp]);

      // 2. Backup oluştur
      final backupService = BackupService();
      final backupData = BackupData(
        passwords: [testPassword],
        notes: [testNote],
        totpAccounts: [testTotp],
        timestamp: DateTime.now(),
      );

      final backupPassword = 'MyBackupPassword123!';
      final encryptedBackup = await backupService.encryptData(
        backupData,
        backupPassword,
      );

      expect(encryptedBackup, isNotEmpty);
      expect(encryptedBackup, isNot(contains('test@example.com')));
      expect(encryptedBackup, isNot(contains('WiFi')));

      // 3. Tüm verileri temizle (cihaz kaybı simülasyonu)
      await passwordRepo.clear();
      FlutterSecureStorage.setMockInitialValues({}); // Storage'ı sıfırla

      // Yeni master key set et (yeni cihaz/yeni PIN senaryosu)
      final newPbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 1000,
        bits: 256,
      );
      final newMasterKey = await newPbkdf2.deriveKey(
        secretKey: SecretKey('newpin5678'.codeUnits),
        nonce: List.filled(16, 99),
      );
      SessionKeyManager.instance.setMasterKey(newMasterKey);

      // 4. Backup'tan geri yükle
      final restoredData = await backupService.decryptData(
        encryptedBackup,
        backupPassword,
      );

      // 5. Verileri kaydet (yeni master key ile şifrelenecek)
      final newPasswordRepo = PasswordRepository();
      final newNotesRepo = NotesRepository();
      final newTotpRepo = TwoFactorRepository();

      await newPasswordRepo.saveEntries(restoredData.passwords);
      await newNotesRepo.saveNotes(restoredData.notes);
      await newTotpRepo.saveAccounts(restoredData.totpAccounts);

      // 6. Verileri oku ve doğrula
      final loadedPasswords = await newPasswordRepo.loadEntries();
      final loadedNotes = await newNotesRepo.loadNotes();
      final loadedTotp = await newTotpRepo.loadAccounts();

      expect(loadedPasswords.length, 1);
      expect(loadedPasswords.first.label, 'Test Email');
      expect(loadedPasswords.first.username, 'test@example.com');
      expect(loadedPasswords.first.password, 'SecurePass123!');

      expect(loadedNotes.length, 1);
      expect(loadedNotes.first.title, 'WiFi Credentials');
      expect(loadedNotes.first.content, contains('MyWiFi'));

      expect(loadedTotp.length, 1);
      expect(loadedTotp.first.label, 'GitHub');
      expect(loadedTotp.first.secret, 'JBSWY3DPEHPK3PXP');
    });

    test('Restore fails with wrong backup password', () async {
      final backupService = BackupService();
      final backupData = BackupData(
        passwords: const [],
        notes: const [],
        totpAccounts: const [],
        timestamp: DateTime.now(),
      );

      final correctPassword = 'CorrectPassword123';
      final encrypted = await backupService.encryptData(
        backupData,
        correctPassword,
      );

      expect(
        () async =>
            await backupService.decryptData(encrypted, 'WrongPassword456'),
        throwsA(
          isA<BackupException>().having(
            (e) => e.message,
            'message',
            contains('Parola yanlış'),
          ),
        ),
      );
    });

    test('Backup encrypts sensitive data (no plaintext leak)', () async {
      final backupService = BackupService();
      final sensitivePassword = PasswordEntry(
        id: 'secret1',
        label: 'Bank Account',
        username: 'secretuser@bank.com',
        password: 'SuperSecret123!@#',
        category: 'Banka',
        createdAt: DateTime.now(),
      );

      final backupData = BackupData(
        passwords: [sensitivePassword],
        notes: const [],
        totpAccounts: const [],
        timestamp: DateTime.now(),
      );

      final encrypted = await backupService.encryptData(
        backupData,
        'BackupPassword',
      );

      // Şifreli backup içinde düz metin olmamalı
      expect(encrypted, isNot(contains('secretuser@bank.com')));
      expect(encrypted, isNot(contains('SuperSecret123')));
      expect(encrypted, isNot(contains('Bank Account')));
      expect(encrypted, isNot(contains('secret1')));
    });

    test('Empty backup can be created and restored', () async {
      final backupService = BackupService();
      final emptyBackup = BackupData(
        passwords: const [],
        notes: const [],
        totpAccounts: const [],
        timestamp: DateTime.now(),
      );

      final encrypted = await backupService.encryptData(
        emptyBackup,
        'password',
      );
      final restored = await backupService.decryptData(encrypted, 'password');

      expect(restored.passwords, isEmpty);
      expect(restored.notes, isEmpty);
      expect(restored.totpAccounts, isEmpty);
    });
  });
}
