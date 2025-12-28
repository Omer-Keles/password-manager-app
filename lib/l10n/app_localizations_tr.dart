// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'LocalPass';

  @override
  String get vault => 'Kasa';

  @override
  String get passwords => 'Şifreler';

  @override
  String get twoFactorAuth => '2FA / TOTP';

  @override
  String get settings => 'Ayarlar';

  @override
  String get welcome => 'Şifre Kasana Hoş Geldin';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get addNew => 'Yeni Ekle';

  @override
  String get search => 'Şifreler içinde ara';

  @override
  String get searchIn => 'Ara';

  @override
  String get title => 'Başlık';

  @override
  String get titleHint => 'Örn. Apartman Kapısı, Kart PIN...';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get usernameOptional => 'Kullanıcı Adı (İsteğe Bağlı)';

  @override
  String get usernameHint => 'E-posta, kart sahibi veya boş';

  @override
  String get password => 'Şifre';

  @override
  String get passwordOrPin => 'Şifre / PIN';

  @override
  String get category => 'Kategori';

  @override
  String get categoryGeneral => 'Genel';

  @override
  String get categorySocialMedia => 'Sosyal Medya';

  @override
  String get categoryBankFinance => 'Banka / Finans';

  @override
  String get categoryEcommerce => 'E-Ticaret';

  @override
  String get categoryWorkCorporate => 'İş / Kurumsal';

  @override
  String get categoryEmail => 'E-Posta';

  @override
  String get categoryGaming => 'Oyun';

  @override
  String get categoryCardId => 'Kart / Kimlik';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get save => 'Kaydet';

  @override
  String get update => 'Güncelle';

  @override
  String get delete => 'Sil';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get edit => 'Düzenle';

  @override
  String get copy => 'Kopyala';

  @override
  String get show => 'Göster';

  @override
  String get hide => 'Gizle';

  @override
  String get newRecord => 'Yeni Kayıt';

  @override
  String get updateRecord => 'Kaydı Güncelle';

  @override
  String get deleteConfirmTitle => 'Silmek istediğine emin misin?';

  @override
  String deleteConfirmMessage(String label) {
    return '$label kaydı kalıcı olarak silinecek.';
  }

  @override
  String saved(String label) {
    return '$label kaydedildi';
  }

  @override
  String updated(String label) {
    return '$label güncellendi';
  }

  @override
  String deleted(String label) {
    return '$label silindi';
  }

  @override
  String get passwordCopied => 'Şifre panoya kopyalandı';

  @override
  String get codeCopied => 'Kod panoya kopyalandı';

  @override
  String get generatePassword => 'Güçlü Şifre Oluştur';

  @override
  String get passwordGenerated => 'Güçlü şifre oluşturuldu!';

  @override
  String get backup => 'Yedekle / İçeri Al';

  @override
  String get exportPasswords => 'Şifreleri dışa aktar';

  @override
  String get exportPasswordsSubtitle => 'Dosya olarak kaydet';

  @override
  String get importPasswords => 'Şifreleri içe aktar';

  @override
  String get importPasswordsSubtitle => 'Kaydettiğin dosyadan geri yükle';

  @override
  String get encryptBackup => 'Yedeği Şifrele';

  @override
  String get decryptBackup => 'Yedeği Çöz';

  @override
  String get backupPassword => 'Yedekleme Parolası';

  @override
  String get confirmPassword => 'Parolayı Doğrula';

  @override
  String get encryptAndSave => 'Şifrele ve Kaydet';

  @override
  String get decrypt => 'Şifreyi Çöz';

  @override
  String get backupPasswordHint =>
      'Bu parolayı sakın unutma. Yedeği geri yüklemek için buna ihtiyacın olacak.';

  @override
  String get decryptPasswordHint =>
      'Dosyayı çözmek için yedekleme parolasını gir.';

  @override
  String backupSaved(String path) {
    return 'Yedek güvenli bir şekilde kaydedildi: $path';
  }

  @override
  String get backupRestored => 'Yedek başarıyla çözüldü ve yüklendi';

  @override
  String get backupCancelled => 'Dışa aktarma iptal edildi';

  @override
  String get noRecordsToBackup => 'Yedeklenecek kayıt bulunamadı';

  @override
  String get pinLock => 'PIN Kilidi';

  @override
  String get createPin => 'PIN oluştur';

  @override
  String get unlockVault => 'Kasayı aç';

  @override
  String get pinCreateHint => 'Kasayı korumak için 4 haneli bir PIN belirle.';

  @override
  String get pinUnlockHint => 'Kasanı açmak için 4 haneli PIN\'ini gir.';

  @override
  String get pinLabel => 'PIN';

  @override
  String get pinConfirm => 'PIN tekrar';

  @override
  String get unlock => 'Kilidi Aç';

  @override
  String get savePin => 'PIN\'i Kaydet';

  @override
  String get resetPin => 'PIN\'i sıfırla';

  @override
  String get lockApp => 'Kilitle';

  @override
  String get pin4Digits => 'PIN 4 haneli olmalı';

  @override
  String get pinMismatch => 'PIN eşleşmiyor';

  @override
  String get pinIncorrect => 'PIN hatalı';

  @override
  String get biometricLogin => 'Biyometrik Giriş';

  @override
  String get biometricReason =>
      'Kasanı açmak için parmak izi veya yüzünü kullan';

  @override
  String get add2FA => '2FA ekle';

  @override
  String get manualAdd => 'Manuel ekle';

  @override
  String get scanQR => 'QR kod tara';

  @override
  String get no2FARecords => 'Henüz 2FA kaydı yok';

  @override
  String get no2FADescription =>
      'Epic Games, Google, Apple ve diğer hesaplar için kod üretimini buradan ekleyebilirsin.';

  @override
  String get addFirstAccount => 'İlk hesabı ekle';

  @override
  String get secretKey => 'Gizli Anahtar';

  @override
  String get issuer => 'Sağlayıcı';

  @override
  String get accountLabel => 'Hesap Etiketi';

  @override
  String get period => 'Süre (saniye)';

  @override
  String get digits => 'Basamak Sayısı';

  @override
  String get invalidQRCode => 'QR kod geçersiz veya desteklenmiyor';

  @override
  String get cameraPermissionDenied => 'Kamera izni reddedildi';

  @override
  String get securityWarning => 'Güvenlik Uyarısı';

  @override
  String get rootDetectedMessage =>
      'Cihazınızda Root veya güvensiz yapılandırma tespit edildi. Güvenliğiniz için uygulama bu cihazda çalıştırılamaz.';

  @override
  String get close => 'Kapat';

  @override
  String get emptyState => 'Henüz kayıt yok';

  @override
  String get emptyStateDescription =>
      'Şifrelerini güvenle saklamak için ilk kaydını ekle.';

  @override
  String get validationTitleRequired => 'Başlık zorunlu';

  @override
  String get validationPasswordRequired => 'Şifre alanı boş bırakılamaz';

  @override
  String get validationPasswordMin6 => 'En az 6 karakter olmalı';

  @override
  String get validationPasswordsMismatch => 'Parolalar eşleşmiyor';

  @override
  String get validationSecretRequired => 'Gizli anahtar gerekli';

  @override
  String get validationPeriodInvalid => 'Geçerli süre girin';

  @override
  String get validationDigitsInvalid => 'Basamak sayısı 6-8 arası olmalı';

  @override
  String daysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String hoursAgo(int count) {
    return '$count saat önce';
  }

  @override
  String minutesAgo(int count) {
    return '$count dk önce';
  }

  @override
  String get justNow => 'az önce';

  @override
  String get strongPasswordGenerated => 'Güçlü şifre oluşturuldu!';

  @override
  String get categorySocial => 'Sosyal Medya';

  @override
  String get categoryBanking => 'Banka / Finans';

  @override
  String get categoryWork => 'İş / Kurumsal';

  @override
  String get categoryCard => 'Kart / Kimlik';

  @override
  String get usernameHelper => 'E-posta, kart sahibi veya boş';

  @override
  String get passwordPin => 'Şifre / PIN';

  @override
  String get generateStrongPassword => 'Güçlü Şifre Oluştur';

  @override
  String get noRecordsYet => 'Henüz kayıt yok';

  @override
  String get emptyStateMessage =>
      'İlk şifreni ekleyerek kasanı doldurmaya başla.';

  @override
  String recordsCount(int count) {
    return '$count kayıt';
  }

  @override
  String get welcomeTitle => 'Şifre Kasana Hoş Geldin';

  @override
  String get welcomeSubtitle =>
      'Şifrelerini güvende tut, gerektiğinde saniyeler içinde bul.';

  @override
  String get backupRestore => 'Yedekle / İçeri Al';

  @override
  String get user => 'Kullanıcı';

  @override
  String get searchHint => 'Şifreler içinde ara';

  @override
  String get updateTwoFactor => '2FA Kaydını Güncelle';

  @override
  String get newTwoFactor => 'Yeni 2FA Kaydı';

  @override
  String get accountName => 'Hesap Adı';

  @override
  String get accountNameHint => 'Örn. Epic Games';

  @override
  String get validationAccountNameRequired => 'Hesap adı zorunlu';

  @override
  String get servicePlatformOptional => 'Servis / Platform (opsiyonel)';

  @override
  String get secretKeyHint => 'JBSWY3DPEHPK3PXP...';

  @override
  String get validationSecretKeyRequired => 'Gizli anahtar gerekli';

  @override
  String get validationSecretKeyTooShort => 'Daha uzun bir anahtar girin';

  @override
  String get periodSeconds => 'Süre (sn)';

  @override
  String get validationDigitsRange => '4-8 arası olmalı';

  @override
  String get scanQRInstructions =>
      'QR kodu kare içine alarak taratın. Kod taranır taranmaz hesap kaydedilir.';

  @override
  String get pinResetMessage => 'PIN sıfırlandı. Yeni PIN belirleyin.';

  @override
  String get twoFactor => '2FA';

  @override
  String twoFactorAdded(String label) {
    return '$label eklendi';
  }

  @override
  String twoFactorUpdated(String label) {
    return '$label güncellendi';
  }

  @override
  String get deleteRecord => 'Kaydı Sil';

  @override
  String confirmDelete2FA(String label) {
    return '$label için 2FA kaydını silmek istediğine emin misin?';
  }

  @override
  String twoFactorDeleted(String label) {
    return '$label silindi';
  }

  @override
  String get twoFactorTitle => '2FA / TOTP';

  @override
  String get lock => 'Kilitle';

  @override
  String get addTwoFactor => '2FA ekle';

  @override
  String get noTwoFactorYet => 'Henüz 2FA kaydı yok';

  @override
  String get emptyTwoFactorMessage =>
      'Epic Games, Google, Apple ve diğer hesaplar için kod üretimini buradan ekleyebilirsin.';

  @override
  String get secureNotes => 'Güvenli Notlar';

  @override
  String get notes => 'Notlar';

  @override
  String get newNote => 'Yeni Not';

  @override
  String get updateNote => 'Notu Güncelle';

  @override
  String get noteTitle => 'Başlık';

  @override
  String get noteTitleHint => 'Örn. Wi-Fi Şifresi, Vergi Numarası...';

  @override
  String get noteContent => 'İçerik';

  @override
  String get noteContentHint => 'Not içeriğini buraya yaz...';

  @override
  String get validationNoteTitleRequired => 'Başlık zorunlu';

  @override
  String get validationNoteContentRequired => 'İçerik zorunlu';

  @override
  String get noteCategoryPersonal => 'Kişisel';

  @override
  String get noteCategoryWifi => 'Wi-Fi';

  @override
  String get noteCategoryCrypto => 'Kripto';

  @override
  String get noteCategoryTax => 'Vergi / Mali';

  @override
  String get noteCategoryDocuments => 'Belgeler';

  @override
  String get noteCategoryOther => 'Diğer';

  @override
  String noteSaved(String title) {
    return '$title kaydedildi';
  }

  @override
  String noteUpdated(String title) {
    return '$title güncellendi';
  }

  @override
  String noteDeleted(String title) {
    return '$title silindi';
  }

  @override
  String deleteNoteConfirmMessage(String title) {
    return '$title notu kalıcı olarak silinecek.';
  }

  @override
  String get noNotesYet => 'Henüz not yok';

  @override
  String get emptyNotesMessage => 'İlk güvenli notunu ekleyerek başla.';

  @override
  String get searchNotesHint => 'Notlar içinde ara';

  @override
  String get contentCopied => 'İçerik panoya kopyalandı';

  @override
  String get updatedAt => 'Güncelleme';

  @override
  String get appearance => 'Görünüm';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Aydınlık';

  @override
  String get themeDark => 'Karanlık';

  @override
  String get language => 'Dil';

  @override
  String get dataManagement => 'Veri Yönetimi';

  @override
  String get exportData => 'Verileri Dışa Aktar';

  @override
  String get exportDataSubtitle => 'Tüm şifreleri ve notları yedekle';

  @override
  String get importData => 'Verileri İçe Aktar';

  @override
  String get importDataSubtitle => 'Yedekten geri yükle';

  @override
  String get importWarning =>
      'Mevcut veriler yedeğin içeriği ile birleştirilecek. Devam etmek istiyor musun?';

  @override
  String get continueAction => 'Devam Et';

  @override
  String get recordsBackedUp => 'kayıt yedeklendi';

  @override
  String get recordsImported => 'kayıt içe aktarıldı';

  @override
  String get security => 'Güvenlik';

  @override
  String get resetPinSubtitle => 'PIN kodunu değiştir';

  @override
  String get resetPinConfirmMessage =>
      'PIN kodunu sıfırlamak istediğine emin misin? Yeni bir PIN oluşturman gerekecek.';

  @override
  String get reset => 'Sıfırla';

  @override
  String get about => 'Hakkında';

  @override
  String get appVersion => 'Uygulama Sürümü';
}
