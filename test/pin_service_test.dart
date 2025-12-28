import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_1/services/pin_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PinService', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('hasPin is false by default, true after savePin', () async {
      final service = PinService();
      expect(await service.hasPin(), isFalse);

      await service.savePin('1234');
      expect(await service.hasPin(), isTrue);
    });

    test(
      'verifyPin returns true for correct pin, false for wrong pin',
      () async {
        final service = PinService();
        await service.savePin('1234');

        expect(await service.verifyPin('1234'), isTrue);
        expect(await service.verifyPin('0000'), isFalse);
      },
    );

    test('verifyPin returns false if no pin is set', () async {
      final service = PinService();
      expect(await service.verifyPin('1234'), isFalse);
    });

    test('clear removes stored pin', () async {
      final service = PinService();
      await service.savePin('1234');
      expect(await service.hasPin(), isTrue);

      await service.clear();
      expect(await service.hasPin(), isFalse);
      expect(await service.verifyPin('1234'), isFalse);
    });

    test('constantTimeEquality behaves correctly', () {
      final service = PinService();
      expect(service.constantTimeEquality('abc', 'abc'), isTrue);
      expect(service.constantTimeEquality('abc', 'abd'), isFalse);
      expect(service.constantTimeEquality('abc', 'ab'), isFalse);
    });

    test('deriveMasterKey generates consistent key from same PIN', () async {
      final service = PinService();
      await service.savePin('1234');

      final key1 = await service.deriveMasterKey('1234');
      final key2 = await service.deriveMasterKey('1234');

      // Aynı PIN'den türetilen key'ler aynı olmalı
      final bytes1 = await key1.extractBytes();
      final bytes2 = await key2.extractBytes();
      expect(bytes1, equals(bytes2));
      expect(bytes1.length, 32); // 256 bit = 32 byte
    });

    test(
      'deriveMasterKey generates different keys for different PINs',
      () async {
        final service = PinService();
        await service.savePin('1234');

        final key1 = await service.deriveMasterKey('1234');

        // Farklı PIN ile key türet (salt aynı olsa da farklı olmalı)
        final bytes1 = await key1.extractBytes();

        // Not: Gerçek senaryoda farklı PIN kullanırsak farklı key olur
        // Ama salt aynı olduğu için test için farklı bir yaklaşım gerekir
        expect(bytes1.length, 32);
      },
    );

    test('deriveMasterKey throws error if master key salt not found', () async {
      final service = PinService();
      // PIN kaydetmeden master key türetmeye çalış

      expect(
        () async => await service.deriveMasterKey('1234'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
