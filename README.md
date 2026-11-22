# smartnote

**smartnote** is a cross-platform note-taking app built with **Flutter**.
You can create, edit, categorize, favorite, search, and delete notes.
Everything is stored locally on the device in a SQLite database.

The app interface is in **French** and runs on **Android, iOS, Windows, Linux, macOS, and Web**.

---

## 📋 Table of contents

- [About the project](#about-the-project)
- [✨ Features](#features)
- [📦 Dependencies](#dependencies)
- [📦 Imports used in the source](#imports-used-in-the-source)
- [🧩 Requirements to run](#requirements-to-run)
- [🚀 Commands to run](#commands-to-run)
- [🗄️ Database initialization](#database-initialization)
- [▶️ Usage](#usage)
- [🧪 Testing & analysis](#testing--analysis)
- [🤝 Contributing](#contributing)
- [📄 License](#license)

---

## About the project

smartnote is a lightweight, local-first notes app. There is no backend and no cloud sync.
All data is saved on the device in a SQLite database (`notes.db`) using the `sqflite` package.
User preferences (for example, list or grid view) are saved with `shared_preferences`.

On first launch, the database is created automatically and seeded with four default categories:

1. **Personnel** (Personal)
2. **Études** (Studies)
3. **Travail** (Work)
4. **Idées** (Ideas)

Each note stores: title, content, optional category, favorite flag, and an ISO-8601 creation date.

The app is platform-aware:
- **Desktop** (Windows, Linux, macOS): uses `sqflite_common_ffi`
- **Web**: uses `sqflite_common_ffi_web`
- **Mobile** (Android, iOS): uses the standard `sqflite`

---

## ✨ Features

- Create notes with title and content
- Edit existing notes
- Delete notes with confirmation
- Mark notes as favorite (⭐) and view them in the Favorites tab
- Organize notes into categories (Personnel, Études, Travail, Idées, or None)
- Filter notes by category using choice chips
- Search notes live by title
- Switch between list view and grid view (preference saved locally)
- Bottom navigation: Notes / Favoris
- Material Design UI (debug banner disabled)

---

## 📦 Dependencies

All versions come from `pubspec.yaml` / `pubspec.lock`.

### SDK requirements

| SDK | Version |
|-----|---------|
| Dart SDK | `>=3.13.5 <4.0.0` |
| Flutter SDK | `>=3.44.0` |

### Direct dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Flutter UI framework |
| `cupertino_icons` | `^1.0.8` | iOS-style icons |
| `sqflite` | `^2.4.6` | SQLite plugin (mobile) |
| `sqflite_common` | `^2.5.17` | Common SQLite interfaces |
| `sqflite_common_ffi` | `^2.4.7` | SQLite FFI (desktop) |
| `sqflite_common_ffi_web` | `^1.2.2` | SQLite FFI (web) |
| `path` | `^1.9.1` | Path utilities |
| `shared_preferences` | `^2.5.6` | Persistent key-value storage |
| `http` | `^1.6.0` | HTTP client (declared) |

### Dev dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Flutter testing |
| `flutter_lints` | `^6.0.0` | Lint rules |

---

## 📦 Imports used in the source

These are the imports used across the project files:

```dart
// Flutter framework
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Persistence
import 'package:shared_preferences/shared_preferences.dart';

// SQLite
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    show databaseFactoryFfiWeb;

// Local project files
import 'db.dart';
import 'db_init.dart';
import 'editor_page.dart';
import 'note.dart';
```


## 🧩 Requirements to run

To build and run smartnote you need a Flutter development environment.

### 1. Flutter SDK

Install Flutter (stable channel):
https://docs.flutter.dev/get-started/install

Required versions:
- **Flutter >= 3.44.0**
- **Dart >= 3.13.5**

Verify installation:

```bash
flutter doctor
```

### 2. Platform tooling

| Target | Required |
|--------|----------|
| Android | Android Studio + SDK/emulator, or physical device |
| iOS | Xcode (macOS) + simulator or physical device |
| Windows | Visual Studio with C++ desktop workload |
| Linux | C++ toolchain + development libraries |
| macOS | Xcode |
| Web | Chrome + `flutter config --enable-web` |

---

## 🚀 Commands to run

Run these commands in the project root folder:

### Clone the repository

```bash
git clone https://github.com/faroukmor/mobile_dev_notebook.git
cd mobile_dev_notebook
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Run for a specific platform

```bash
# Android
flutter run -d android

# Web (Chrome)
flutter run -d web-server --web-port=8080

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# macOS
flutter run -d macos
```

### Analyze code

```bash
flutter analyze
```

### Run tests

```bash
flutter test
```

### Format code

```bash
flutter format lib/ test/
```

### Enable platforms (if needed)

```bash
flutter config --enable-android
flutter config --enable-web
flutter config --enable-linux
flutter config --enable-macos
flutter config --enable-windows
```

---

## 🗄️ Database initialization per platform

Because SQLite FFI differs by platform, initialization is split into three files:

| File | Platforms | What it does |
|------|-----------|--------------|
| `lib/db_init_io.dart` | Windows, Linux, macOS | Calls `sqfliteFfiInit()` and sets `databaseFactory = databaseFactoryFfi` |
| `lib/db_init_web.dart` | Web | Sets `databaseFactory = databaseFactoryFfiWeb` |
| `lib/db_init.dart` | All | Exports the correct initializer using conditional imports |

`main.dart` calls `initDb()` before `runApp()`, so the database is ready before any screen is shown.

---

## ▶️ Usage

1. Launch the app — the database initializes automatically.
2. Tap **+** (floating action button) to create a note. Enter title and content, choose a category, then tap **Enregistrer**.
3. Tap a note card to edit it. Tap ⭐ to toggle favorite, or the trash icon to delete.
4. Use **Rechercher par titre** at the top to search live.
5. Tap a category chip (Toutes, Personnel, Études, Travail, Idées) to filter.
6. Switch to the **Favoris** tab in the bottom navigation to see favorite notes.
7. Tap the grid/list icon in the app bar to change the view. Your choice is saved locally.

---

## 🧪 Testing & analysis

```bash
flutter analyze
flutter test
flutter format lib/ test/
```

---

## 🤝 Contributing

1. Fork the repository
2. Create a branch: `git checkout -b feature/your-feature`
3. Make changes and run `flutter analyze` and `flutter test`
4. Commit and open a pull request against `main`

Follow the code style and `flutter_lints` rules in `analysis_options.yaml`.

---

## 📄 License

This is a Flutter sample/learning project. No license file is currently specified.

---

Built with ❤️ using [Flutter](https://flutter.dev/).
