# smartnote

**smartnote** is a cross-platform note-taking application built with **Flutter**. It lets you create, edit, categorize, favorite, search, and delete notes, all stored locally in a SQLite database on the device.

The interface is in **French** and the app runs on **Android, iOS, Windows, Linux, macOS, and Web**.

## Table of contents

- [About the project](#about-the-project)
- ✨ [Features](#features)
- 📱 [Screens](#screens)
- 🏗️ [Architecture & project structure](#architecture--project-structure)
- 🛠️ [Tech stack & dependencies](#tech-stack--dependencies)
- 📦 [Imports used in the source](#imports-used-in-the-source)
- 🧩 [Requirements to run the project](#requirements-to-run-the-project)
- 🚀 [Getting started](#getting-started)
- 🗄️ [Database initialization per platform](#database-initialization-per-platform)
- ▶️ [Usage](#usage)
- 🧪 [Testing & analysis](#testing--analysis)
- 🤝 [Contributing](#contributing)
- 📄 [License](#license)

## About the project

smartnote is a lightweight, local-first notes app. There is no backend or cloud sync: everything is stored on the device in a SQLite database (`notes.db`) managed by the [`sqflite`](https://pub.dev/packages/sqflite) package. User preferences (such as the preferred notes view — list or grid) are persisted with [`shared_preferences`](https://pub.dev/packages/shared_preferences).

On first launch the database is created automatically and seeded with four default categories:

1. **Personnel** (Personal)
2. **Études** (Studies)
3. **Travail** (Work)
4. **Idées** (Ideas)

Each note stores a title, content, optional category, favorite flag, and an ISO-8601 creation timestamp. The home screen supports list and grid views, a live search by title, category filtering, a dedicated Favorites tab, and per-category quick filters.

The app is platform-aware: desktop targets (Windows, Linux, macOS) initialize SQLite through `sqflite_common_ffi`, while the web target uses `sqflite_common_ffi_web`. Mobile targets (Android/iOS) use the standard `sqflite` implementation.

## ✨ Features

- Create new notes with a title and content
- Edit existing notes in a dedicated editor page
- Delete notes with a confirmation dialog
- Mark notes as favorites (⭐) and view them in a dedicated Favorites tab
- Organize notes into categories (Personnel, Études, Travail, Idées, or None)
- Filter notes by category with ChoiceChip quick filters
- Search notes live by title
- Switch between list view and grid view; preference is saved locally
- Bottom navigation between **Notes** and **Favoris**
- Local-first SQLite database with automatic creation and migration-safe schema
- Cross-platform: Android, iOS, Windows, Linux, macOS, Web
- Material Design UI with `debugShowCheckedModeBanner` disabled

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Home** (`main.dart` → `Home`) | Notes list/grid, search bar, category chips, tab navigation (Notes / Favoris), floating action button to create a note, grid/list toggle |
| **Editor** (`editor_page.dart` → `EditorPage`) | Create or edit a note: title field, content field, category dropdown, favorite star, save and delete actions |

## 🏗️ Architecture & project structure

```
mobile_dev_notebook/
├── lib/
│   ├── main.dart            # App entry point, DB init, Home screen
│   ├── note.dart            # Note & Category data models (JSON/DB mapping)
│   ├── db.dart              # SQLite database helper (singleton, CRUD)
│   ├── db_init.dart         # Platform-aware database initializer (exports)
│   ├── db_init_io.dart      # Desktop DB init (sqflite_common_ffi)
│   └── db_init_web.dart     # Web DB init (sqflite_common_ffi_web)
├── test/
│   └── widget_test.dart     # Default Flutter widget test
├── android/                 # Android project
├── ios/                     # iOS project
├── linux/                   # Linux project
├── macos/                   # macOS project
├── web/                     # Web project
├── windows/                 # Windows project
├── pubspec.yaml             # Dart/Flutter dependencies
├── pubspec.lock             # Locked dependency versions
├── analysis_options.yaml    # Dart analyzer lint configuration
└── README.md
```

### Key classes

**`Note`** (`lib/note.dart`)
- `id?`, `title`, `content`, `categoryId?`, `favorite`, `createdAt` (ISO-8601)
- `toMap()` / `fromMap()` for SQLite row conversion

**`Category`** (`lib/note.dart`)
- `id`, `name`

**`DB`** (`lib/db.dart`)
- Singleton database helper
- `notes.db` with `categories` and `notes` tables
- Methods: `getCategories()`, `getNotes()`, `saveNote()`, `deleteNote()`, `toggleFavorite()`

**`Home`** (`lib/main.dart`)
- Stateful home screen with search, category filtering, favorites tab, list/grid toggle, and note cards

**`EditorPage`** (`lib/editor_page.dart`)
- Stateful editor for creating/editing notes with validation (title and content required)

## 🛠️ Tech stack & dependencies

All versions below come from `pubspec.yaml` / `pubspec.lock`.

### SDK requirements

| SDK | Version constraint |
|-----|--------------------|
| Dart SDK | `>=3.13.5 <4.0.0` |
| Flutter SDK | `>=3.44.0` |

### Direct dependencies (`dependencies` in `pubspec.yaml`)

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Flutter UI framework |
| `cupertino_icons` | `^1.0.8` | iOS-style icons |
| `sqflite` | `^2.4.6` | SQLite plugin for Flutter (mobile) |
| `sqflite_common` | `^2.5.17` | Common SQLite interfaces |
| `sqflite_common_ffi` | `^2.4.7` | SQLite FFI implementation (desktop) |
| `sqflite_common_ffi_web` | `^1.2.2` | SQLite FFI implementation (web) |
| `path` | `^1.9.1` | Path manipulation utilities |
| `shared_preferences` | `^2.5.6` | Persistent key-value storage |
| `http` | `^1.6.0` | HTTP client (declared dependency) |

> Note: The current source code imports `flutter`, `sqflite`/`sqflite_common`/`sqflite_common_ffi`/`sqflite_common_ffi_web`, `path`, and `shared_preferences`. The `http` and `cupertino_icons` packages are declared in `pubspec.yaml` but are not actively imported by the current Dart source files.

### Dev dependencies (`dev_dependencies` in `pubspec.yaml`)

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Flutter widget/unit testing |
| `flutter_lints` | `^6.0.0` | Recommended Flutter/Dart lint rules |

## 📦 Imports used in the source

If you are contributing or adding new files, these are the imports currently used across the project:

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

## 🧩 Requirements to run the project

To build and run smartnote you need a working Flutter development environment.

### 1. Flutter SDK

Install Flutter (stable channel) following the official guide:
https://docs.flutter.dev/get-started/install

Required version: **Flutter >= 3.44.0**, **Dart >= 3.13.5**.

Verify your installation:

```bash
flutter doctor
```

### 2. Platform-specific tooling (choose your target)

| Target | Required |
|--------|----------|
| Android | Android Studio with Android SDK / emulator, or a physical Android device |
| iOS | Xcode (macOS only) + iOS simulator or physical device |
| Windows | Visual Studio with C++ desktop development workload |
| Linux | C++ toolchain + required development libraries |
| macOS | Xcode |
| Web | Chrome (or any modern browser) + `flutter config --enable-web` |

### 3. Enable desired platforms

```bash
flutter config --enable-android   # optional, usually enabled by default
flutter config --enable-web
flutter config --enable-linux
flutter config --enable-macos
flutter config --enable-windows
```

Run `flutter doctor` again to confirm all selected platforms show no issues.


## 🚀 Getting started

### 1. Clone the repository

```bash
git clone https://github.com/faroukmor/mobile_dev_notebook.git
cd mobile_dev_notebook
```

### 2. Install dependencies

Fetch all Dart/Flutter packages declared in `pubspec.yaml`:

```bash
flutter pub get
```

### 3. Run the app

Choose a connected device or emulator, then:

```bash
flutter run
```

To target a specific platform:

```bash
# Android emulator / device
flutter run -d android

# Web (Chrome)
flutter run -d web-server --web-port=8080

# Windows / Linux / macOS desktop
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

### 4. Hot reload

While the app is running, press `r` in the terminal for hot reload, or `R` for hot restart.

## 🗄️ Database initialization per platform

Because SQLite FFI differs by platform, initialization is split into three files:

| File | Platforms | Mechanism |
|------|-----------|-----------|
| `lib/db_init_io.dart` | Windows, Linux, macOS | Calls `sqfliteFfiInit()` and sets `databaseFactory = databaseFactoryFfi` |
| `lib/db_init_web.dart` | Web | Sets `databaseFactory = databaseFactoryFfiWeb` |
| `lib/db_init.dart` | All (conditional export) | Exports the correct initializer using `dart.library.js_interop` / `dart.library.html` conditional imports |

`main.dart` calls `initDb()` before `runApp()`, so the database is ready before any screen is built. On first launch, `db.dart` creates the `categories` and `notes` tables and seeds the four default categories.

## ▶️ Usage

1. **Launch the app** — the database initializes automatically and the home screen appears.
2. **Create a note** — tap the floating action button (+) on the home screen, fill in the title and content, optionally pick a category, then tap **Enregistrer**.
3. **Edit a note** — tap any note card to open the editor; modify and save, or tap ⭐ to toggle favorite.
4. **Delete a note** — open the note in the editor and tap the trash icon, then confirm in the dialog.
5. **Search** — type in the **Rechercher par titre** field at the top; results filter live.
6. **Filter by category** — tap a category chip (Toutes, Personnel, Études, Travail, Idées) in the horizontal chip list.
7. **View favorites** — switch to the **Favoris** tab in the bottom navigation bar; tap ⭐ on a card to add/remove it.
8. **Toggle view** — tap the grid/list icon in the app bar to switch between `ListView` and `GridView`; your choice is saved locally.

## 🧪 Testing & analysis

Run the analyzer (linting + static analysis):

```bash
flutter analyze
```

Run the test suite:

```bash
flutter test
```

Format the code:

```bash
flutter format lib/ test/
```

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes and ensure `flutter analyze` and `flutter test` pass
4. Commit with a clear message
5. Open a pull request against `main`

Please follow the existing code style and the `flutter_lints` rules configured in `analysis_options.yaml`.

## 📄 License

This project is a Flutter sample/learning project. No license file is currently specified in the repository.

---

Built with ❤️ using [Flutter](https://flutter.dev/).