import '../models/totp_account.dart';

TotpAccount? parseOtpAuthUri(String value) {
  if (value.isEmpty) return null;
  Uri? uri;
  try {
    uri = Uri.parse(value.trim());
  } catch (_) {
    return null;
  }
  if (uri.scheme != 'otpauth' || uri.host.toLowerCase() != 'totp') {
    return null;
  }
  final labelSegment = uri.path.replaceFirst('/', '');
  final decodedLabel = Uri.decodeComponent(labelSegment);
  final labelParts = decodedLabel.split(':');
  final issuerFromLabel = labelParts.length > 1 ? labelParts.first.trim() : '';
  final accountLabel = labelParts.length > 1
      ? labelParts.last.trim()
      : decodedLabel;

  final secret = uri.queryParameters['secret'];
  if (secret == null || secret.isEmpty) return null;

  final issuer = uri.queryParameters['issuer']?.trim().isNotEmpty == true
      ? uri.queryParameters['issuer']!.trim()
      : issuerFromLabel;
  final period = int.tryParse(uri.queryParameters['period'] ?? '') ?? 30;
  final digits = int.tryParse(uri.queryParameters['digits'] ?? '') ?? 6;

  return TotpAccount(
    label: accountLabel,
    issuer: issuer,
    secret: secret.toUpperCase(),
    period: period,
    digits: digits,
  );
}
