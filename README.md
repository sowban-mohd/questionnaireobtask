# 🎯 Hotspot Host Onboarding – Flutter Internship Assignment

A Flutter application implementing a **two-step onboarding flow** for Hotspot Host applicants.
This project includes API integration, media recording, Riverpod state management, and clean architecture.

---

## ✅ Features Implemented

---

# 🟦 1. Experience Type Selection Screen

## ✅ API Integration (Dio)

* Experiences fetched using Dio.
* Cards include:

  * Background image (`image_url`)
  * Title text
  * **Grayscale when unselected**, full color when selected.

## ✅ Multi-Selection

* Tap to select/deselect.
* Multiple cards supported.
* Selected experience IDs stored using **Riverpod**.

## ✅ Description Input

* Multi-line text field.
* **250-character limit**.
* Remaining characters indicator.
* Value stored in state.

## ✅ Next Button

* Logs full state.
* Navigates to **Onboarding Question Screen**.

---

# 🟩 2. Onboarding Question Screen

## ✅ Long Answer Input

* Multi-line text field.
* **600-character limit**.

## ✅ Audio Recording (audio_waveforms)

* Live waveform during recording.
* Cancel option.
* Delete option.
* Audio button automatically hides after recording.

## ✅ Video Recording (camera)

* Record videos inside app.
* Thumbnail generated using `video_thumbnail`.
* Duration extracted using `video_player`.
* Delete recorded video.
* Video button hides after recording.

## ✅ Dynamic Layout Adjustments

* Recording buttons disappear once assets exist.
* Keyboard-safe UI.

---

# 🔄 State Management – Riverpod

* All UI state handled via `Notifier` and providers.
* Predictable, reactive updates.
* No UI-level mutable state.

---

# 🌐 Networking – Dio

* Used for experience API calls.
* Full error handling.
* Logic isolated inside data layer.

---

# 🎨 UI / UX

* Clean modern layout.
* Matches Figma spacing/structure.
* Responsive.
* Keyboard-safe.

---

# 📦 Packages Used

| Feature          | Package          |
| ---------------- | ---------------- |
| API Requests     | dio              |
| State Management | flutter_riverpod |
| Audio Recording  | audio_waveforms  |
| Video Recording  | camera           |
| Video Thumbnail  | video_thumbnail  |
| Video Duration   | video_player     |

---

# ❌ Optional Features Not Implemented

* Audio playback
* Video playback
* Animations (card slide-to-top / next button width animation)

---

# ▶️ Running the Project

```
flutter pub get
flutter run
```

> Ensure microphone and camera permissions are enabled.
