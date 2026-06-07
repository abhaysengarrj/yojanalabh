# 📦 योजनालाभ — Google Play Store Package

This folder contains everything needed to publish YojanaLabh on Google Play Store.

---

## 📂 Folder Structure

```
playstore/
├── README.md                    ← THIS FILE — start here
├── aab/
│   └── YojanaLabh-v1.0.0.aab   ← ✅ Build file for Play Store (upload this)
├── apk/
│   └── YojanaLabh-v1.0.0.apk   ← ✅ Install directly on phone (for testing)
├── store_listing.md             ← ✅ Copy-paste for Play Console descriptions
├── privacy_policy.md            ← ✅ Ready-to-use privacy policy
├── release_notes.md             ← ✅ "What's new" text for first release
├── content_rating.md            ← ✅ IARC questionnaire answers
├── upload_instructions.md       ← ✅ Full 10-step guide with screens
├── screenshots/
│   └── screenshots_instructions.txt  ← How to capture 3 required screenshots
├── icons/
│   └── icon_generation_instructions.txt  ← How to make 512x512 icon
└── graphics/
    └── feature_graphic_instructions.txt  ← How to make 1024x500 banner
```

---

## ✅ Upload Checklist

### Required — you MUST do these:

- [ ] **STEP 1:** Open `upload_instructions.md` and follow STEP 1 to STEP 10
- [ ] **AAB to upload:** `aab/YojanaLabh-v1.0.0.aab` (23.5 MB)
- [ ] **App description:** Copy from `store_listing.md`
- [ ] **Privacy policy:** Copy from `privacy_policy.md` → paste on GitHub Pages
- [ ] **Content rating:** Answer as per `content_rating.md` → get 3+ rating
- [ ] **Screenshots:** Follow `screenshots/screenshots_instructions.txt` → capture 3 screenshots on phone
- [ ] **App icon:** Follow `icons/icon_generation_instructions.txt` → create 512x512 PNG
- [ ] **Feature graphic:** Follow `graphics/feature_graphic_instructions.txt` → create 1024x500 PNG

### After publishing on Play Store:
- [ ] Replace test AdMob ID in `AndroidManifest.xml` with real ID
- [ ] Build and upload updated AAB with real AdMob ID
- [ ] Share Play Store link with family & friends

---

## 📝 Quick Reference

| Item | Location | Format |
|------|----------|--------|
| Play Store file | `aab/YojanaLabh-v1.0.0.aab` | Android App Bundle |
| Testing file | `apk/YojanaLabh-v1.0.0.apk` | APK (22.4 MB) |
| Description | `store_listing.md` | Hindi + English |
| Privacy policy | `privacy_policy.md` | HTML-ready text |
| Version | 1.0.0 | Code: 1 |

---

## 🧪 Testing Before Upload

Install the APK on your phone:
```powershell
flutter run
```
Or copy `apk/YojanaLabh-v1.0.0.apk` to phone and tap to install.

---

## 📊 App Details

| Field | Value |
|-------|-------|
| **Name** | योजनालाभ |
| **Category** | Tools |
| **Price** | Free |
| **Ads** | Yes (AdMob banners) |
| **In-app purchases** | No |
| **Content rating** | 3+ (Everyone) |
| **Languages** | Hindi |
| **Schemes** | 22 central government schemes |

---

## 🚀 One-Click Build (if you modify the app)

After making changes, rebuild:
```powershell
cd C:\Users\abhay\AppData\Local\Temp\opencode\YojanaLabhFlutter
flutter build appbundle --release
```
Copy the new `.aab` to `playstore/aab/` and upload to Play Console.
