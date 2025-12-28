import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'LocalPass'**
  String get appName;

  /// No description provided for @vault.
  ///
  /// In tr, this message translates to:
  /// **'Kasa'**
  String get vault;

  /// No description provided for @passwords.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler'**
  String get passwords;

  /// No description provided for @twoFactorAuth.
  ///
  /// In tr, this message translates to:
  /// **'2FA / TOTP'**
  String get twoFactorAuth;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Kasana Hoş Geldin'**
  String get welcome;

  /// No description provided for @newPassword.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre'**
  String get newPassword;

  /// No description provided for @addNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ekle'**
  String get addNew;

  /// No description provided for @search.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler içinde ara'**
  String get search;

  /// No description provided for @searchIn.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get searchIn;

  /// No description provided for @title.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get title;

  /// No description provided for @titleHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Apartman Kapısı, Kart PIN...'**
  String get titleHint;

  /// No description provided for @username.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Adı'**
  String get username;

  /// No description provided for @usernameOptional.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Adı (İsteğe Bağlı)'**
  String get usernameOptional;

  /// No description provided for @usernameHint.
  ///
  /// In tr, this message translates to:
  /// **'E-posta, kart sahibi veya boş'**
  String get usernameHint;

  /// No description provided for @password.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get password;

  /// No description provided for @passwordOrPin.
  ///
  /// In tr, this message translates to:
  /// **'Şifre / PIN'**
  String get passwordOrPin;

  /// No description provided for @category.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @categoryGeneral.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get categoryGeneral;

  /// No description provided for @categorySocialMedia.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Medya'**
  String get categorySocialMedia;

  /// No description provided for @categoryBankFinance.
  ///
  /// In tr, this message translates to:
  /// **'Banka / Finans'**
  String get categoryBankFinance;

  /// No description provided for @categoryEcommerce.
  ///
  /// In tr, this message translates to:
  /// **'E-Ticaret'**
  String get categoryEcommerce;

  /// No description provided for @categoryWorkCorporate.
  ///
  /// In tr, this message translates to:
  /// **'İş / Kurumsal'**
  String get categoryWorkCorporate;

  /// No description provided for @categoryEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-Posta'**
  String get categoryEmail;

  /// No description provided for @categoryGaming.
  ///
  /// In tr, this message translates to:
  /// **'Oyun'**
  String get categoryGaming;

  /// No description provided for @categoryCardId.
  ///
  /// In tr, this message translates to:
  /// **'Kart / Kimlik'**
  String get categoryCardId;

  /// No description provided for @categoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryOther;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @update.
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get update;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get edit;

  /// No description provided for @copy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get copy;

  /// No description provided for @show.
  ///
  /// In tr, this message translates to:
  /// **'Göster'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In tr, this message translates to:
  /// **'Gizle'**
  String get hide;

  /// No description provided for @newRecord.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Kayıt'**
  String get newRecord;

  /// No description provided for @updateRecord.
  ///
  /// In tr, this message translates to:
  /// **'Kaydı Güncelle'**
  String get updateRecord;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Silmek istediğine emin misin?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'{label} kaydı kalıcı olarak silinecek.'**
  String deleteConfirmMessage(String label);

  /// No description provided for @saved.
  ///
  /// In tr, this message translates to:
  /// **'{label} kaydedildi'**
  String saved(String label);

  /// No description provided for @updated.
  ///
  /// In tr, this message translates to:
  /// **'{label} güncellendi'**
  String updated(String label);

  /// No description provided for @deleted.
  ///
  /// In tr, this message translates to:
  /// **'{label} silindi'**
  String deleted(String label);

  /// No description provided for @passwordCopied.
  ///
  /// In tr, this message translates to:
  /// **'Şifre panoya kopyalandı'**
  String get passwordCopied;

  /// No description provided for @codeCopied.
  ///
  /// In tr, this message translates to:
  /// **'Kod panoya kopyalandı'**
  String get codeCopied;

  /// No description provided for @generatePassword.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü Şifre Oluştur'**
  String get generatePassword;

  /// No description provided for @passwordGenerated.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü şifre oluşturuldu!'**
  String get passwordGenerated;

  /// No description provided for @backup.
  ///
  /// In tr, this message translates to:
  /// **'Yedekle / İçeri Al'**
  String get backup;

  /// No description provided for @exportPasswords.
  ///
  /// In tr, this message translates to:
  /// **'Şifreleri dışa aktar'**
  String get exportPasswords;

  /// No description provided for @exportPasswordsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Dosya olarak kaydet'**
  String get exportPasswordsSubtitle;

  /// No description provided for @importPasswords.
  ///
  /// In tr, this message translates to:
  /// **'Şifreleri içe aktar'**
  String get importPasswords;

  /// No description provided for @importPasswordsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydettiğin dosyadan geri yükle'**
  String get importPasswordsSubtitle;

  /// No description provided for @encryptBackup.
  ///
  /// In tr, this message translates to:
  /// **'Yedeği Şifrele'**
  String get encryptBackup;

  /// No description provided for @decryptBackup.
  ///
  /// In tr, this message translates to:
  /// **'Yedeği Çöz'**
  String get decryptBackup;

  /// No description provided for @backupPassword.
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme Parolası'**
  String get backupPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In tr, this message translates to:
  /// **'Parolayı Doğrula'**
  String get confirmPassword;

  /// No description provided for @encryptAndSave.
  ///
  /// In tr, this message translates to:
  /// **'Şifrele ve Kaydet'**
  String get encryptAndSave;

  /// No description provided for @decrypt.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Çöz'**
  String get decrypt;

  /// No description provided for @backupPasswordHint.
  ///
  /// In tr, this message translates to:
  /// **'Bu parolayı sakın unutma. Yedeği geri yüklemek için buna ihtiyacın olacak.'**
  String get backupPasswordHint;

  /// No description provided for @decryptPasswordHint.
  ///
  /// In tr, this message translates to:
  /// **'Dosyayı çözmek için yedekleme parolasını gir.'**
  String get decryptPasswordHint;

  /// No description provided for @backupSaved.
  ///
  /// In tr, this message translates to:
  /// **'Yedek güvenli bir şekilde kaydedildi: {path}'**
  String backupSaved(String path);

  /// No description provided for @backupRestored.
  ///
  /// In tr, this message translates to:
  /// **'Yedek başarıyla çözüldü ve yüklendi'**
  String get backupRestored;

  /// No description provided for @backupCancelled.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarma iptal edildi'**
  String get backupCancelled;

  /// No description provided for @noRecordsToBackup.
  ///
  /// In tr, this message translates to:
  /// **'Yedeklenecek kayıt bulunamadı'**
  String get noRecordsToBackup;

  /// No description provided for @pinLock.
  ///
  /// In tr, this message translates to:
  /// **'PIN Kilidi'**
  String get pinLock;

  /// No description provided for @createPin.
  ///
  /// In tr, this message translates to:
  /// **'PIN oluştur'**
  String get createPin;

  /// No description provided for @unlockVault.
  ///
  /// In tr, this message translates to:
  /// **'Kasayı aç'**
  String get unlockVault;

  /// No description provided for @pinCreateHint.
  ///
  /// In tr, this message translates to:
  /// **'Kasayı korumak için 4 haneli bir PIN belirle.'**
  String get pinCreateHint;

  /// No description provided for @pinUnlockHint.
  ///
  /// In tr, this message translates to:
  /// **'Kasanı açmak için 4 haneli PIN\'ini gir.'**
  String get pinUnlockHint;

  /// No description provided for @pinLabel.
  ///
  /// In tr, this message translates to:
  /// **'PIN'**
  String get pinLabel;

  /// No description provided for @pinConfirm.
  ///
  /// In tr, this message translates to:
  /// **'PIN tekrar'**
  String get pinConfirm;

  /// No description provided for @unlock.
  ///
  /// In tr, this message translates to:
  /// **'Kilidi Aç'**
  String get unlock;

  /// No description provided for @savePin.
  ///
  /// In tr, this message translates to:
  /// **'PIN\'i Kaydet'**
  String get savePin;

  /// No description provided for @resetPin.
  ///
  /// In tr, this message translates to:
  /// **'PIN\'i sıfırla'**
  String get resetPin;

  /// No description provided for @lockApp.
  ///
  /// In tr, this message translates to:
  /// **'Kilitle'**
  String get lockApp;

  /// No description provided for @pin4Digits.
  ///
  /// In tr, this message translates to:
  /// **'PIN 4 haneli olmalı'**
  String get pin4Digits;

  /// No description provided for @pinMismatch.
  ///
  /// In tr, this message translates to:
  /// **'PIN eşleşmiyor'**
  String get pinMismatch;

  /// No description provided for @pinIncorrect.
  ///
  /// In tr, this message translates to:
  /// **'PIN hatalı'**
  String get pinIncorrect;

  /// No description provided for @biometricLogin.
  ///
  /// In tr, this message translates to:
  /// **'Biyometrik Giriş'**
  String get biometricLogin;

  /// No description provided for @biometricReason.
  ///
  /// In tr, this message translates to:
  /// **'Kasanı açmak için parmak izi veya yüzünü kullan'**
  String get biometricReason;

  /// No description provided for @add2FA.
  ///
  /// In tr, this message translates to:
  /// **'2FA ekle'**
  String get add2FA;

  /// No description provided for @manualAdd.
  ///
  /// In tr, this message translates to:
  /// **'Manuel ekle'**
  String get manualAdd;

  /// No description provided for @scanQR.
  ///
  /// In tr, this message translates to:
  /// **'QR kod tara'**
  String get scanQR;

  /// No description provided for @no2FARecords.
  ///
  /// In tr, this message translates to:
  /// **'Henüz 2FA kaydı yok'**
  String get no2FARecords;

  /// No description provided for @no2FADescription.
  ///
  /// In tr, this message translates to:
  /// **'Epic Games, Google, Apple ve diğer hesaplar için kod üretimini buradan ekleyebilirsin.'**
  String get no2FADescription;

  /// No description provided for @addFirstAccount.
  ///
  /// In tr, this message translates to:
  /// **'İlk hesabı ekle'**
  String get addFirstAccount;

  /// No description provided for @secretKey.
  ///
  /// In tr, this message translates to:
  /// **'Gizli Anahtar'**
  String get secretKey;

  /// No description provided for @issuer.
  ///
  /// In tr, this message translates to:
  /// **'Sağlayıcı'**
  String get issuer;

  /// No description provided for @accountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Etiketi'**
  String get accountLabel;

  /// No description provided for @period.
  ///
  /// In tr, this message translates to:
  /// **'Süre (saniye)'**
  String get period;

  /// No description provided for @digits.
  ///
  /// In tr, this message translates to:
  /// **'Basamak Sayısı'**
  String get digits;

  /// No description provided for @invalidQRCode.
  ///
  /// In tr, this message translates to:
  /// **'QR kod geçersiz veya desteklenmiyor'**
  String get invalidQRCode;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Kamera izni reddedildi'**
  String get cameraPermissionDenied;

  /// No description provided for @securityWarning.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Uyarısı'**
  String get securityWarning;

  /// No description provided for @rootDetectedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Cihazınızda Root veya güvensiz yapılandırma tespit edildi. Güvenliğiniz için uygulama bu cihazda çalıştırılamaz.'**
  String get rootDetectedMessage;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @emptyState.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıt yok'**
  String get emptyState;

  /// No description provided for @emptyStateDescription.
  ///
  /// In tr, this message translates to:
  /// **'Şifrelerini güvenle saklamak için ilk kaydını ekle.'**
  String get emptyStateDescription;

  /// No description provided for @validationTitleRequired.
  ///
  /// In tr, this message translates to:
  /// **'Başlık zorunlu'**
  String get validationTitleRequired;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifre alanı boş bırakılamaz'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMin6.
  ///
  /// In tr, this message translates to:
  /// **'En az 6 karakter olmalı'**
  String get validationPasswordMin6;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In tr, this message translates to:
  /// **'Parolalar eşleşmiyor'**
  String get validationPasswordsMismatch;

  /// No description provided for @validationSecretRequired.
  ///
  /// In tr, this message translates to:
  /// **'Gizli anahtar gerekli'**
  String get validationSecretRequired;

  /// No description provided for @validationPeriodInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli süre girin'**
  String get validationPeriodInvalid;

  /// No description provided for @validationDigitsInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Basamak sayısı 6-8 arası olmalı'**
  String get validationDigitsInvalid;

  /// No description provided for @daysAgo.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün önce'**
  String daysAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In tr, this message translates to:
  /// **'{count} saat önce'**
  String hoursAgo(int count);

  /// No description provided for @minutesAgo.
  ///
  /// In tr, this message translates to:
  /// **'{count} dk önce'**
  String minutesAgo(int count);

  /// No description provided for @justNow.
  ///
  /// In tr, this message translates to:
  /// **'az önce'**
  String get justNow;

  /// No description provided for @strongPasswordGenerated.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü şifre oluşturuldu!'**
  String get strongPasswordGenerated;

  /// No description provided for @categorySocial.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Medya'**
  String get categorySocial;

  /// No description provided for @categoryBanking.
  ///
  /// In tr, this message translates to:
  /// **'Banka / Finans'**
  String get categoryBanking;

  /// No description provided for @categoryWork.
  ///
  /// In tr, this message translates to:
  /// **'İş / Kurumsal'**
  String get categoryWork;

  /// No description provided for @categoryCard.
  ///
  /// In tr, this message translates to:
  /// **'Kart / Kimlik'**
  String get categoryCard;

  /// No description provided for @usernameHelper.
  ///
  /// In tr, this message translates to:
  /// **'E-posta, kart sahibi veya boş'**
  String get usernameHelper;

  /// No description provided for @passwordPin.
  ///
  /// In tr, this message translates to:
  /// **'Şifre / PIN'**
  String get passwordPin;

  /// No description provided for @generateStrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü Şifre Oluştur'**
  String get generateStrongPassword;

  /// No description provided for @noRecordsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıt yok'**
  String get noRecordsYet;

  /// No description provided for @emptyStateMessage.
  ///
  /// In tr, this message translates to:
  /// **'İlk şifreni ekleyerek kasanı doldurmaya başla.'**
  String get emptyStateMessage;

  /// No description provided for @recordsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} kayıt'**
  String recordsCount(int count);

  /// No description provided for @welcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Kasana Hoş Geldin'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifrelerini güvende tut, gerektiğinde saniyeler içinde bul.'**
  String get welcomeSubtitle;

  /// No description provided for @backupRestore.
  ///
  /// In tr, this message translates to:
  /// **'Yedekle / İçeri Al'**
  String get backupRestore;

  /// No description provided for @user.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı'**
  String get user;

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler içinde ara'**
  String get searchHint;

  /// No description provided for @updateTwoFactor.
  ///
  /// In tr, this message translates to:
  /// **'2FA Kaydını Güncelle'**
  String get updateTwoFactor;

  /// No description provided for @newTwoFactor.
  ///
  /// In tr, this message translates to:
  /// **'Yeni 2FA Kaydı'**
  String get newTwoFactor;

  /// No description provided for @accountName.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Adı'**
  String get accountName;

  /// No description provided for @accountNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Epic Games'**
  String get accountNameHint;

  /// No description provided for @validationAccountNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Hesap adı zorunlu'**
  String get validationAccountNameRequired;

  /// No description provided for @servicePlatformOptional.
  ///
  /// In tr, this message translates to:
  /// **'Servis / Platform (opsiyonel)'**
  String get servicePlatformOptional;

  /// No description provided for @secretKeyHint.
  ///
  /// In tr, this message translates to:
  /// **'JBSWY3DPEHPK3PXP...'**
  String get secretKeyHint;

  /// No description provided for @validationSecretKeyRequired.
  ///
  /// In tr, this message translates to:
  /// **'Gizli anahtar gerekli'**
  String get validationSecretKeyRequired;

  /// No description provided for @validationSecretKeyTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Daha uzun bir anahtar girin'**
  String get validationSecretKeyTooShort;

  /// No description provided for @periodSeconds.
  ///
  /// In tr, this message translates to:
  /// **'Süre (sn)'**
  String get periodSeconds;

  /// No description provided for @validationDigitsRange.
  ///
  /// In tr, this message translates to:
  /// **'4-8 arası olmalı'**
  String get validationDigitsRange;

  /// No description provided for @scanQRInstructions.
  ///
  /// In tr, this message translates to:
  /// **'QR kodu kare içine alarak taratın. Kod taranır taranmaz hesap kaydedilir.'**
  String get scanQRInstructions;

  /// No description provided for @pinResetMessage.
  ///
  /// In tr, this message translates to:
  /// **'PIN sıfırlandı. Yeni PIN belirleyin.'**
  String get pinResetMessage;

  /// No description provided for @twoFactor.
  ///
  /// In tr, this message translates to:
  /// **'2FA'**
  String get twoFactor;

  /// No description provided for @twoFactorAdded.
  ///
  /// In tr, this message translates to:
  /// **'{label} eklendi'**
  String twoFactorAdded(String label);

  /// No description provided for @twoFactorUpdated.
  ///
  /// In tr, this message translates to:
  /// **'{label} güncellendi'**
  String twoFactorUpdated(String label);

  /// No description provided for @deleteRecord.
  ///
  /// In tr, this message translates to:
  /// **'Kaydı Sil'**
  String get deleteRecord;

  /// No description provided for @confirmDelete2FA.
  ///
  /// In tr, this message translates to:
  /// **'{label} için 2FA kaydını silmek istediğine emin misin?'**
  String confirmDelete2FA(String label);

  /// No description provided for @twoFactorDeleted.
  ///
  /// In tr, this message translates to:
  /// **'{label} silindi'**
  String twoFactorDeleted(String label);

  /// No description provided for @twoFactorTitle.
  ///
  /// In tr, this message translates to:
  /// **'2FA / TOTP'**
  String get twoFactorTitle;

  /// No description provided for @lock.
  ///
  /// In tr, this message translates to:
  /// **'Kilitle'**
  String get lock;

  /// No description provided for @addTwoFactor.
  ///
  /// In tr, this message translates to:
  /// **'2FA ekle'**
  String get addTwoFactor;

  /// No description provided for @noTwoFactorYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz 2FA kaydı yok'**
  String get noTwoFactorYet;

  /// No description provided for @emptyTwoFactorMessage.
  ///
  /// In tr, this message translates to:
  /// **'Epic Games, Google, Apple ve diğer hesaplar için kod üretimini buradan ekleyebilirsin.'**
  String get emptyTwoFactorMessage;

  /// No description provided for @secureNotes.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli Notlar'**
  String get secureNotes;

  /// No description provided for @notes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get notes;

  /// No description provided for @newNote.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Not'**
  String get newNote;

  /// No description provided for @updateNote.
  ///
  /// In tr, this message translates to:
  /// **'Notu Güncelle'**
  String get updateNote;

  /// No description provided for @noteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get noteTitle;

  /// No description provided for @noteTitleHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Wi-Fi Şifresi, Vergi Numarası...'**
  String get noteTitleHint;

  /// No description provided for @noteContent.
  ///
  /// In tr, this message translates to:
  /// **'İçerik'**
  String get noteContent;

  /// No description provided for @noteContentHint.
  ///
  /// In tr, this message translates to:
  /// **'Not içeriğini buraya yaz...'**
  String get noteContentHint;

  /// No description provided for @validationNoteTitleRequired.
  ///
  /// In tr, this message translates to:
  /// **'Başlık zorunlu'**
  String get validationNoteTitleRequired;

  /// No description provided for @validationNoteContentRequired.
  ///
  /// In tr, this message translates to:
  /// **'İçerik zorunlu'**
  String get validationNoteContentRequired;

  /// No description provided for @noteCategoryPersonal.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel'**
  String get noteCategoryPersonal;

  /// No description provided for @noteCategoryWifi.
  ///
  /// In tr, this message translates to:
  /// **'Wi-Fi'**
  String get noteCategoryWifi;

  /// No description provided for @noteCategoryCrypto.
  ///
  /// In tr, this message translates to:
  /// **'Kripto'**
  String get noteCategoryCrypto;

  /// No description provided for @noteCategoryTax.
  ///
  /// In tr, this message translates to:
  /// **'Vergi / Mali'**
  String get noteCategoryTax;

  /// No description provided for @noteCategoryDocuments.
  ///
  /// In tr, this message translates to:
  /// **'Belgeler'**
  String get noteCategoryDocuments;

  /// No description provided for @noteCategoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get noteCategoryOther;

  /// No description provided for @noteSaved.
  ///
  /// In tr, this message translates to:
  /// **'{title} kaydedildi'**
  String noteSaved(String title);

  /// No description provided for @noteUpdated.
  ///
  /// In tr, this message translates to:
  /// **'{title} güncellendi'**
  String noteUpdated(String title);

  /// No description provided for @noteDeleted.
  ///
  /// In tr, this message translates to:
  /// **'{title} silindi'**
  String noteDeleted(String title);

  /// No description provided for @deleteNoteConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'{title} notu kalıcı olarak silinecek.'**
  String deleteNoteConfirmMessage(String title);

  /// No description provided for @noNotesYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz not yok'**
  String get noNotesYet;

  /// No description provided for @emptyNotesMessage.
  ///
  /// In tr, this message translates to:
  /// **'İlk güvenli notunu ekleyerek başla.'**
  String get emptyNotesMessage;

  /// No description provided for @searchNotesHint.
  ///
  /// In tr, this message translates to:
  /// **'Notlar içinde ara'**
  String get searchNotesHint;

  /// No description provided for @contentCopied.
  ///
  /// In tr, this message translates to:
  /// **'İçerik panoya kopyalandı'**
  String get contentCopied;

  /// No description provided for @updatedAt.
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme'**
  String get updatedAt;

  /// No description provided for @appearance.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @dataManagement.
  ///
  /// In tr, this message translates to:
  /// **'Veri Yönetimi'**
  String get dataManagement;

  /// No description provided for @exportData.
  ///
  /// In tr, this message translates to:
  /// **'Verileri Dışa Aktar'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tüm şifreleri ve notları yedekle'**
  String get exportDataSubtitle;

  /// No description provided for @importData.
  ///
  /// In tr, this message translates to:
  /// **'Verileri İçe Aktar'**
  String get importData;

  /// No description provided for @importDataSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yedekten geri yükle'**
  String get importDataSubtitle;

  /// No description provided for @importWarning.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut veriler yedeğin içeriği ile birleştirilecek. Devam etmek istiyor musun?'**
  String get importWarning;

  /// No description provided for @continueAction.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueAction;

  /// No description provided for @recordsBackedUp.
  ///
  /// In tr, this message translates to:
  /// **'kayıt yedeklendi'**
  String get recordsBackedUp;

  /// No description provided for @recordsImported.
  ///
  /// In tr, this message translates to:
  /// **'kayıt içe aktarıldı'**
  String get recordsImported;

  /// No description provided for @security.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get security;

  /// No description provided for @resetPinSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'PIN kodunu değiştir'**
  String get resetPinSubtitle;

  /// No description provided for @resetPinConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'PIN kodunu sıfırlamak istediğine emin misin? Yeni bir PIN oluşturman gerekecek.'**
  String get resetPinConfirmMessage;

  /// No description provided for @reset.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get reset;

  /// No description provided for @about.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Sürümü'**
  String get appVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
