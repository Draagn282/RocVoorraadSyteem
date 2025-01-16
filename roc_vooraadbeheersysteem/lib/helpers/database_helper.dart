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
    email TEXT,
    studentID TEXT,
    cardID TEXT,
    studentClass TEXT,
    cohort TEXT,
    notes TEXT,
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
  required List<dynamic> whereArgs, // Added required whereArgs
  List<String>? columns,
}) async {
  final db = await database;
  final result = await db.query(
    tableName,
    where: whereClause,
    whereArgs: whereArgs, // Use whereArgs for parameterized queries
    columns: columns,
  );

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

  Future<List<Map<String, dynamic>>> getAllStatuses() async {
    final db = await database;
    final result = await db.query('status');
    return result; // Return the full list of results
  }

  Future<int> createItem(Item item) async {
    final db = await database;

    // Use the toMap function of the Item class
    return await db.insert(
      'item',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

Future<List<Map<String, dynamic>>> getAllStudents() async {
  final db = await database;
  final result = await db.query('user');
  return result; // Return the full list of results
}

Future<void> insertOrUpdate({
  required String tableName,
  required Map<String, dynamic> data,
  required String whereClause,
  required List<dynamic> whereArgs,
}) async {
  final db = await database;

  // Check if the record exists
  final existingRecords = await db.query(
    tableName,
    where: whereClause,
    whereArgs: whereArgs,
  );

  if (existingRecords.isNotEmpty) {
    // Update the existing record
    await db.update(
      tableName,
      data,
      where: whereClause,
      whereArgs: whereArgs,
    );
  } else {
    // Insert as a new record
    await db.insert(
      tableName,
      data,
    );
  }
}

Future<void> delete({
  required String tableName,
  required String whereClause,
  required List<dynamic> whereArgs,
}) async {
  final db = await database;

  try {
    await db.delete(
      tableName,
      where: whereClause,
      whereArgs: whereArgs,
    );
    log('Deleted record from $tableName where $whereClause with args $whereArgs');
  } catch (e) {
    log('Error deleting record from $tableName', error: e);
    rethrow; // Optionally rethrow the error if needed
  }
}




}
