import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cryptography/cryptography.dart';

import 'package:flutter_app_1/models/password_entry.dart';
import 'package:flutter_app_1/models/secure_note.dart';
import 'package:flutter_app_1/models/totp_account.dart';
import 'package:flutter_app_1/services/notes_repository.dart';
import 'package:flutter_app_1/services/password_repository.dart';
import 'package:flutter_app_1/services/twofa_repository.dart';
import 'package:flutter_app_1/services/session_key_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Repositories', () {
    late SecretKey testMasterKey;

    setUp(() async {
      FlutterSecureStorage.setMockInitialValues({});

      // Test için master key oluştur ve session'a set et
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

    test('PasswordRepository save/load round-trip', () async {
      final repo = PasswordRepository();
      final ts = DateTime.utc(2025, 1, 1);
      final entries = [
        PasswordEntry(
          id: 'p1',
          label: 'Email',
          username: 'a@b.com',
          password: 'x',
          category: 'Genel',
          createdAt: ts,
        ),
      ];

      expect(await repo.loadEntries(), isEmpty);
      await repo.saveEntries(entries);
      final loaded = await repo.loadEntries();
      expect(loaded.length, 1);
      expect(loaded.first.id, 'p1');
      expect(loaded.first.createdAt.toUtc(), ts);
    });

    test('PasswordRepository clear removes entries', () async {
      final repo = PasswordRepository();
      await repo.saveEntries([
        PasswordEntry(
          id: 'p1',
          label: 'X',
          username: '',
          password: '',
          createdAt: DateTime.utc(2025, 1, 1),
        ),
      ]);
      expect((await repo.loadEntries()).length, 1);
      await repo.clear();
      expect(await repo.loadEntries(), isEmpty);
    });

    test('NotesRepository save/load round-trip', () async {
      final repo = NotesRepository();
      final ts = DateTime.utc(2025, 1, 1);
      final notes = [
        SecureNote(
          id: 'n1',
          title: 'Note',
          content: 'Content',
          category: 'Personal',
          createdAt: ts,
          updatedAt: ts,
        ),
      ];

      expect(await repo.loadNotes(), isEmpty);
      await repo.saveNotes(notes);
      final loaded = await repo.loadNotes();
      expect(loaded.length, 1);
      expect(loaded.first.id, 'n1');
      expect(loaded.first.createdAt.toUtc(), ts);
      expect(loaded.first.updatedAt.toUtc(), ts);
    });

    test('TwoFactorRepository save/load round-trip', () async {
      final repo = TwoFactorRepository();
      final accounts = [
        TotpAccount(
          id: 't1',
          label: 'GitHub',
          issuer: 'GitHub',
          secret: 'JBSWY3DPEHPK3PXP',
          period: 30,
          digits: 6,
        ),
      ];

      expect(await repo.loadAccounts(), isEmpty);
      await repo.saveAccounts(accounts);
      final loaded = await repo.loadAccounts();
      expect(loaded.length, 1);
      expect(loaded.first.id, 't1');
      expect(loaded.first.secret, 'JBSWY3DPEHPK3PXP');
      expect(loaded.first.period, 30);
      expect(loaded.first.digits, 6);
    });

    test(
      'PasswordRepository throws error when master key is missing',
      () async {
        SessionKeyManager.instance.clear(); // Master key'i temizle
        final repo = PasswordRepository();

        // Önce bir veri kaydet (master key ile)
        final pbkdf2 = Pbkdf2(
          macAlgorithm: Hmac.sha256(),
          iterations: 1000,
          bits: 256,
        );
        final tempKey = await pbkdf2.deriveKey(
          secretKey: SecretKey('temp'.codeUnits),
          nonce: List.filled(16, 1),
        );
        SessionKeyManager.instance.setMasterKey(tempKey);

        await repo.saveEntries([
          PasswordEntry(
            id: 'test',
            label: 'Test',
            username: 'test',
            password: 'test',
            createdAt: DateTime.now(),
          ),
        ]);

        // Şimdi master key'i temizle
        SessionKeyManager.instance.clear();

        // Load denemesi - şimdi hata fırlatmalı (data var ama key yok)
        expect(
          () async => await repo.loadEntries(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Master key yok'),
            ),
          ),
        );

        // Save denemesi
        expect(
          () async => await repo.saveEntries([]),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Master key yok'),
            ),
          ),
        );
      },
    );

    test('NotesRepository throws error when master key is missing', () async {
      SessionKeyManager.instance.clear();
      final repo = NotesRepository();

      expect(
        () async => await repo.saveNotes([]),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Master key yok'),
          ),
        ),
      );
    });

    test(
      'TwoFactorRepository throws error when master key is missing',
      () async {
        SessionKeyManager.instance.clear();
        final repo = TwoFactorRepository();

        expect(
          () async => await repo.saveAccounts([]),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Master key yok'),
            ),
          ),
        );
      },
    );
  });

  group('Model JSON round-trip', () {
    test('PasswordEntry', () {
      final ts = DateTime.utc(2025, 1, 1);
      final entry = PasswordEntry(
        id: 'p1',
        label: 'Email',
        username: 'u',
        password: 'p',
        category: 'Genel',
        createdAt: ts,
      );
      final decoded = PasswordEntry.fromJson(entry.toJson());
      expect(decoded.id, 'p1');
      expect(decoded.createdAt.toUtc(), ts);
      expect(decoded.category, 'Genel');
    });

    test('SecureNote', () {
      final ts = DateTime.utc(2025, 1, 1);
      final note = SecureNote(
        id: 'n1',
        title: 'T',
        content: 'C',
        category: 'Personal',
        createdAt: ts,
        updatedAt: ts,
      );
      final decoded = SecureNote.fromJson(note.toJson());
      expect(decoded.id, 'n1');
      expect(decoded.createdAt.toUtc(), ts);
      expect(decoded.updatedAt.toUtc(), ts);
      expect(decoded.category, 'Personal');
    });

    test('TotpAccount', () {
      final account = TotpAccount(
        id: 't1',
        label: 'GitHub',
        issuer: 'GitHub',
        secret: 'ABC',
        period: 60,
        digits: 8,
      );
      final decoded = TotpAccount.fromJson(account.toJson());
      expect(decoded.id, 't1');
      expect(decoded.period, 60);
      expect(decoded.digits, 8);
      expect(decoded.issuer, 'GitHub');
    });
  });
}
