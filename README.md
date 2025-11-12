# Hotspot Host Onboarding – Flutter Internship Assignment

A Flutter application implementing a two-step onboarding flow for Hotspot Host applicants. Includes API integration, media recording, Riverpod state management, and clean architecture.

---

## Required Features Implemented

### 1. Experience Type Selection Screen

**API Integration (Dio)**

* Fetches experiences from API
* Displays cards with:

  * Background image (image_url)
  * Grayscale when unselected, full color when selected

**Multi-Selection**

* Select/deselect cards on tap
* Supports multiple selections
* Selected IDs stored using Riverpod

**Description Input**

* Multi-line text field
* 250-character limit
* Remaining character indicator
* Value stored in Riverpod state

**Next Button**

* Logs complete state
* Enabled only when required fields are filled
* Navigates to Onboarding Question Screen

---

### 2. Onboarding Question Screen

**Long Answer Input**

* Multi-line text input
* 600-character limit

**Audio Recording**

* Audio recording using audio_waveforms
* Displays live waveform
* Cancel recording
* Delete recording

**Video Recording**

* Video recording using camera
* Delete recorded video

**State / UI Behavior**

* Recording buttons hidden once audio/video is available
* Keyboard-safe layout

---

## State Management – Riverpod

* All UI state managed with Notifier and Providers

## Networking – Dio

* Experience API integration
* Error handling
* Clean data layer separation

## UI/UX

* Clean, modern, responsive layout
* Matches Figma structure
* Keyboard-safe

---

## Brownie Point Features

* Audio playback
* Video thumbnail generation (video_thumbnail)
* Video duration extraction (video_player)
* Auto-hide audio button after recording
* Auto-hide video button after recording
* Dynamic layout adjustments based on recorded media
* Grayscale-to-color transition for experience cards
* Full clean architecture structure
* Strong input validation and button enablement logic

---

## Optional Features Not Implemented

* Video playback
* Minor UI animations such as card slide-up or expanding Next button
