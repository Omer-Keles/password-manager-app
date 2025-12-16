import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class TotpAccount {
  TotpAccount({
    String? id,
    required this.label,
    required this.issuer,
    required this.secret,
    this.period = 30,
    this.digits = 6,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String label;
  final String issuer;
  final String secret;
  final int period;
  final int digits;

  TotpAccount copyWith({
    String? id,
    String? label,
    String? issuer,
    String? secret,
    int? period,
    int? digits,
  }) {
    return TotpAccount(
      id: id ?? this.id,
      label: label ?? this.label,
      issuer: issuer ?? this.issuer,
      secret: secret ?? this.secret,
      period: period ?? this.period,
      digits: digits ?? this.digits,
    );
  }

  factory TotpAccount.fromJson(Map<String, dynamic> json) {
    return TotpAccount(
      id: json['id'] as String?,
      label: json['label'] as String,
      issuer: json['issuer'] as String? ?? '',
      secret: json['secret'] as String,
      period: json['period'] as int? ?? 30,
      digits: json['digits'] as int? ?? 6,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'issuer': issuer,
      'secret': secret,
      'period': period,
      'digits': digits,
    };
  }
}
