import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_app_1/app.dart';
import 'package:flutter_app_1/widgets/password_tile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke: add password entry and search (TR locale)', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    tester.binding.platformDispatcher.localeTestValue = const Locale('tr');

    await tester.pumpWidget(const PasswordKeeperApp(enablePinLock: false));
    // Same reason as widget tests: periodic Timer prevents pumpAndSettle.
    await tester.pump(const Duration(milliseconds: 200));

    final fabFinder = find.byType(FloatingActionButton);
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      final fab = tester.widget<FloatingActionButton>(fabFinder);
      if (fab.onPressed != null) break;
    }
    expect(tester.widget<FloatingActionButton>(fabFinder).onPressed, isNotNull);

    await tester.tap(fabFinder);
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byKey(const Key('add_password_title')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('add_password_title')),
      'Integration Entry',
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(
      find.byKey(const Key('add_password_username')),
      'int@mail.com',
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(
      find.byKey(const Key('add_password_password')),
      'Strong#123',
    );
    await tester.pump(const Duration(milliseconds: 100));

    final saveButton = find.byKey(const Key('add_password_save'));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.ensureVisible(saveButton);
    await tester.pump();
    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);
    await tester.tap(saveButton, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.byKey(const Key('add_password_title')), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'Integration Entry');
    await tester.pump(const Duration(milliseconds: 200));

    final tileFinder = find.byType(PasswordTile);
    expect(tileFinder, findsOneWidget);
    expect(
      find.descendant(of: tileFinder, matching: find.text('Integration Entry')),
      findsOneWidget,
    );

    tester.binding.platformDispatcher.clearLocaleTestValue();
  });
}
