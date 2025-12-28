import 'package:cryptography/cryptography.dart';

/// Oturum boyunca master key'i bellekte tutan singleton
/// PIN doğrulandığında key set edilir, logout/uygulama kapanınca temizlenir
class SessionKeyManager {
  SessionKeyManager._();
  static final SessionKeyManager instance = SessionKeyManager._();

  SecretKey? _masterKey;

  /// Master key'i set et (PIN doğrulama sonrası)
  void setMasterKey(SecretKey key) {
    _masterKey = key;
  }

  /// Master key'i al
  SecretKey? get masterKey => _masterKey;

  /// Master key var mı?
  bool get hasKey => _masterKey != null;

  /// Master key'i temizle (logout/lock)
  void clear() {
    _masterKey = null;
  }
}
