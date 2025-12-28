import 'package:flutter_test/flutter_test.dart';
import 'package:otp/otp.dart';

void main() {
  group('TOTP generation (RFC 6238 vectors)', () {
    test('SHA1 / 30s interval at T=59s matches known vector (8 digits)', () {
      // RFC 6238 test secret: "12345678901234567890" in Base32.
      final secret = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';

      final code8 = OTP.generateTOTPCodeString(
        secret,
        59000, // 59s
        interval: 30,
        length: 8,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      expect(code8, '94287082');
    });

    test('6 digit code is the truncated version of the same vector', () {
      final secret = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';

      final code6 = OTP.generateTOTPCodeString(
        secret,
        59000,
        interval: 30,
        length: 6,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      expect(code6, '287082');
    });
  });
}


