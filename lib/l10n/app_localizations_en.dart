// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Password Vault';

  @override
  String get vault => 'Vault';

  @override
  String get passwords => 'Passwords';

  @override
  String get twoFactorAuth => '2FA / TOTP';

  @override
  String get settings => 'Settings';

  @override
  String get welcome => 'Welcome to Your Vault';

  @override
  String get newPassword => 'New Password';

  @override
  String get addNew => 'Add New';

  @override
  String get search => 'Search passwords';

  @override
  String get searchIn => 'Search';

  @override
  String get title => 'Title';

  @override
  String get titleHint => 'E.g. Door Code, Card PIN...';

  @override
  String get username => 'Username';

  @override
  String get usernameOptional => 'Username (Optional)';

  @override
  String get usernameHint => 'Email, cardholder or leave empty';

  @override
  String get password => 'Password';

  @override
  String get passwordOrPin => 'Password / PIN';

  @override
  String get category => 'Category';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categorySocialMedia => 'Social Media';

  @override
  String get categoryBankFinance => 'Bank / Finance';

  @override
  String get categoryEcommerce => 'E-Commerce';

  @override
  String get categoryWorkCorporate => 'Work / Corporate';

  @override
  String get categoryEmail => 'Email';

  @override
  String get categoryGaming => 'Gaming';

  @override
  String get categoryCardId => 'Card / ID';

  @override
  String get categoryOther => 'Other';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get copy => 'Copy';

  @override
  String get show => 'Show';

  @override
  String get hide => 'Hide';

  @override
  String get newRecord => 'New Record';

  @override
  String get updateRecord => 'Update Record';

  @override
  String get deleteConfirmTitle => 'Are you sure you want to delete?';

  @override
  String deleteConfirmMessage(String label) {
    return '$label will be permanently deleted.';
  }

  @override
  String saved(String label) {
    return '$label saved';
  }

  @override
  String updated(String label) {
    return '$label updated';
  }

  @override
  String deleted(String label) {
    return '$label deleted';
  }

  @override
  String get passwordCopied => 'Password copied to clipboard';

  @override
  String get codeCopied => 'Code copied to clipboard';

  @override
  String get generatePassword => 'Generate Strong Password';

  @override
  String get passwordGenerated => 'Strong password generated!';

  @override
  String get backup => 'Backup / Restore';

  @override
  String get exportPasswords => 'Export passwords';

  @override
  String get exportPasswordsSubtitle => 'Save as file';

  @override
  String get importPasswords => 'Import passwords';

  @override
  String get importPasswordsSubtitle => 'Restore from your saved file';

  @override
  String get encryptBackup => 'Encrypt Backup';

  @override
  String get decryptBackup => 'Decrypt Backup';

  @override
  String get backupPassword => 'Backup Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get encryptAndSave => 'Encrypt and Save';

  @override
  String get decrypt => 'Decrypt';

  @override
  String get backupPasswordHint =>
      'Don\'t forget this password. You\'ll need it to restore the backup.';

  @override
  String get decryptPasswordHint =>
      'Enter the backup password to decrypt the file.';

  @override
  String backupSaved(String path) {
    return 'Backup securely saved: $path';
  }

  @override
  String get backupRestored => 'Backup successfully decrypted and loaded';

  @override
  String get backupCancelled => 'Export cancelled';

  @override
  String get noRecordsToBackup => 'No records to backup';

  @override
  String get pinLock => 'PIN Lock';

  @override
  String get createPin => 'Create PIN';

  @override
  String get unlockVault => 'Unlock Vault';

  @override
  String get pinCreateHint => 'Set a 4-digit PIN to protect your vault.';

  @override
  String get pinUnlockHint => 'Enter your 4-digit PIN to unlock.';

  @override
  String get pinLabel => 'PIN';

  @override
  String get pinConfirm => 'Confirm PIN';

  @override
  String get unlock => 'Unlock';

  @override
  String get savePin => 'Save PIN';

  @override
  String get resetPin => 'Reset PIN';

  @override
  String get lockApp => 'Lock';

  @override
  String get pin4Digits => 'PIN must be 4 digits';

  @override
  String get pinMismatch => 'PINs don\'t match';

  @override
  String get pinIncorrect => 'Incorrect PIN';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get biometricReason => 'Use fingerprint or face to unlock your vault';

  @override
  String get add2FA => 'Add 2FA';

  @override
  String get manualAdd => 'Manual add';

  @override
  String get scanQR => 'Scan QR code';

  @override
  String get no2FARecords => 'No 2FA records yet';

  @override
  String get no2FADescription =>
      'Add code generation for Epic Games, Google, Apple and other accounts here.';

  @override
  String get addFirstAccount => 'Add first account';

  @override
  String get secretKey => 'Secret Key';

  @override
  String get issuer => 'Issuer';

  @override
  String get accountLabel => 'Account Label';

  @override
  String get period => 'Period (seconds)';

  @override
  String get digits => 'Digit Count';

  @override
  String get invalidQRCode => 'Invalid or unsupported QR code';

  @override
  String get cameraPermissionDenied => 'Camera permission denied';

  @override
  String get securityWarning => 'Security Warning';

  @override
  String get rootDetectedMessage =>
      'Root or unsafe configuration detected on your device. For your security, the app cannot run on this device.';

  @override
  String get close => 'Close';

  @override
  String get emptyState => 'No records yet';

  @override
  String get emptyStateDescription =>
      'Add your first record to securely store your passwords.';

  @override
  String get validationTitleRequired => 'Title is required';

  @override
  String get validationPasswordRequired => 'Password cannot be empty';

  @override
  String get validationPasswordMin6 => 'Must be at least 6 characters';

  @override
  String get validationPasswordsMismatch => 'Passwords don\'t match';

  @override
  String get validationSecretRequired => 'Secret key is required';

  @override
  String get validationPeriodInvalid => 'Enter valid period';

  @override
  String get validationDigitsInvalid => 'Digit count must be between 6-8';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String get justNow => 'just now';

  @override
  String get strongPasswordGenerated => 'Strong password generated!';

  @override
  String get categorySocial => 'Social Media';

  @override
  String get categoryBanking => 'Banking / Finance';

  @override
  String get categoryWork => 'Work / Corporate';

  @override
  String get categoryCard => 'Card / ID';

  @override
  String get usernameHelper => 'Email, cardholder, or leave blank';

  @override
  String get passwordPin => 'Password / PIN';

  @override
  String get generateStrongPassword => 'Generate Strong Password';

  @override
  String get noRecordsYet => 'No records yet';

  @override
  String get emptyStateMessage =>
      'Add your first password to start filling your vault.';

  @override
  String recordsCount(int count) {
    return '$count records';
  }

  @override
  String get welcomeTitle => 'Welcome to Your Password Vault';

  @override
  String get welcomeSubtitle =>
      'Keep your passwords safe, find them in seconds when you need.';

  @override
  String get backupRestore => 'Backup / Restore';

  @override
  String get user => 'User';

  @override
  String get searchHint => 'Search in passwords';

  @override
  String get updateTwoFactor => 'Update 2FA Record';

  @override
  String get newTwoFactor => 'New 2FA Record';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountNameHint => 'e.g. Epic Games';

  @override
  String get validationAccountNameRequired => 'Account name is required';

  @override
  String get servicePlatformOptional => 'Service / Platform (optional)';

  @override
  String get secretKeyHint => 'JBSWY3DPEHPK3PXP...';

  @override
  String get validationSecretKeyRequired => 'Secret key is required';

  @override
  String get validationSecretKeyTooShort => 'Enter a longer key';

  @override
  String get periodSeconds => 'Period (sec)';

  @override
  String get validationDigitsRange => 'Must be between 4-8';

  @override
  String get scanQRInstructions =>
      'Scan the QR code by placing it inside the frame. The account will be added automatically.';

  @override
  String get pinResetMessage => 'PIN has been reset. Please set a new PIN.';

  @override
  String get twoFactor => '2FA';

  @override
  String twoFactorAdded(String label) {
    return '$label added';
  }

  @override
  String twoFactorUpdated(String label) {
    return '$label updated';
  }

  @override
  String get deleteRecord => 'Delete Record';

  @override
  String confirmDelete2FA(String label) {
    return 'Are you sure you want to delete 2FA record for $label?';
  }

  @override
  String twoFactorDeleted(String label) {
    return '$label deleted';
  }

  @override
  String get twoFactorTitle => '2FA / TOTP';

  @override
  String get lock => 'Lock';

  @override
  String get addTwoFactor => 'Add 2FA';

  @override
  String get noTwoFactorYet => 'No 2FA records yet';

  @override
  String get emptyTwoFactorMessage =>
      'Add code generation for Epic Games, Google, Apple, and other accounts here.';

  @override
  String get secureNotes => 'Secure Notes';

  @override
  String get notes => 'Notes';

  @override
  String get newNote => 'New Note';

  @override
  String get updateNote => 'Update Note';

  @override
  String get noteTitle => 'Title';

  @override
  String get noteTitleHint => 'e.g. Wi-Fi Password, Tax Number...';

  @override
  String get noteContent => 'Content';

  @override
  String get noteContentHint => 'Write your note content here...';

  @override
  String get validationNoteTitleRequired => 'Title is required';

  @override
  String get validationNoteContentRequired => 'Content is required';

  @override
  String get noteCategoryPersonal => 'Personal';

  @override
  String get noteCategoryWifi => 'Wi-Fi';

  @override
  String get noteCategoryCrypto => 'Crypto';

  @override
  String get noteCategoryTax => 'Tax / Financial';

  @override
  String get noteCategoryDocuments => 'Documents';

  @override
  String get noteCategoryOther => 'Other';

  @override
  String noteSaved(String title) {
    return '$title saved';
  }

  @override
  String noteUpdated(String title) {
    return '$title updated';
  }

  @override
  String noteDeleted(String title) {
    return '$title deleted';
  }

  @override
  String deleteNoteConfirmMessage(String title) {
    return '$title note will be permanently deleted.';
  }

  @override
  String get noNotesYet => 'No notes yet';

  @override
  String get emptyNotesMessage => 'Add your first secure note to get started.';

  @override
  String get searchNotesHint => 'Search in notes';

  @override
  String get contentCopied => 'Content copied to clipboard';

  @override
  String get updatedAt => 'Updated';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataSubtitle => 'Backup all passwords and notes';

  @override
  String get importData => 'Import Data';

  @override
  String get importDataSubtitle => 'Restore from backup';

  @override
  String get importWarning =>
      'Current data will be merged with the backup content. Do you want to continue?';

  @override
  String get continueAction => 'Continue';

  @override
  String get recordsBackedUp => 'records backed up';

  @override
  String get recordsImported => 'records imported';

  @override
  String get security => 'Security';

  @override
  String get resetPinSubtitle => 'Change your PIN code';

  @override
  String get resetPinConfirmMessage =>
      'Are you sure you want to reset your PIN? You will need to create a new one.';

  @override
  String get reset => 'Reset';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';
}
