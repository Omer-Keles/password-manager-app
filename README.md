# Şifre Kasam 🔐

Flutter ile geliştirilen kapsamlı bir güvenlik uygulaması. Şifrelerinizi, güvenli notlarınızı ve 2FA kodlarınızı cihazınızda şifreli olarak saklayın.

## ✨ Özellikler

### 🔒 Güvenli Şifre Yönetimi

- **PIN Kilidi**: 4 haneli PIN ile uygulama girişi
- **Biyometrik Giriş**: Parmak izi / Face ID / Touch ID desteği
- **Şifrelenmiş Depolama**: `flutter_secure_storage` ile AES şifreleme
- **CRUD İşlemleri**: Şifre ekleme, düzenleme, silme, arama
- **Kategori Sistemi**: Banka, E-posta, Sosyal Medya, Oyun, Kart vb.
- **Güçlü Şifre Üreteci**: Otomatik güvenli şifre oluşturma

### 📝 Güvenli Notlar

- **Özel Metin Saklama**: Wi-Fi şifreleri, vergi numaraları, kripto seed phrase'ler
- **Kategorize Notlar**: Kişisel, Wi-Fi, Kripto, Vergi, Belgeler
- **Tam Metin Arama**: Notlar içinde anında arama
- **Kopyalama**: İçeriği tek tıkla panoya kopyalama

### 🔐 2FA / TOTP Yöneticisi

- **QR Kod Tarama**: Kamera ile otomatik hesap ekleme
- **Manuel Girdi**: Gizli anahtar ile manuel ekleme
- **Gerçek Zamanlı Kodlar**: 6-8 haneli TOTP kod üretimi
- **Çoklu Hesap**: Epic Games, Google, Apple, GitHub vb.

### 💾 Yedekleme & Geri Yükleme

- **Şifreli Yedek**: AES-GCM ile `.vault` dosyası
- **Dosya Tabanlı**: Kullanıcının seçtiği konuma kaydetme
- **Parola Korumalı**: Yedek dosyası için ayrı parola
- **Cross-Platform**: Android, iOS, Windows, macOS, Linux

### 🎨 Modern Arayüz

- **Material 3**: Google'ın en yeni tasarım dili
- **Dark Mode**: Karanlık ve aydınlık tema
- **Çok Dilli**: Türkçe ve İngilizce tam destek
- **Responsive**: Tablet ve telefon uyumlu
- **Smooth Animasyonlar**: Akıcı geçişler ve efektler

### 🛡️ Güvenlik

- **Root/Jailbreak Algılama**: Tehlikeli cihazlarda çalışmaz
- **Şifreli Depolama**: Tüm veriler AES ile korunur
- **Hiç Şifre Gösterilmez**: Sabit uzunlukta maskeleme
- **Güvenli Silme**: Onay dialogları ile yanlışlıkla silme engeli

## 📱 Navigasyon

Uygulama 4 ana sekme + ortada kilit butonu ile kullanılır:

1. **Şifreler**: Tüm şifre kayıtlarınız
2. **Notlar**: Güvenli metin notları
3. **2FA**: İki faktörlü kimlik doğrulama kodları
4. **Ayarlar**: Tema, dil, yedekleme, PIN sıfırlama

**Ortadaki Kilit** 🔒: Uygulamayı anında kilitler

## 🚀 Kurulum

```bash
# Bağımlılıkları yükle
flutter pub get

# Localization dosyalarını oluştur
flutter gen-l10n

# Uygulamayı çalıştır
flutter run

# Release build (Android)
flutter build apk --release

# Release build (iOS)
flutter build ios --release
```

## 🧪 Test

```bash
# Tüm testleri çalıştır
flutter test

# Kod analizi
flutter analyze

# Kod formatı
dart format lib
```

## 🌐 Yerelleştirme

Uygulama şu dilleri destekler:

- 🇹🇷 Türkçe (Varsayılan)
- 🇬🇧 İngilizce

Sistem diline göre otomatik algılama yapar.

## 📋 Teknik Detaylar

### Kullanılan Paketler

- `flutter_secure_storage`: Şifreli veri depolama
- `cryptography`: AES-GCM şifreleme
- `local_auth`: Biyometrik kimlik doğrulama
- `mobile_scanner`: QR kod tarama
- `file_picker`: Dosya seçme/kaydetme
- `otp`: TOTP kod üretimi
- `uuid`: Benzersiz ID oluşturma
- `google_fonts`: Özel fontlar

### Mimari

```
lib/
├── models/          # Veri modelleri
├── services/        # İş mantığı katmanı
├── screens/         # Sayfa widget'ları
├── widgets/         # Yeniden kullanılabilir bileşenler
├── theme/           # Tema tanımlamaları
├── l10n/            # Yerelleştirme dosyaları
└── utils/           # Yardımcı fonksiyonlar
```

## 🔐 Güvenlik Özellikleri

1. **Veri Şifreleme**: Tüm şifreler ve notlar AES ile şifrelenir
2. **PIN Koruması**: 4 haneli PIN ile giriş zorunluluğu
3. **Biyometrik**: Fingerprint/Face ID ile hızlı giriş
4. **Root Algılama**: Root/jailbreak tespit edilirse uygulama açılmaz
5. **Yedek Şifreleme**: Dışa aktarılan dosyalar AES-GCM ile korunur
6. **Güvenli Silme**: Tüm hassas veriler bellekten temizlenir

## 📸 Ekran Görüntüleri

_(Ekran görüntüleri buraya eklenecek)_

## 📄 Lisans

MIT License

## 👨‍💻 Geliştirici

Bu proje AI asistanı ile birlikte geliştirilmiştir.

---

**Not**: Bu uygulama hassas verileri saklar. Lütfen:

- PIN'inizi unutmayın
- Yedek dosyalarınızı güvenli tutun
- Yedek parolanızı kaydedin
- Düzenli yedek alın
