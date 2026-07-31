# ShortsForge - دليل البناء والتشغيل

## كيفية البناء والاختبار والتشغيل

### المتطلبات الأساسية
- Flutter SDK (Stable Channel 3.24+)
- Android SDK (API 24+)
- Java JDK 17+

### أوامر البناء الأساسية

```bash
# تثبيت التبعيات
flutter pub get

# التحليل الثابت (يجب أن يمر بدون أخطاء)
flutter analyze

# تشغيل الاختبارات
flutter test

# بناء APK للتصحيح
flutter build apk --debug

# بناء APK للإصدار (يتطلب مفاتيح التوقيع)
flutter build apk --release
```

### تشغيل التطبيق على جهاز متصل

```bash
flutter run --debug
```

## اتفاقيات المشروع

### هيكل المجلدات
```
/workspace/
├── lib/
│   ├── main.dart
│   ├── core/           # الأساسيات المشتركة
│   └── features/       # الميزات (feature-first)
├── assets/
│   ├── fonts/          # الخطوط العربية
│   └── templates/      # قوالب JSON
├── docs/
│   └── BLUEPRINT.md    # الدستور التقني
├── test/               # الاختبارات
├── .github/workflows/  # CI/CD
└── QWEN.md            # هذا الملف
```

### Naming Conventions
- **Files**: snake_case (e.g., `home_screen.dart`)
- **Classes**: PascalCase (e.g., `HomeScreen`)
- **Variables/Functions**: camelCase (e.g., `selectedTemplate`)
- **Constants**: lowerCamelCase with `const` (e.g., `maxVideoDuration`)

### State Management
- استخدام Riverpod لجميع حالات التطبيق
- StateNotifiers للـ business logic
- Providers للقراءة فقط

### Code Style
- استخدم `const` constructors دائماً عندما يكون ذلك ممكناً
- استخدم single quotes للنصوص `'text'`
- تجنب `print()` في production code
- استخدم comments باللغة العربية عندما يكون السياق محلياً

---

## القواعد الصارمة (HARD RULES)

### 🔴 القاعدة 1: اقرأ BLUEPRINT.md دائماً
**قبل البدء بأي مهمة، يجب قراءة `docs/BLUEPRINT.md` بالكامل.**
هذا الملف يحتوي على الدستور التقني ولا يجوز مخالفته.

### 🔴 القاعدة 2: لا معالجة فيديو سحابية
**ممنوع استخدام أي API سحابي لمعالجة الفيديو.**
جميع عمليات الفيديو تتم على الجهاز باستخدام FFmpeg.

### 🔴 القاعدة 3: لا تبعيات جديدة بدون مبرر
**لا تضيف أي dependency جديد في `pubspec.yaml` بدون تبرير واضح في وصف الـ PR.**
التبرير يجب أن يشرح:
- لماذا هذه التبعية ضرورية؟
- ما البديل الذي تم استكشافه؟
- كيف تؤثر على حجم التطبيق؟

### 🔴 القاعدة 4: لا تكسر البناء أبداً
**يجب أن ينجح `flutter build apk --debug` دائماً.**
قبل فتح أي PR:
1. `flutter pub get` ✅
2. `flutter analyze` ✅ (0 errors)
3. `flutter test` ✅ (all pass)
4. `flutter build apk --debug` ✅

### 🔴 القاعدة 5: Offline-First
**كل شيء يجب أن يعمل بدون اتصال بالإنترنت إلا جلب روابط إنستغرام.**
- تخزين محلي للمشاريع
- قوالب JSON محلية
- معالجة فيديو على الجهاز
- لا APIs خارجية

---

## التحقق قبل الـ Commit

```bash
# قائمة التحقق
flutter pub get && \
flutter analyze && \
flutter test && \
flutter build apk --debug
```

إذا فشل أي من هذه الأوامر، **لا تفتح PR**.

---

## استكشاف الأخطاء

### `flutter pub get` يفشل
```bash
flutter clean
rm pubspec.lock
flutter pub get
```

### `flutter analyze` يظهر أخطاء
- أصلح جميع الأخطاء قبل المتابعة
- التحذيرات (warnings) مقبولة لكن يفضل إصلاحها
- المعلومات (infos) اختيارية

### `flutter test` يفشل
- تأكد من تحديث الاختبارات مع الكود
- اختبر widget tests مع `flutter test --platform chrome` إذا لزم الأمر

### `flutter build apk` يفشل
- تحقق من وجود Android SDK
- تحقق من `android/app/build.gradle` settings
- جرب `flutter clean && flutter pub get`

---

## التواصل

للأسئلة أو المشاكل:
1. راجع `docs/BLUEPRINT.md` أولاً
2. تحقق من الاختبارات الفاشلة
3. وثّق المشكلة في issue tracker

---

**تذكر: هذا مشروع إنتاجي. الجودة أهم من السرعة.**
