# LifeTrack – Development Environment Setup

This document defines the required toolchain and build steps to ensure
LifeTrack builds consistently across machines.

---

# 1. Required Toolchain Versions

## Java

Required version:
Java 21 (LTS)

Do NOT use Java 22+ or Java 25.
Gradle and Kotlin may fail with:
IllegalArgumentException: 25

Recommended source:
Android Studio bundled JBR (Java 21)

Path on macOS:
`/Applications/Android Studio.app/Contents/jbr/Contents/Home`

Verify:
java -version
Must report:
21.x.x

---

## Flutter

Recommended version:
Flutter 3.19.x (stable channel)

Check version:
flutter --version

If different:
flutter upgrade
or
flutter downgrade 3.19.x

---

## Android SDK

Minimum components:

- Android SDK Platform 34
- Build-Tools 34.0.0
- Android command-line tools ≥ 20.0
- Android NDK 27.0.12077973

---

## Android Command-line Tools

Required:
cmdline-tools;20.0 or newer

Check version:
/Users/<your-user>/Library/Android/sdk/cmdline-tools/latest/bin/sdkmanager --version

If outdated:
sdkmanager "cmdline-tools;20.0"

---

## Android NDK

Required version:
27.0.12077973

Verify:
ls $ANDROID_HOME/ndk/27.0.12077973/build/cmake/android.toolchain.cmake

If missing:
sdkmanager "ndk;27.0.12077973"

If sdkmanager fails:
Download manually from:
https://developer.android.com/ndk/downloads

Extract to:
$ANDROID_HOME/ndk/27.0.12077973

---

# 2. Lock Java for Android Builds

Add to:

android/gradle.properties

org.gradle.java.home=/Applications/Android Studio.app/Contents/jbr/Contents/Home

This forces Gradle to use Java 21.

Without this, Android builds may fail under newer system JDKs.

---

# 3. Initial Project Setup

Clone repo:

git clone https://github.com/fallofpheonix/LifeTrack.git
cd LifeTrack

Install dependencies:

flutter clean
flutter pub get

Check environment:

flutter doctor -v

All checks must be green.

---

# 4. Build Commands

## iOS Debug

flutter build ios --debug --no-codesign

## Android Debug

flutter build apk --debug

Output:
build/app/outputs/flutter-apk/app-debug.apk

---

# 5. Android Release Build

Make sure:

- Java 21 is active
- NDK 27.0.12077973 installed
- cmdline-tools ≥ 20.0

Then run:

flutter clean
flutter pub get
flutter build apk --release

Release output:
build/app/outputs/flutter-apk/app-release.apk

For Play Store:

flutter build appbundle --release

Output:
build/app/outputs/bundle/release/app-release.aab

---

# 6. If Android Build Fails

Common causes:

Java 22+ or Java 25 active
NDK missing or incomplete
Outdated cmdline-tools
Corrupted Gradle cache

Fix sequence:

flutter clean
rm -rf ~/.gradle/caches
flutter pub get
flutter build apk --debug

If still failing:
Reinstall NDK 27.0.12077973 manually.

---

# 7. Verified Platforms

LifeTrack builds on:

- macOS
- Android
- iOS
- Web

Android requires strict toolchain control.
iOS works out of the box (no NDK dependency).

---

# 8. Recommended Improvement

For long-term stability:

- Add CI pipeline to build Android + iOS on push
- Pin Flutter version using FVM
- Lock Gradle plugin version explicitly
