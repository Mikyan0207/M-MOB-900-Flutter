# Starlight

[![Codemagic build status](https://api.codemagic.io/apps/63483ea222ff8dd9f01474ca/63483ea222ff8dd9f01474c9/status_badge.svg)](https://codemagic.io/apps/63483ea222ff8dd9f01474ca/63483ea222ff8dd9f01474c9/latest_build)
[![CodeFactor](https://www.codefactor.io/repository/github/mikyan0207/m-mob-900-flutter/badge)](https://www.codefactor.io/repository/github/mikyan0207/m-mob-900-flutter)

An instant messaging application inspired from Discord and LINE written with Flutter.

## Packages

**Lists of packages used for the project.**

<br>

### any_link_preview: ^2.0.9
Dart package that helps with preview of any links. Fully customizable and has the ability to render from cached data. Useful for apps where we had chat feature.<br><br>
[Link](https://pub.dev/packages/any_link_preview)

<br>

### camera: ^0.10.0
A Flutter plugin for controlling the camera. Supports previewing the camera feed, capturing images and video, and streaming image buffers to Dart.
<br><br>
[Link](https://pub.dev/packages/camera)

<br>

### cloud_firestore: ^4.0.5
A Flutter plugin to use the Cloud Firestore API.
<br><br>
[Link](https://pub.dev/packages/cloud_firestore)

<br>

### context_menus: ^1.0.2
A package to show context menus on right-click or long-press.
<br><br>
[Link](https://pub.dev/packages/context_menus)

<br>

### cross_file_image: ^1.0.0
ImageProvider for XFile.
<br><br>
[Link](https://pub.dev/packages/cross_file_image)

<br>

### emojis: ^0.9.9
🔥 Emoji for Dart 🔥 Over 3300 Emojis
This 📦 contain all 🆕 Unicode 13.1 Emojis (2️⃣0️⃣2️⃣1️⃣) 💪 supports null safety 💪
<br><br>
[Link](https://pub.dev/packages/emojis)

<br>

### firebase_auth: ^4.1.0
A Flutter plugin to use the Firebase Authentication API.
<br><br>
[Link](https://pub.dev/packages/firebase_auth)

<br>

### firebase_core: ^2.1.1
A Flutter plugin to use the Firebase Core API, which enables connecting to multiple Firebase apps.
<br><br>
[Link](https://pub.dev/packages/firebase_core)

<br>

### firebase_crashlytics: ^3.0.5
A Flutter plugin to use the Firebase Crashlytics API.
<br><br>
[Link](https://pub.dev/packages/firebase_crashlytics)

<br>

### firebase_storage: ^11.0.3
A Flutter plugin to use the Firebase Cloud Storage API.
<br><br>
[Link](https://pub.dev/packages/firebase_storage)

<br>

### flutter_dropzone: ^3.0.5
A Flutter Web plugin to handle drag-and-drop (files) into Flutter. If you're interested in drag-and-drop inside a Flutter app, check out other packages like dnd.
<br><br>
[Link](https://pub.dev/packages/flutter_dropzone)

<br>

### flutter_parsed_text: ^2.2.1
A Flutter plugin for controlling the camera. Supports previewing the camera feed, capturing images and video, and streaming image buffers to Dart.
<br><br>
[Link](https://pub.dev/packages/flutter_parsed_text)

<br>

### flutter_parsed_text_field: ^0.1.10
A Flutter package to parse text and extract parts using predefined types like url, phone and email and also supports Regex.
<br><br>
[Link](https://pub.dev/packages/flutter_parsed_text_field)

<br>

### fluttertoast: ^8.1.1
Toast Library for Flutter.
<br><br>
[Link](https://pub.dev/packages/fluttertoast)

<br>

### get: ^4.6.5
GetX is an extra-light and powerful solution for Flutter.<br>
It combines high-performance state management, intelligent dependency injection, and route management quickly and practically.
<br><br>
[Link](https://pub.dev/packages/get)

<br>

### google_fonts: ^3.0.1
A Flutter package to use fonts from [fonts.google.com](fonts.google.com).<br>
HTTP fetching at runtime, ideal for development. Can also be used in production to reduce app size. Font file caching, on device file system. Font bundling in assets. Matching font files found in assets are prioritized over HTTP fetching. Useful for offline-first apps.
<br><br>
[Link](https://pub.dev/packages/google_fonts)

<br>

### image_cropper: ^3.0.0
A Flutter plugin for Android, iOS and Web supports cropping images. This plugin is based on three different native libraries so it comes with different UI between these platforms.
<br><br>
[Link](https://pub.dev/packages/image_cropper)

<br>

### image_picker: ^0.8.6
A Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera.
<br><br>
[Link](https://pub.dev/packages/image_picker)

<br>

### overlapping_panels: ^0.0.3
Add Discord-like navigation to your app.
<br><br>
[Link](https://pub.dev/packages/overlapping_panels)

<br>

### shared_preferences: ^2.0.15
Wraps platform-specific persistent storage for simple data (NSUserDefaults on iOS and macOS, SharedPreferences on Android, etc.). Data may be persisted to disk asynchronously, and there is no guarantee that writes will be persisted to disk after returning, so this plugin must not be used for storing critical data.
<br><br>
[Link](https://pub.dev/packages/shared_preferences)

<br>

### timeago_flutter: ^1.2.0
timeago is a dart library that converts a date into a humanized text. Instead of showing a date 2020-12-12 18:30 with timeago you can display something like "now", "an hour ago", "~1y", etc
<br><br>
[Link](https://pub.dev/packages/timeago_flutter)

<br>

### velocity_x: ^3.5.1
Flutter development
easier and more joyful than ever.<br>
Inspired from Tailwindcss and SwiftUI.
<br><br>
[Link](https://pub.dev/packages/velocity_x)

<br>

-----

### Blackfoot Flutter Lint
This package contains a recommended set of lints for Blackfoot's Flutter apps to encourage good coding practices.<br>
This package is built on top of Flutter `flutter.yaml` set of lints from `package:flutter_lints`.
<br><br>
[Link](https://pub.dev/packages/blackfoot_flutter_lint)

<br>

-----

## Download

### Web

### Android

### iOS

### Architecture

```
lib
├─┬ common
│ └─ constants
├─┬ domain
│ ├── controllers
│ ├── entities
│ └── respositories
└─┬ presentation
  ├── chats
  ├── friends
  ├── home
  ├── left_menu
  ├── picture
  ├── right_menu
  ├── sign_in
  ├── sign_up
  ├── splash
  ├── themes
  ├── user_info
  └─┬ widgets
    ├── channels
    ├── dialogs
    ├── groups
    ├── messages
    └── servers
```

<br>

-----

## Build

Flutter Version: `>= 3.2.2`<br>
We use a main only strategy with PRs for our repository.

<br>

Download and install the latest available version of Flutter from: [flutter.dev](https://docs.flutter.dev/get-started/install)

### Windows

### MacOS

### Linux

<br>

-----

## Deploy

### Desktop

### Web

### Mobile
