import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_1/utils/totp_parser.dart';

void main() {
  group('parseOtpAuthUri', () {
    test('returns null for empty/invalid input', () {
      expect(parseOtpAuthUri(''), isNull);
      expect(parseOtpAuthUri('not a uri'), isNull);
      expect(parseOtpAuthUri('https://example.com'), isNull);
      expect(parseOtpAuthUri('otpauth://hotp/Label?secret=ABC'), isNull);
    });

    test('parses secret, label, issuer (issuer param preferred)', () {
      final uri =
          'otpauth://totp/GitHub:alice%40mail.com?secret=jbswy3dpehpk3pxp&issuer=GitHub&period=30&digits=6';
      final account = parseOtpAuthUri(uri);
      expect(account, isNotNull);
      expect(account!.issuer, 'GitHub');
      expect(account.label, 'alice@mail.com');
      expect(account.secret, 'JBSWY3DPEHPK3PXP'); // uppercased
      expect(account.period, 30);
      expect(account.digits, 6);
    });

    test('issuer falls back to label prefix if issuer param missing', () {
      final uri =
          'otpauth://totp/MyBank:User1?secret=abcd1234&period=60&digits=8';
      final account = parseOtpAuthUri(uri);
      expect(account, isNotNull);
      expect(account!.issuer, 'MyBank');
      expect(account.label, 'User1');
      expect(account.period, 60);
      expect(account.digits, 8);
    });

    test('defaults to period=30 and digits=6 if missing', () {
      final uri = 'otpauth://totp/Example?secret=abcd1234';
      final account = parseOtpAuthUri(uri);
      expect(account, isNotNull);
      expect(account!.period, 30);
      expect(account.digits, 6);
    });
  });
}
