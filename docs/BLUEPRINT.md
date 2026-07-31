# ShortsForge - الهندسة المعمارية والدستور التقني

## الرؤية والهدف

تطبيق أندرويد يعمل بدون اتصال بالإنترنت (Offline-First) لتحويل فيديوهات إنستغرام إلى Shorts/Reels احترافية 9:16 مع إضافة العلامة التجارية.

## خط المعالجة الكامل (Pipeline)

```
[1] الاستيراد (Import)
    ├── رابط إنستغرام (يتطلب اتصال بالإنترنت فقط للجلب)
    └── ملف محلي (يعمل بدون اتصال)
    
[2] القوالب (Templates)
    └── اختيار من 10 قوالب JSON قابلة للتعديل
    
[3] التحجيم والتكييف (Auto-Fit)
    ├── فيديو 9:16 في المقدمة
    └── خلفية ضبابية (Blur) لملء المساحة
    
[4] محرر النصوص (Text Editor)
    ├── نصوص عربية/إنجليزية
    └── خطوط: Cairo, Tajawal
    
[5] الملصقات المتحركة (Animated Stickers)
    ├── أسهم، دوائر، إلخ
    └── Keyframes للحركة
    
[6] الصوت (Audio)
    ├── تسجيل صوتي (Voiceover)
    ├── إزالة الصوت الأصلي
    └── خلط الموسيقى مع التحكم في الصوت والفلاتر
    
[7] فلاتر الواقعية (Realism Filters)
    └── تحسين فيديوهات الذكاء الاصطناعي
    
[8] غلاف تلقائي (Auto Cover)
    └── توليد إطار الغلاف
    
[9] التصدير (Export)
    └── 1080x1920 MP4
```

## المكدس التقني (Tech Stack)

| المكون | التقنية | الإصدار |
|--------|---------|---------|
| Framework | Flutter | Stable Channel (3.24+) |
| State Management | Riverpod | 2.4+ |
| Video Processing | ffmpeg_kit_flutter | Latest |
| Data Serialization | json_serializable + freezed | Latest |
| Local Storage | path_provider + dart:io | Built-in |
| Fonts | Cairo, Tajawal | Google Fonts |

### قيود صارمة
- ❌ لا معالجة سحابية للفيديو (No Cloud Processing)
- ❌ لا APIs خارجية إلا لجلب روابط إنستغرام
- ❌ لا تحليلات أو تتبع (No Analytics/Tracking)
- ✅ كل شيء يعمل بدون اتصال إلا جلب الروابط

## هيكل المجلدات (Feature-First Architecture)

```
lib/
├── main.dart                    # نقطة الدخول
├── core/                        # الأساسيات المشتركة
│   ├── models/                  # نماذج البيانات الأساسية
│   ├── utils/                   # أدوات مساعدة
│   └── constants/               # الثوابت
├── features/
│   ├── import/                  # ميزة الاستيراد
│   │   ├── presentation/        # UI
│   │   ├── domain/              # Business Logic
│   │   └── data/                # Repository & Data Sources
│   ├── templates/               # ميزة القوالب
│   ├── editor_text/             # محرر النصوص
│   ├── editor_stickers/         # محرر الملصقات
│   ├── audio/                   # معالجة الصوت
│   └── export/                  # التصدير
└── assets/
    ├── fonts/                   # خطوط Arabic
    └── templates/               # ملفات JSON للقوالب
```

## نموذج قالب الفيديو (Template JSON Schema)

