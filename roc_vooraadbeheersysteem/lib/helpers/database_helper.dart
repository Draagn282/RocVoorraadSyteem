import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'sessions.db');
    print("Database path: $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sessionName TEXT,
  totalTime INTEGER,
  createdAt INTEGER
)
''');

    await db.execute('''
CREATE TABLE programs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sessionId INTEGER,
  name TEXT,
  duration INTEGER,
  FOREIGN KEY (sessionId) REFERENCES sessions (id)
)
''');

    await db.execute('''
CREATE TABLE program_executions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  programId INTEGER,
  value INTEGER,
  timestamp INTEGER,
  FOREIGN KEY (programId) REFERENCES programs (id)
)
''');
  }

  Future<int> insertSession(Map<String, dynamic> session) async {
    final db = await database;
    return await db.insert('sessions', session);
  }

  Future<int> insertProgram(Map<String, dynamic> program) async {
    final db = await database;
    return await db.insert('programs', program);
  }

  Future<int> insertProgramExecution(Map<String, dynamic> execution) async {
    final db = await database;
    return await db.insert('program_executions', execution);
  }

  Future<List<Map<String, dynamic>>> getSessionData(int sessionId) async {
    print("Starting getSessionData for sessionId: $sessionId");
    try {
      final db = await database;
      final session =
          await db.query('sessions', where: 'id = ?', whereArgs: [sessionId]);
      print("Session query result: $session");

      if (session.isEmpty) {
        print("No session found for id: $sessionId");
        return [];
      }

      final programs = await db
          .query('programs', where: 'sessionId = ?', whereArgs: [sessionId]);
      print("Programs query result: $programs");

      final executions = await Future.wait(programs.map((program) async {
        return await db.query('program_executions',
            where: 'programId = ?', whereArgs: [program['id']]);
      }));
      print("Executions query result: $executions");

      final result = [
        {
          'session': session.first,
          'programs': programs.asMap().map((index, program) => MapEntry(index, {
                ...program,
                'executions': executions[index],
              })),
        }
      ];
      print("Final result: $result");
      return result;
    } catch (e) {
      print("Error in getSessionData: $e");
      print("Error stack trace: ${StackTrace.current}");
      rethrow;
    }
  }

  Future<void> deleteSession(int sessionId) async {
    final db = await database;
    await db.transaction((txn) async {
      // Delete program executions
      await txn.delete('program_executions',
          where: 'programId IN (SELECT id FROM programs WHERE sessionId = ?)',
          whereArgs: [sessionId]);

      // Delete programs
      await txn
          .delete('programs', where: 'sessionId = ?', whereArgs: [sessionId]);

      // Delete session
      await txn.delete('sessions', where: 'id = ?', whereArgs: [sessionId]);
    });
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await database;
    return await db.query('sessions', orderBy: 'createdAt DESC');
  }

  Future<List<Map<String, dynamic>>> getSessionPrograms(int sessionId) async {
    final db = await database;
    return await db
        .query('programs', where: 'sessionId = ?', whereArgs: [sessionId]);
  }

  Future<List<Map<String, dynamic>>> getProgramExecutions(int programId) async {
    final db = await database;
    return await db.query('program_executions',
        where: 'programId = ?',
        whereArgs: [programId],
        orderBy: 'timestamp ASC');
  }
}
