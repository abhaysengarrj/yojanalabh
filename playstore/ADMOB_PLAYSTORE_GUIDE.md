# योजनालाभ — Complete AdMob + Play Store Upload Guide

> **Read this entire guide before starting.** Follow each step in order.

---

## PART 1: AdMob Setup (Get App ID)

### Step 1.1 — Create AdMob Account
1. Open **https://apps.admob.com** in Chrome
2. Sign in with your **Google account** (same one you'll use for Play Store)
3. Click **"Sign up"** → fill country (India) → Accept terms
4. You'll land on the AdMob dashboard

### Step 1.2 — Add Your App
1. Click the **"Apps"** tab on the left sidebar
2. Click the **"Add App"** button (blue button, top-right)
3. A dialog appears:

```
┌─────────────────────────────────────┐
│         Add app to AdMob            │
│                                     │
│  ○ Android  ○ iOS  ○ Unity          │
│                                     │
│  [Select Android]                    │
│                                     │
│  App name: [योजनालाभ______________] │
│                                     │
│  Is your app on Google Play?        │
│  ○ Yes  ● No (we'll add it later)   │
│                                     │
│  [ADD APP]                          │
└─────────────────────────────────────┘
```

4. Select **Android** → App name: `योजनालाभ`
5. Select **"No, my app is not on Google Play yet"**
6. Click **"ADD"**

### Step 1.3 — Get Your App ID
1. After adding, you'll see a screen with:

```
┌─────────────────────────────────────┐
│  App added successfully!            │
│                                     │
│  Your App ID:                       │
│  ca-app-pub-1234567890123456~987... │
│                                     │
│  [COPY]                             │
│                                     │
│  Next: Create ad unit               │
└─────────────────────────────────────┘
```

2. **Copy the App ID** (it starts with `ca-app-pub-`)
3. Save it in Notepad — you'll need it now

### Step 1.4 — Replace App ID in AndroidManifest.xml

Open file:
```
C:\Users\abhay\AppData\Local\Temp\opencode\YojanaLabhFlutter\android\app\src\main\AndroidManifest.xml
```

**Find line 22** (current test ID):
```xml
android:value="ca-app-pub-3940256099942544~3347511713"
```

**Replace with YOUR real App ID:**
```xml
android:value="ca-app-pub-1234567890123456~9876543210"
```

> ⚠️ Keep the test ID for now if you want to test. Replace it RIGHT BEFORE uploading to Play Store.

### Step 1.5 — Create Ad Unit (Banner)
1. In AdMob, after adding app, click **"Create ad unit"**
2. Select **"Banner"**
3. Ad unit name: `banner_home`
4. Click **"Create"**
5. You'll get an **Ad Unit ID** like: `ca-app-pub-1234567890123456/1234567890`
6. Save this too (for future use when you add banners to screens)

> **For now, you don't need to add the banner to code.** The app already has AdMob initialized in `main.dart`. Banners can be added later.

---

## PART 2: Google Play Console — Account Creation

### Step 2.1 — Create Developer Account
1. Open **https://play.google.com/console/signup** in Chrome
2. Sign in with your **Google account**
3. You'll see:

```
┌──────────────────────────────────────────┐
│  Create your Google Play Developer acct  │
│                                          │
│  One-time registration fee: ₹1,500       │
│  (non-refundable)                        │
│                                          │
│  Developer name: [abhaysengarrj________] │
│  Email: [your-email@gmail.com_________]  │
│  Contact phone: [optional______________] │
│                                          │
│  □ I agree to the Google Play Developer  │
│    Distribution Agreement                │
│                                          │
│  [PAY ₹1,500 & CREATE]                   │
└──────────────────────────────────────────┘
```

4. Fill details → Check terms → Click **"PAY ₹1,500 & CREATE"**
5. Enter your card details → Pay
6. **Wait 10-30 minutes** for account activation

---

## PART 3: Google Play Console — Create & Upload App

### Step 3.1 — Create App Entry
1. Go to **https://play.google.com/console**
2. Click **"Create app"** (blue button, top-right)

```
┌──────────────────────────────────────────┐
│  Create app                              │
│                                          │
│  Name: [योजनालाभ____________________]    │
│                                          │
│  Default language: [हिन्दी (हिंदी) ▼]    │
│                                          │
│  App or game: ● App  ○ Game              │
│                                          │
│  Free or paid: ● Free  ○ Paid            │
│                                          │
│  □ This app has ads *(CHECK THIS)*       │
│                                          │
│  [CREATE]                                │
└──────────────────────────────────────────┘
```

3. Fill:
   - Name: `योजनालाभ`
   - Language: **हिन्दी (हिंदी)**
   - App/Game: **App**
   - Free/Paid: **Free**
   - ✅ **Check "This app has ads"**

4. Click **"Create app"**

### Step 3.2 — Fill Store Listing

In the left sidebar, navigate to:
**Store presence → Main store listing**

#### Upload Graphics (top section):

| Section | Action |
|---------|--------|
| **App icon** | Click "Upload" → select your 512x512 PNG icon |
| **Feature graphic** | Click "Upload" → select your 1024x500 PNG banner |
| **Phone screenshots** | Click "Upload" → select 3 screenshots (min 1080x1920) |
| **Tablet screenshots** | Skip (optional) |

#### Fill Text Fields:

**App name (50 chars max):**
```
योजनालाभ - जानें कौन सी सरकारी योजना आपके लिए है
```

**Short description (80 chars max):**
```
30 सेकंड में जानें कौन सी सरकारी योजनाएं आपके लिए पात्र हैं
```

**Full description:**
```
योजनालाभ एक मुफ्त हिंदी ऐप है जो आपको बताता है कि कौन सी सरकारी योजनाएं आपके लिए उपयुक्त हैं। अब आपको योजनाओं की लंबी लिस्ट में खोजने की जरूरत नहीं — बस अपनी जानकारी दर्ज करें और 30 सेकंड में जानें अपनी पात्रता।

मुख्य विशेषताएं:
• 30 सेकंड में पात्रता जांच — बस उम्र, आय, व्यवसाय और राज्य दर्ज करें
• 22+ सरकारी योजनाओं का डेटा — केंद्र और राज्य योजनाएं
• पूरी तरह हिंदी में — सरल हिंदी भाषा में पूरा ऐप
• ऑफलाइन काम करता है — एक बार डेटा डाउनलोड करने के बाद इंटरनेट की जरूरत नहीं
• बिल्कुल मुफ्त — कोई शुल्क नहीं, कोई छिपी कीमत नहीं
• नियमित अपडेट — नई योजनाएं अपने आप आ जाती हैं
• डार्क मोड — रात में आंखों की सुरक्षा के लिए
• पसंदीदा योजनाएं — महत्वपूर्ण योजनाओं को सेव करें
• साझा करें — अपने परिवार और दोस्तों के साथ योजनाएं साझा करें

कवर की गई योजनाओं के प्रकार:
• किसान योजनाएं (पीएम-किसान, फसल बीमा)
• आवास योजनाएं (पीएम आवास योजना, पीएम सूर्य घर)
• महिला योजनाएं (उज्ज्वला, मातृ वंदना, सुकन्या समृद्धि, लखपति दीदी)
• पेंशन योजनाएं (अटल पेंशन, श्रम योगी मानधन)
• शिक्षा योजनाएं (विद्या लक्ष्मी)
• स्वास्थ्य योजनाएं (जन औषधि)
• रोजगार योजनाएं (मनरेगा, स्वनिधि, डीडीयूजीकेवाई, पीएम विश्वकर्मा)
• वित्तीय योजनाएं (पीएम जन धन)

नोट: यह ऐप किसी सरकारी विभाग द्वारा नहीं बनाया गया है।
```

#### Categorization:

| Field | Value |
|-------|-------|
| **App category** | **Tools** |
| **Tags** | Type: `government schemes` → Enter → Type: `sarkari yojana` → Enter → Type: `eligibility check` → Enter |

#### Contact Details:

| Field | Value |
|-------|-------|
| **Email** | `abhaysengarrj@gmail.com` (or your email) |
| **Phone** | Leave blank |
| **Website** | `https://github.com/abhaysengarrj/yojanalabh` |

#### Scroll down → Click **"Save"** (top-right)

---

## PART 4: App Content Sections

### 4.1 — Privacy Policy
1. Left sidebar → **"App content"** → **"Privacy policy"**
2. Click **"Manage"** → Select **"Submit a privacy policy URL"**

**Option A — Use GitHub RAW URL (free, easiest):**
- Open `playstore/privacy_policy.md` from your project
- Copy all text → go to **https://gist.github.com**
- Paste → Create a **secret gist** → Click **"Create gist"**
- Click **"Raw"** button → Copy that URL
- Paste URL in Play Console

**Option B — Use GitHub repo file:**
- URL: `https://raw.githubusercontent.com/abhaysengarrj/yojanalabh/main/playstore/privacy_policy.md`
- Copy and paste it

**Option C — Use a free generator:**
- Go to https://privacypolicygenerator.info
- App name: `योजनालाभ`
- Publisher: `Abhay Singh`
- Website: `https://github.com/abhaysengarrj/yojanalabh`
- Click Generate → Copy the URL

3. Paste URL → Click **"Save"**

### 4.2 — App Access
1. **"App content" → "App access"**
2. Click **"Manage"**
3. Select: **"All features are available without any special access"**
4. Reason: *"No login, no account, no payment required. All features work immediately on install."*
5. Click **"Save"**

### 4.3 — Ads Declaration
1. **"App content" → "Ads"**
2. Click **"Manage"**
3. Select: **"Yes, my app contains ads"**
4. Ad type: **"Banner ads"**
5. Click **"Save"**

### 4.4 — Content Ratings
1. **"App content" → "Content ratings"**
2. Click **"Continue"** → **"Get questionnaire"**

Fill answers:

| Question | Answer |
|----------|--------|
| **Does your app contain violence?** | **No** |
| **Does your app contain sexual content?** | **No** |
| **Does your app contain hate speech?** | **No** |
| **Does your app contain alcohol/tobacco/drugs?** | **No** |
| **Does your app contain gambling?** | **No** |
| **Does your app allow user interaction?** | **No** |
| **Does your app share location?** | **No** |
| **Does your app have in-app purchases?** | **No** (future remove-ads doesn't count) |

3. Click **"Submit"** → Result: **3+ (Everyone)**
4. Click **"Save"**

### 4.5 — Target Audience
1. **"App content" → "Target audience"**
2. Click **"Manage"**
3. Select: **"All age groups"**
4. Click **"Save"**

---

## PART 5: Upload the App (Production Release)

### Step 5.1 — Navigate to Production
1. Left sidebar → **"Production"** (under "Release")
2. Click **"Create new release"**

### Step 5.2 — Upload AAB
1. Under **"App bundles and APKs"** → Click **"Upload"**
2. Select: `C:\Users\abhay\AppData\Local\Temp\opencode\YojanaLabhFlutter\playstore\aab\YojanaLabh-v1.0.0.aab`
3. Wait for upload to finish (green checkmark appears)

### Step 5.3 — Fill Release Details
1. **"Release name"**: `1.0.0`
2. **"Release notes"** — Click language Hindi → Paste:
   ```
   पहला संस्करण:
   • 22 सरकारी योजनाओं की पात्रता जांच
   • पूरी तरह हिंदी में
   • ऑफलाइन काम करता है
   • डार्क मोड
   • पसंदीदा योजनाएं
   • ब्राउज़ और खोजें
   ```
3. Click **"Save"**

### Step 5.4 — Review
1. Click **"Review release"**
2. Google will check your AAB:
   - ✅ No issues found (should show green)
3. Scroll down → **"Start rollout to Production"**
4. Confirm dialog → Click **"Confirm"**

---

## PART 6: What Happens Next

### Timing:
| Event | Time |
|-------|------|
| **Google review starts** | Within 2 hours |
| **App goes live** | 2-48 hours (usually within 24 hrs) |
| **You get email** | When approved or rejected |

### If Rejected (common reasons & fixes):
| Reason | Fix |
|--------|-----|
| "App is too simple" | Add more features (already done - browse, search, favorites, dark mode) |
| "Privacy policy missing" | Make sure privacy policy URL is accessible |
| "Ads policy violation" | Make sure you declared ads |
| "Content rating not submitted" | Complete the IARC questionnaire |

### After Approval:
1. **Search** "योजनालाभ" on Play Store
2. **Install** on your phone
3. **Verify** AdMob shows real ads (not test ads)
4. **Share** the Play Store link with family and friends

---

## PART 7: Replace Test AdMob ID (CRITICAL)

**Your APK currently has a TEST AdMob ID.** It works for testing but won't show real ads.

### Before uploading updated version:
1. Go to **`AndroidManifest.xml`**
2. Replace test ID:
   ```
   ca-app-pub-3940256099942544~3347511713
   ```
   with your real ID:
   ```
   ca-app-pub-XXXXXXXXXXXX~XXXXXXXXXX
   ```
3. Rebuild:
   ```powershell
   cd C:\Users\abhay\AppData\Local\Temp\opencode\YojanaLabhFlutter
   flutter build appbundle --release
   ```
4. Upload new `.aab` to Play Console → Production → Create new release

---

## PART 8: Future Updates

### When you want to update:
1. `cd C:\Users\abhay\AppData\Local\Temp\opencode\YojanaLabhFlutter`
2. Make changes to code
3. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1  →  version: 1.0.1+2
   ```
   (First number = version shown to users. Second = internal build number. Always increment both.)
4. `flutter build appbundle --release`
5. Play Console → Production → Create new release
6. Upload new `.aab` → Fill release notes → Save → Rollout

---

## Quick Reference — Screenshots You Need

Take these 3 screenshots from your phone after installing the APK:

| # | Screen | How to capture |
|---|--------|----------------|
| 1 | **Profile form** | Open app → fill age 30, income ₹2,00,000, occupation किसान, state उत्तर प्रदेश → screenshot |
| 2 | **Results screen** | Tap "जांचें" → wait for results → scroll so 3-4 cards visible → screenshot |
| 3 | **Scheme detail** | Tap any green scheme → show the circular progress + description → screenshot |

**Screenshot size requirement:** 1080x1920 pixels minimum (most phones take this by default)

---

## Files You Already Have Ready

| File | Location | Status |
|------|----------|--------|
| AAB to upload | `playstore/aab/YojanaLabh-v1.0.0.aab` | ✅ Ready |
| APK for testing | `playstore/apk/YojanaLabh-v1.0.0.apk` | ✅ Ready |
| Store description | `playstore/store_listing.md` | ✅ Ready |
| Privacy policy | `playstore/privacy_policy.md` | ✅ Ready |
| Release notes | `playstore/release_notes.md` | ✅ Ready |
| Content rating | `playstore/content_rating.md` | ✅ Ready |
| Upload guide | `playstore/upload_instructions.md` | ✅ Ready |
| This detailed guide | `playstore/ADMOB_PLAYSTORE_GUIDE.md` | ✅ You're reading it |

---

> **Questions?** Open an issue at https://github.com/abhaysengarrj/yojanalabh/issues
