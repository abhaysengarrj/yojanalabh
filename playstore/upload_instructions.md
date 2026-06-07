# Play Store Upload — Complete Step-by-Step Guide

---

## Prerequisites
- [ ] **Google Play Developer account** — pay ₹1,500 at https://play.google.com/console/signup
- [ ] **AdMob account** — at https://apps.admob.com (need to sign up if you don't have)
- [ ] **Real AdMob App ID** — get from AdMob, replace in `AndroidManifest.xml`
- [ ] **3 phone screenshots** — follow `screenshots/screenshots_instructions.txt`
- [ ] **Feature graphic** — 1024x500 PNG (follow `graphics/feature_graphic_instructions.txt`)

---

## Step 1: Build Release Bundle

Open PowerShell:
```powershell
cd C:\Users\abhay\AppData\Local\Temp\opencode\YojanaLabhFlutter
flutter build appbundle --release
```
This creates: `build/app/outputs/bundle/release/app-release.aab`

---

## Step 2: Create App on Play Console

1. Go to https://play.google.com/console
2. Click **"Create app"**
3. Fill:

| Field | Value |
|-------|-------|
| Name | `योजनालाभ` |
| Default language | Hindi (हिन्दी) |
| App or game | App |
| Free or paid | Free |
| Declare ads | Check this (AdMob) |

4. Click **"Create app"**

---

## Step 3: Fill Store Listing

Go to **"Store presence" → "Main store listing"**

### Upload these files:
| Section | File |
|---------|------|
| App icon | `playstore/icons/` — upload your 512x512 PNG |
| Feature graphic | `playstore/graphics/` — upload your 1024x500 PNG |
| Phone screenshots | `playstore/screenshots/` — upload 3 screenshots |
| Tablet screenshots | Optional — skip |

### Fill text fields:
| Field | Copy from |
|-------|-----------|
| App name | `playstore/store_listing.md` → "App Name" |
| Short description | `playstore/store_listing.md` → "Short Description" |
| Full description | `playstore/store_listing.md` → "Full Description" |

### Set category:
- App category: **Tools**
- Tags: `government schemes`, `sarkari yojana`, `eligibility check`

### Contact details:
- Email: your email
- Website: `https://github.com/abhaysengarrj/yojanalabh`
- Phone: (optional, leave blank)

---

## Step 4: Privacy Policy

Go to **"App content" → "Privacy Policy"**

1. Select **"Submit a privacy policy URL"**
2. Option A (free): Create a GitHub Pages privacy page
   - Create a file `privacy.md` in your repo
   - Use raw file URL or GitHub Pages
3. Option B (easiest): Use the text from `playstore/privacy_policy.md` and paste it into a free privacy policy generator:
   - https://privacypolicygenerator.info
   - Or just paste the raw markdown content as your policy
4. Paste the URL and click **"Save"**

---

## Step 5: Content Rating

Go to **"App content" → "Content ratings"**

1. Fill the IARC questionnaire as per `playstore/content_rating.md`
2. Submit → Get rating: **3+** (Everyone)

---

## Step 6: App Access

Go to **"App content" → "App access"**

1. Select **"All or some features are locked"** — or the appropriate option
2. Actually: select **"All features are available without any special access"**
   - Reason: All functionality works without login/account
3. Click **"Save"**

---

## Step 7: Ads Declaration

Go to **"App content" → "Ads"**

1. Select **"Yes, my app contains ads"**
2. Ad type: **Banner ads**
3. Click **"Save"**

---

## Step 8: Set Up Production Release

Go to **"Production"** under Release

1. Click **"Create new release"**
2. **"Upload"** → drag-drop `app-release.aab`
3. **"Release name"** → `1.0.0`
4. **"Release notes"** → paste from `playstore/release_notes.md`
5. Click **"Next"** → **"Review release"**

---

## Step 9: Rollout

1. Review all details carefully
2. Click **"Start rollout to Production"**
3. Confirm

---

## Step 10: Wait

- Review by Google: **2-48 hours**
- App goes live after approval
- You'll get an email notification

---

## Post-Launch Checklist

- [ ] Download app from Play Store on your phone
- [ ] Test all features
- [ ] Check AdMob shows test ads (replace with real AdMob ID first)
- [ ] Check the auto-update works (GitHub Actions runs weekly)
- [ ] Share the Play Store link with family/friends

## Future Updates

1. Make changes in `C:\Users\abhay\AppData\Local\Temp\opencode\YojanaLabhFlutter`
2. Test with `flutter run`
3. Build: `flutter build appbundle --release`
4. Go to Play Console → Production → Create new release
5. Upload new `.aab` → increase version in `pubspec.yaml` (e.g., 1.0.1)
