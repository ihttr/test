# 🕌 تطبيق مواقيت الصلاة
**Prayer Times App — Flutter (iOS & Android)**

تطبيق احترافي لمواقيت الصلاة بثيم داكن وفاتح، مع بوصلة القبلة، التقويم الهجري، وإشعارات قابلة للتخصيص.

---

## ✨ الميزات

| الميزة | التفاصيل |
|--------|---------|
| 🕐 مواقيت الصلاة | حساب دقيق بطريقة أم القرى |
| 🔔 الإشعارات | إشعار قابل للتخصيص قبل الأذان (0-30 دقيقة) |
| 🧭 القبلة | بوصلة حية لاتجاه مكة المكرمة |
| 📅 التقويم الهجري | تقويم كامل مع المناسبات الإسلامية |
| 🌙 الثيم | داكن وفاتح مع تبديل فوري |
| 📍 الموقع | تحديد تلقائي للمنطقة |
| ⏱️ العداد التنازلي | عداد لحظي للصلاة القادمة |
| 🔕 تحكم بالإشعارات | تفعيل/إيقاف لكل صلاة منفردة |

---

## 🚀 خطوات التشغيل

### المتطلبات
- Flutter SDK 3.0+
- Dart 3.0+
- Xcode 15+ (لـ iOS)
- Android Studio (لـ Android)

### 1. تثبيت المشروع

```bash
# انسخ المجلد وافتح الترمنال فيه
cd prayer_times_app

# حمّل المكتبات
flutter pub get
```

### 2. تشغيل على iOS

```bash
# تأكد من وجود simulator
open -a Simulator

# شغّل التطبيق
flutter run
```

### 3. تشغيل على Android

```bash
flutter run
```

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                    # نقطة الدخول الرئيسية
├── theme/
│   └── app_theme.dart           # الثيم الداكن والفاتح
├── models/
│   └── prayer_model.dart        # نماذج البيانات
├── services/
│   ├── prayer_service.dart      # حساب المواقيت والموقع
│   └── notification_service.dart # إدارة الإشعارات
├── screens/
│   ├── home_screen.dart         # الشاشة الرئيسية
│   ├── qibla_screen.dart        # شاشة القبلة
│   ├── settings_screen.dart     # الإعدادات
│   └── hijri_calendar_screen.dart # التقويم الهجري
└── widgets/
    ├── next_prayer_card.dart    # بطاقة الصلاة القادمة
    ├── prayer_list_tile.dart    # صف الصلاة
    └── hijri_date_widget.dart   # عرض التاريخ الهجري
```

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `adhan` | حساب مواقيت الصلاة |
| `geolocator` | تحديد الموقع الجغرافي |
| `geocoding` | تحويل الإحداثيات لاسم المدينة |
| `flutter_local_notifications` | الإشعارات المحلية |
| `flutter_qiblah` | بوصلة القبلة |
| `hijri` | التقويم الهجري |
| `audioplayers` | تشغيل صوت الأذان |
| `google_fonts` | خط Cairo العربي |
| `shared_preferences` | حفظ الإعدادات |

---

## ⚙️ تخصيص الإعدادات

### تغيير طريقة الحساب
في `prayer_service.dart` السطر 30:
```dart
// أم القرى (افتراضي)
final params = CalculationMethod.umm_al_qura().getParameters();

// طرق أخرى:
// CalculationMethod.muslim_world_league()
// CalculationMethod.egyptian()
// CalculationMethod.karachi()
```

### تغيير المدينة الافتراضية
في `home_screen.dart` السطر 55:
```dart
double lat = _settings.latitude ?? 21.3891; // خط عرض مكة
double lng = _settings.longitude ?? 39.8579; // خط طول مكة
```

---

## 🎨 ألوان الثيم

```dart
// الذهبي الرئيسي
static const Color primaryGold = Color(0xFFD4A843);

// الخلفية الداكنة
static const Color darkBg = Color(0xFF0D0F14);

// الخلفية الفاتحة
static const Color lightBg = Color(0xFFF5F7FF);
```

---

## 📱 الإذونات المطلوبة

### iOS (Info.plist)
- `NSLocationWhenInUseUsageDescription` — الموقع
- `NSMicrophoneUsageDescription` — تسجيل الأذان

### Android (AndroidManifest.xml)
- `ACCESS_FINE_LOCATION` — الموقع
- `POST_NOTIFICATIONS` — الإشعارات
- `SCHEDULE_EXACT_ALARM` — جدولة الإشعارات
- `RECORD_AUDIO` — تسجيل الأذان

---

## 🔮 ميزات مستقبلية

- [ ] ويدجت الشاشة الرئيسية (iOS Widget / Android Widget)
- [ ] تسجيل الأذان المحلي
- [ ] دعم المدن المحفوظة
- [ ] Apple Watch / WearOS
- [ ] وضع رمضان

---

## 📲 نشر التطبيق

### iOS (App Store)
```bash
flutter build ipa
# ارفع ملف .ipa عبر Xcode أو Transporter
```

### Android (Google Play)
```bash
flutter build appbundle
# ارفع ملف .aab على Google Play Console
```