القوالب هي **بيانات وليست كود**. يمكن تعديلها بدون إعادة البرمجة.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "name", "backgroundLayer", "videoSlot"],
  "properties": {
    "id": {
      "type": "string",
      "description": "معرف فريد للقالب"
    },
    "name": {
      "type": "string",
      "description": "اسم القالب بالعربية"
    },
    "backgroundLayer": {
      "type": "object",
      "properties": {
        "type": { "enum": ["blur", "color", "gradient"] },
        "blurStrength": { "type": "number", "minimum": 0, "maximum": 100 },
        "color": { "type": "string", "pattern": "^#[0-9A-Fa-f]{6}$" }
      }
    },
    "videoSlot": {
      "type": "object",
      "required": ["x", "y", "w", "h"],
      "properties": {
        "x": { "type": "number", "description": "نسبة من العرض (0-1)" },
        "y": { "type": "number", "description": "نسبة من الطول (0-1)" },
        "w": { "type": "number", "description": "نسبة من العرض (0-1)" },
        "h": { "type": "number", "description": "نسبة من الطول (0-1)" },
        "rounded": { "type": "number", "description": "نصف قطر الزوايا" }
      }
    },
    "textLayers": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["id", "defaultText", "position", "style"],
        "properties": {
          "id": { "type": "string" },
          "defaultText": { "type": "string" },
          "position": {
            "type": "object",
            "properties": {
              "x": { "type": "number" },
              "y": { "type": "number" },
              "alignment": { "enum": ["topLeft", "topCenter", "topRight", "center", "bottomLeft", "bottomCenter", "bottomRight"] }
            }
          },
          "style": {
            "type": "object",
            "properties": {
              "fontFamily": { "enum": ["Cairo", "Tajawal"] },
              "fontSize": { "type": "number" },
              "fontWeight": { "enum": ["normal", "bold"] },
              "color": { "type": "string" },
              "backgroundColor": { "type": "string" },
              "padding": { "type": "number" }
            }
          }
        }
      }
    },
    "stickerSlots": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": { "type": "string" },
          "asset": { "type": "string" },
          "defaultPosition": {
            "type": "object",
            "properties": {
              "x": { "type": "number" },
              "y": { "type": "number" }
            }
          }
        }
      }
    },
    "stylePreset": {
      "type": "string",
      "description": "اسم preset الألوان والفلاتر"
    }
  }
}
```

### مثال قالب عملي

```json
{
  "id": "template_001",
  "name": "كلاسيكي عربي",
  "backgroundLayer": {
    "type": "blur",
    "blurStrength": 20
  },
  "videoSlot": {
    "x": 0.5,
    "y": 0.35,
    "w": 0.9,
    "h": 0.5,
    "rounded": 16
  },
  "textLayers": [
    {
      "id": "title",
      "defaultText": "عنوان الفيديو",
      "position": {
        "x": 0.5,
        "y": 0.15,
        "alignment": "topCenter"
      },
      "style": {
        "fontFamily": "Cairo",
        "fontSize": 28,
        "fontWeight": "bold",
        "color": "#FFFFFF",
        "backgroundColor": "#00000080",
        "padding": 8
      }
    }
  ],
  "stickerSlots": [],
  "stylePreset": "modern"
}
```

## نموذج بيانات المشروع (Project Data Model)

يتم حفظ كل مشروع كملف JSON في مجلد المستندات الخاص بالتطبيق.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["projectId", "sourceVideoPath", "selectedTemplateId"],
  "properties": {
    "projectId": {
      "type": "string",
      "format": "uuid"
    },
    "sourceVideoPath": {
      "type": "string",
      "description": "مسار الفيديو المصدر (local or temp)"
    },
    "sourceType": {
      "type": "string",
      "enum": ["local_file", "instagram_link"]
    },
    "selectedTemplateId": {
      "type": "string"
    },
    "textInstances": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["layerId", "text"],
        "properties": {
          "layerId": { "type": "string" },
          "text": { "type": "string" },
          "customStyle": { "type": "object" }
        }
      }
    },
    "stickerInstances": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["slotId", "asset", "keyframes"],
        "properties": {
          "slotId": { "type": "string" },
          "asset": { "type": "string" },
          "keyframes": {
            "type": "array",
            "items": {
              "type": "object",
              "required": ["timeMs", "x", "y"],
              "properties": {
                "timeMs": { "type": "integer", "description": "الزمن بالميلي ثانية" },
                "x": { "type": "number", "description": "الموقع الأفقي النسبي" },
                "y": { "type": "number", "description": "الموقع العمودي النسبي" },
                "scale": { "type": "number", "default": 1.0 },
                "rotation": { "type": "number", "default": 0 }
              }
            }
          }
        }
      }
    },
    "audioTracks": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["type", "path"],
        "properties": {
          "type": { "enum": ["original", "voiceover", "music"] },
          "path": { "type": "string" },
          "volume": { "type": "number", "minimum": 0, "maximum": 1, "default": 1.0 },
          "filters": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "type": { "enum": ["normalize", "fade_in", "fade_out", "lowpass", "highpass"] },
                "params": { "type": "object" }
              }
            }
          },
          "startTimeMs": { "type": "integer" },
          "endTimeMs": { "type": "integer" }
        }
      }
    },
    "filterConfig": {
      "type": "object",
      "properties": {
        "preset": { "type": "string" },
        "customFilters": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": { "type": "string" },
              "intensity": { "type": "number", "minimum": 0, "maximum": 1 }
            }
          }
        }
      }
    },
    "coverFrameMs": {
      "type": "integer",
      "description": "زمن إطار الغلاف بالميلي ثانية"
    },
    "createdAt": {
      "type": "string",
      "format": "date-time"
    },
    "updatedAt": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

## قواعد Offline-First

1. **جميع عمليات معالجة الفيديو تتم على الجهاز** باستخدام FFmpeg
2. **التخزين المحلي أولاً**: جميع المشاريع والقوالب تحفظ في `ApplicationDocumentsDirectory`
3. **الاتصال بالإنترنت فقط لـ**:
   - جلب فيديو من رابط إنستغرام (يتم تنزيله وحفظه محلياً)
4. **لا اعتماد على الخادم**: لا توجد calls لأي API خارجي للمعالجة
5. **الملفات المؤقتة**: تُدار ذاتياً وتُنظف عند التصدير أو إلغاء المشروع

## اتفاقيات البرمجة (Coding Conventions)

### 1. النماذج غير القابلة للتغيير (Immutable Models)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String projectId,
    required String sourceVideoPath,
    required String selectedTemplateId,
    @Default([]) List<TextInstance> textInstances,
    @Default([]) List<StickerInstance> stickerInstances,
    @Default([]) List<AudioTrack> audioTracks,
    FilterConfig? filterConfig,
    int? coverFrameMs,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, Object?> json) => _$ProjectFromJson(json);
}
```

