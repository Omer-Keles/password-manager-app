// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cryptography/cryptography.dart';

import 'package:flutter_app_1/app.dart';
import 'package:flutter_app_1/widgets/password_tile.dart';
import 'package:flutter_app_1/services/session_key_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('User can add entry and search within list', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});

    // Test için master key oluştur ve session'a set et
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 1000,
      bits: 256,
    );
    final testMasterKey = await pbkdf2.deriveKey(
      secretKey: SecretKey('test1234'.codeUnits),
      nonce: List.filled(16, 42),
    );
    SessionKeyManager.instance.setMasterKey(testMasterKey);

    // Stabilize locale-dependent labels in tests.
    tester.binding.platformDispatcher.localeTestValue = const Locale('tr');

    await tester.pumpWidget(const PasswordKeeperApp(enablePinLock: false));
    // HomeShell uses IndexedStack and TotpPage has a periodic Timer, so
    // pumpAndSettle can time out. Use time-based pumps instead.
    await tester.pump(const Duration(milliseconds: 200));

    // Add new password via FAB (+)
    final fabFinder = find.byType(FloatingActionButton);
    // Wait until initial async load completes and FAB becomes enabled.
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      final fab = tester.widget<FloatingActionButton>(fabFinder);
      if (fab.onPressed != null) break;
    }
    expect(tester.widget<FloatingActionButton>(fabFinder).onPressed, isNotNull);

    await tester.tap(fabFinder);
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byKey(const Key('add_password_title')), findsOneWidget);

    // Başlık field
    await tester.enterText(
      find.byKey(const Key('add_password_title')),
      'Test Entry',
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Kullanıcı Adı field (Updated label)
    await tester.enterText(
      find.byKey(const Key('add_password_username')),
      'test@mail.com',
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Şifre field (Updated label)
    await tester.enterText(
      find.byKey(const Key('add_password_password')),
      'Strong#123',
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Close keyboard without dismissing the modal bottom sheet.
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(const Duration(milliseconds: 200));

    final saveButton = find.byKey(const Key('add_password_save'));
    await tester.ensureVisible(saveButton);
    await tester.pump();
    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));

    // Bottom sheet should be closed after successful save
    expect(find.byKey(const Key('add_password_title')), findsNothing);

    // Filter results
    await tester.enterText(find.byType(TextField).first, 'Test Entry');
    await tester.pump(const Duration(milliseconds: 200));

    final tileFinder = find.byType(PasswordTile);
    expect(tileFinder, findsOneWidget);
    expect(
      find.descendant(of: tileFinder, matching: find.text('Test Entry')),
      findsOneWidget,
    );

    // Cleanup
    tester.binding.platformDispatcher.clearLocaleTestValue();
  });
}
