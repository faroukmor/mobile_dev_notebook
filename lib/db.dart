import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'note.dart';

class DB {
  static final DB instance = DB._();
  DB._();

  Future<Database>? _opening;

  Future<Database> get database => _opening ??= _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'notes.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            category_id INTEGER,
            is_favorite INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');
        for (final name in ['Personnel', 'Études', 'Travail', 'Idées']) {
          await db.insert('categories', {'name': name});
        }
      },
    );
  }

    Future<List<Category>> getCategories() async {
    final db = await database;
    final rows = await db.query('categories');
    return rows
        .map((row) => Category(id: row['id'] as int, name: row['name'] as String))
        .toList();
  }

  Future<List<Note>> getNotes({
    String search = '',
    int? categoryId,
    bool onlyFavorites = false,
  }) async {
    final db = await database;
    final conditions = <String>[];
    final values = <Object>[];

    if (search.isNotEmpty) {
      conditions.add('title LIKE ?');
      values.add('%$search%');
    }
    if (categoryId != null) {
      conditions.add('category_id = ?');
      values.add(categoryId);
    }
    if (onlyFavorites) {
      conditions.add('is_favorite = 1');
    }

    final rows = await db.query(
      'notes',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: values.isEmpty ? null : values,
      orderBy: 'id DESC',
    );
    return rows.map((row) => Note.fromMap(row)).toList();
  }

  Future<void> saveNote(Note note) async {
    final db = await database;
    if (note.id == null) {
      final data = note.toMap();
      data.remove('id');
      await db.insert('notes', data);
    } else {
      await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    }
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> toggleFavorite(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      {'is_favorite': note.favorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}