### 2. إدارة الحالة مع Riverpod

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final projectProvider = StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  return ProjectNotifier();
});

class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier() : super(ProjectState.initial());
  
  // Methods for state manipulation
}
```

### 3. معالجة الأخطاء

```dart
try {
  await videoProcessor.process();
} on FFmpegException catch (e) {
  // Handle FFmpeg-specific errors
  logger.e('FFmpeg error: ${e.message}');
  throw VideoProcessingException('فشل معالجة الفيديو', e);
} catch (e) {
  logger.e('Unexpected error: $e');
  throw GenericException('حدث خطأ غير متوقع');
}
```

### 4. Linting

- استخدام `flutter_lints` كقاعدة
-禁止 `print()` في production (استخدم logger)
- تفضيل `const` constructors
- تفضيل `single quotes`

## استراتيجية التحقق (Verification Strategy)

للوكلاء الذين لا يملكون جهازاً فعلياً:

### 1. التحليل الثابت (Static Analysis)
```bash
flutter analyze --no-fatal-infos --no-fatal-warnings
```
يجب أن يمر بدون أخطاء.

### 2. اختبار الوحدة (Unit Tests)
```bash
flutter test
```
يجب أن تمر جميع الاختبارات.

### 3. بناء APK للتصحيح
```bash
flutter build apk --debug
```
يجب أن ينجح البناء.

### 4. التحقق من CI
- GitHub Actions يبني APK على كل push
- الـ Artifact يُرفع تلقائياً للتحقق

## خارطة الطريق (Roadmap)

### M1: البنية الأساسية (Current Task) ✅
- [x] مشروع Flutter أساسي
- [x] واجهة رئيسية بسيطة
- [x] docs/BLUEPRINT.md
- [x] CI/CD pipeline
- [x] اختبار widget أساسي

### M2: الاستيراد (Import)
- [ ] استيراد من ملف محلي
- [ ] جلب من رابط إنستغرام (online)
- [ ] تخزين الفيديو محلياً
- [ ] عرض معلومات الفيديو (مدة، دقة)

### M3: القوالب (Templates)
- [ ] نظام تحميل القوالب من JSON
- [ ] 10 قوالب أولية
- [ ] معاينة القالب
- [ ] تطبيق القالب على الفيديو

### M4: محرر النصوص (Text Editor)
- [ ] إضافة/تعديل النصوص
- [ ] دعم العربية والإنجليزية
- [ ] خطوط Cairo/Tajawal
- [ ] تخصيص الألوان والخلفيات

### M5: الملصقات والصوت (Stickers & Audio)
- [ ] مكتبة ملصقات
- [ ] نظام keyframes للحركة
- [ ] تسجيل voiceover
- [ ] إزالة الصوت الأصلي
- [ ] إضافة موسيقى خلفية
- [ ] فلاتر الصوت والتحكم بالمستويات

### M6: الفلاتر والتصدير (Filters & Export)
- [ ] فلاتر الواقعية للفيديوهات AI
- [ ] توليد غلاف تلقائي
- [ ] تصدير 1080x1920
- [ ] شريط تقدم المعالجة

### M7: التحسينات النهائية
- [ ] تحسين الأداء
- [ ] إدارة الذاكرة
- [ ] تنظيف الملفات المؤقتة
- [ ] اختبار شامل على أجهزة متعددة

---

## ملاحظات للوكلاء المستقبليين

1. **اقرأ هذا الملف دائماً قبل البدء بأي مهمة**
2. **لا تكسر قاعدة Offline-First أبداً**
3. **القوالب هي بيانات - لا تضع منطق القوالب في الكود**
4. **اختبر مع `flutter analyze` و `flutter test` قبل فتح PR**
5. **وثّق أي تبعية جديدة في وصف الـ PR**
