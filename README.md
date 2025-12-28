# LocalPass 🔐

Local-only şifre kasası: Şifreler, güvenli notlar ve 2FA (TOTP) kodları buluta gitmeden, sadece cihazınızda AES-256-GCM ile şifreli saklanır.

## ✨ Özellikler

### 🔒 Şifreler

- PIN + biyometrik giriş (parmak izi / Face ID / Touch ID)
- **AES‑256‑GCM** ile şifreli depolama (her veri AES-GCM ile şifrelenir)
- PIN'den PBKDF2 (100k iterasyon) ile master key türetilir
- Master key oturum boyunca bellekte tutulur, lock/logout'ta temizlenir
- CRUD + arama, kategori (Banka, E-posta, Sosyal Medya, Oyun, Kart vb.)
- Güçlü şifre üretici, kopyalama

### 📝 Güvenli Notlar

- Kategoriler: Kişisel, Wi‑Fi, Kripto, Vergi, Belgeler
- Tam metin arama, içerik kopyalama

### 🔐 2FA / TOTP

- QR kod tarama ile otomatik ekleme
- Manuel giriş (varsayılan 6 hane; QR ile 6/8 hane desteklenir)
- Gerçek zamanlı kod üretimi, çoklu hesap

### 💾 Yedekleme

- AES‑GCM 256 ile şifreli `.vault` dosyası
- Parola korumalı, paylaşım menüsüyle dışa aktarma (Android/iOS)
- İçeri alma: Parola doğrulaması sonrası tüm verileri yükler

### 🎨 Arayüz

- Material 3, uyumlu açık/koyu tema
- Türkçe ve İngilizce tam yerelleştirme
- Responsive (telefon/tablet)

### 🛡️ Güvenlik

- **Defense in Depth**: Veriler çift katmanlı şifreleme ile korunur
  1. AES‑GCM‑256 uygulama katmanında (master key ile)
  2. Platform şifrelemesi (Keystore/Keychain) depolama katmanında
- PIN'den PBKDF2 (100k iterasyon) ile master key türetimi
- Root tespiti (Android) – güvensiz cihazlarda çalışmaz
- Akıllı arka plan kilitleme:
  - 30 saniyeden az: kilitleme yok (dosya seçici vb. için)
  - 30+ saniye arka planda: otomatik kilit
- Screenshot / ekran kaydı engelleme (Android), iOS app switcher gizleme
- Yedekler PBKDF2 (100k iterasyon) + AES‑GCM 256 ile korunur
- Bütünlük doğrulama: MAC ile veri manipülasyonu tespiti

## 📱 Navigasyon

- **Şifreler**
- **Notlar**
- **2FA**
- **Ayarlar**

## 🚀 Kurulum

```bash
# Bağımlılıkları yükle
flutter pub get

# Yerelleştirme üret (l10n.yaml var)
flutter gen-l10n

# Çalıştır
flutter run

# Release build
flutter build apk --release
flutter build ios --release
```

## 🧪 Test & Analiz

```bash
flutter test
flutter analyze
dart format lib
```

## 🌐 Yerelleştirme

- 🇹🇷 Türkçe (varsayılan)
- 🇬🇧 İngilizce

## 📋 Mimari

```
lib/
├── models/      # Veri modelleri
├── services/    # İş mantığı / depolama
├── screens/     # Sayfalar
├── widgets/     # Yeniden kullanılabilir bileşenler
├── theme/       # Tema
├── l10n/        # Yerelleştirme
└── utils/       # Yardımcılar
```

### Kullanılan Başlıca Paketler

- flutter_secure_storage, cryptography (AES‑GCM, PBKDF2)
- local_auth (biyometrik)
- mobile_scanner (QR)
- file_picker, share_plus, path_provider (yedekleme paylaşım/kayıt)
- otp (TOTP), uuid, google_fonts

## 🔐 Güvenlik Özeti

1. **Veri şifreleme**:
   - Uygulama katmanı: AES‑256‑GCM (master key ile)
   - Depolama katmanı: Platform şifrelemesi (Keystore/Keychain)
2. **Anahtar yönetimi**: PIN → PBKDF2 (100k) → Master Key → RAM (oturum)
3. PIN + biyometrik giriş zorunlu
4. **Akıllı arka plan kilidi**:
   - < 30 sn: kilitleme yok (UX için)
   - ≥ 30 sn: otomatik kilit + master key temizleme
5. Screenshot/record engeli (Android), iOS app switcher gizleme
6. Yedekler: PBKDF2 (100k) + AES‑GCM 256
7. Root tespiti (Android)
8. Bütünlük doğrulama: MAC ile tamper detection

## 📸 Ekran Görüntüleri

_(Eklenecek)_

## 📄 Lisans

MIT License

## 👨‍💻 Not

Bu uygulama hassas verileri saklar:

- PIN ve yedek parolasını kaybetmeyin
- Yedek dosyalarını güvenli konumda tutun
- Düzenli yedek alın
