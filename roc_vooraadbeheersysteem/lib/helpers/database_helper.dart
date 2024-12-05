import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:roc_vooraadbeheersysteem/models/item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await initDatabase();
  //   return _database!;
  // }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'inventory.db');
    print("Database path: $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
  )
''');
    await db.execute('''
CREATE TABLE categorie (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT
  )
''');
    await db.execute('''
CREATE TABLE item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  statusID INT,
  categorieID INT,
  name TEXT,
  availablity BOOL,
  notes TEXT,
  image TEXT,
  FOREIGN KEY (statusID) REFERENCES status (id),
  FOREIGN KEY (categorieID) REFERENCES categorie (id)
  )
''');

    await db.execute('''
  CREATE TABLE orderItem (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    statusID INT,
    itemGroupID INT,
    FOREIGN KEY (statusID) REFERENCES status (id),
    FOREIGN KEY (itemGroupID) REFERENCES itemGroup (id)
  )
''');
    await db.execute('''
  CREATE TABLE userType (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT
  )
''');
    await db.execute('''
  CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userTypeID INT,
    name TEXT,
    studentID TEXT,
    cardID TEXT,
    class TEXT,
    cohort TEXT,
    FOREIGN KEY (userTypeID) REFERENCES userType (id)
  )
''');
    await db.execute('''
  CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userID INT,
    date TEXT,
    FOREIGN KEY (userID) REFERENCES user (id)
  )
''');
  }

  Future<List<Map<String, dynamic>>?> getData({
    required String tableName,
    required String whereClause,
    // required List<dynamic> whereArgs,
    List<String>? columns,
  }) async {
    print("vind" + tableName + "whereclause" + whereClause);
    final db = await database;
    print(db.query);
    // Execute the query with dynamic parameters
    final result = await db.query(tableName + " WHERE " + whereClause + ";");
    print(result);
    if (result.isEmpty) {
      return null;
    }

    return result;
  }
Future<List<Map<String, dynamic>>> getAllItems() async {
  final db = await database;
  final result = await db.query('item');
  return result; // Return the full list of results
}

Future<List<Map<String, dynamic>>> getAllCategories() async {
  final db = await database;
  final result = await db.query('categorie');
  return result; // Return the full list of results
}

  // A method that retrieves all the notes from the Notes table.
  // Future<List<Item>> getAll() async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
  //   final result = await db.query(tableNotes, orderBy: '$colId ASC');

  //   // Convert the List<Map<String, dynamic> into a List<Note>.
  //   return result.map((json) => Item.fromJson(json)).toList();
  // }
}
