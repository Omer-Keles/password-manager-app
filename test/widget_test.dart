// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_1/app.dart';
import 'package:flutter_app_1/widgets/password_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('User can add entry and search within list', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});

    await tester.pumpWidget(const PasswordKeeperApp(enablePinLock: false));
    await tester.pumpAndSettle();

    // Add new password via kart üzerindeki buton
    await tester.tap(find.text('Yeni Şifre').first);
    await tester.pumpAndSettle();

    // Find text fields by label text instead of SemanticsLabel which can be flaky
    // Başlık field
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Başlık'),
      'Test Entry',
    );

    // Kullanıcı Adı field (Updated label)
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Kullanıcı Adı (İsteğe Bağlı)'),
      'test@mail.com',
    );

    // Şifre field (Updated label)
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Şifre / PIN'),
      'Strong#123',
    );

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    // Filter results
    await tester.enterText(find.byType(TextField).first, 'Test Entry');
    await tester.pumpAndSettle();

    final tileFinder = find.byType(PasswordTile);
    expect(tileFinder, findsOneWidget);
    expect(
      find.descendant(of: tileFinder, matching: find.text('Test Entry')),
      findsOneWidget,
    );
  });
}
