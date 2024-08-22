import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            time TEXT,
            label TEXT,
            backgroundColor INTEGER,
            isPinned BOOLEAN
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');


    List<Note> allNotes = List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });


    List<Note> pinnedNotes = [];
    List<Note> unpinnedNotes = [];

    for (var note in allNotes) {
      if (note.isPinned) {
        pinnedNotes.add(note);
      } else {
        unpinnedNotes.add(note);
      }
    }


    pinnedNotes.sort((a, b) => b.time.compareTo(a.time));


    return [...pinnedNotes, ...unpinnedNotes];
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNotes(List<int> ids) async {
    final db = await database;


    if (ids.isEmpty) return;


    final idsString = ids.join(',');

    await db.rawDelete(
      'DELETE FROM notes WHERE id IN ($idsString)',
    );
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'title LIKE ? OR description LIKE ? OR label LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}
