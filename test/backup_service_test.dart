import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_1/models/password_entry.dart';
import 'package:flutter_app_1/models/secure_note.dart';
import 'package:flutter_app_1/models/totp_account.dart';
import 'package:flutter_app_1/services/backup_service.dart';

void main() {
  group('BackupService', () {
    test('encryptData rejects short passwords', () async {
      final service = BackupService();
      final data = BackupData(
        passwords: const [],
        notes: const [],
        totpAccounts: const [],
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      );

      expect(
        () => service.encryptData(data, '12345'),
        throwsA(isA<BackupException>()),
      );
    });

    test('encryptData/decryptData round-trip restores BackupData', () async {
      final service = BackupService();
      final ts = DateTime.utc(2025, 1, 1, 0, 0, 0);
      final input = BackupData(
        passwords: [
          PasswordEntry(
            id: 'p1',
            label: 'Email',
            username: 'user@mail.com',
            password: 'Strong#123',
            category: 'E-posta',
            createdAt: ts,
          ),
        ],
        notes: [
          SecureNote(
            id: 'n1',
            title: 'WiFi',
            content: 'ssid:abc pass:xyz',
            category: 'Wi‑Fi',
            createdAt: ts,
            updatedAt: ts,
          ),
        ],
        totpAccounts: [
          TotpAccount(
            id: 't1',
            label: 'GitHub',
            issuer: 'GitHub',
            secret: 'JBSWY3DPEHPK3PXP',
            period: 30,
            digits: 6,
          ),
        ],
        timestamp: ts,
      );

      final password = 'correct horse battery staple';
      final encrypted = await service.encryptData(input, password);
      final output = await service.decryptData(encrypted, password);

      expect(output.passwords.length, 1);
      expect(output.notes.length, 1);
      expect(output.totpAccounts.length, 1);

      expect(output.passwords.first.id, 'p1');
      expect(output.passwords.first.label, 'Email');
      expect(output.passwords.first.username, 'user@mail.com');
      expect(output.passwords.first.password, 'Strong#123');
      expect(output.passwords.first.category, 'E-posta');
      expect(output.passwords.first.createdAt.toUtc(), ts);

      expect(output.notes.first.id, 'n1');
      expect(output.notes.first.title, 'WiFi');
      expect(output.notes.first.content, 'ssid:abc pass:xyz');
      expect(output.notes.first.category, 'Wi‑Fi');
      expect(output.notes.first.createdAt.toUtc(), ts);
      expect(output.notes.first.updatedAt.toUtc(), ts);

      expect(output.totpAccounts.first.id, 't1');
      expect(output.totpAccounts.first.label, 'GitHub');
      expect(output.totpAccounts.first.issuer, 'GitHub');
      expect(output.totpAccounts.first.secret, 'JBSWY3DPEHPK3PXP');
      expect(output.totpAccounts.first.period, 30);
      expect(output.totpAccounts.first.digits, 6);
    });

    test('decryptData throws BackupException on wrong password', () async {
      final service = BackupService();
      final data = BackupData(
        passwords: const [],
        notes: const [],
        totpAccounts: const [],
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      );

      final encrypted = await service.encryptData(data, 'correctPassword');

      expect(
        () => service.decryptData(encrypted, 'wrongPassword'),
        throwsA(
          isA<BackupException>().having(
            (e) => e.message,
            'message',
            contains('Parola yanlış'),
          ),
        ),
      );
    });
  });
}
