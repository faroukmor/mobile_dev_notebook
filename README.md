# smartnote

**smartnote** is a cross-platform note-taking app built with **Flutter**.
Create, edit, categorize, favorite, search, and delete notes locally in a SQLite database.

Interface in **French**. Runs on **Android, iOS, Windows, Linux, macOS, and Web**.

---

## 📦 Dependencies

SDK requirements:
- **Dart SDK**: `>=3.13.5 <4.0.0`
- **Flutter SDK**: `>=3.44.0`

### Install all libraries with one command (PowerShell)

```powershell
flutter pub add sqflite sqflite_common sqflite_common_ffi sqflite_common_ffi_web path shared_preferences http
```

Main packages used:
- `sqflite` — SQLite database
- `sqflite_common`, `sqflite_common_ffi`, `sqflite_common_ffi_web` — SQLite for desktop/web
- `path` — file paths
- `shared_preferences` — save app preferences
- `http` — HTTP client

---

## 📦 Imports used in the source

```dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    show databaseFactoryFfiWeb;
import 'db.dart';
import 'db_init.dart';
import 'editor_page.dart';
import 'note.dart';
```

---

## 🚀 Commands to run

```bash
# 1. Clone the project
git clone https://github.com/faroukmor/mobile_dev_notebook.git
cd mobile_dev_notebook

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Run on a specific platform
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d linux
flutter run -d macos
flutter run -d web-server --web-port=8080

# 5. Analyze, test, and format
flutter analyze
flutter test
flutter format lib/ test/
```

---

## 🗄️ Database

The app uses a local SQLite database (`notes.db`) with `sqflite`.
Initialization is split by platform:
- `lib/db_init_io.dart` — Windows, Linux, macOS
- `lib/db_init_web.dart` — Web
- `lib/db_init.dart` — exports the correct initializer

`main.dart` calls `initDb()` before `runApp()`.

---

## ▶️ Usage

- Tap **+** to create a note
- Tap a note to edit it; tap ⭐ to favorite or 🗑️ to delete
- Search by title at the top
- Filter by category chips (Toutes, Personnel, Études, Travail, Idées)
- Switch to **Favoris** tab for favorite notes
- Tap grid/list icon to change the view

---

## 🧪 Testing & analysis

```bash
flutter analyze
flutter test
```

---

Built with ❤️ using [Flutter](https://flutter.dev/).
