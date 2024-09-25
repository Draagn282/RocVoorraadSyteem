import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '/providers/database_provider.dart';
import '/helpers/database_helper.dart' as helpers;
import 'package:provider/provider.dart';

void main() async {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final dbHelper = helpers.DatabaseHelper.instance;
  await dbHelper.initDatabase();
  runApp(
    MultiProvider(
        providers: [Provider<helpers.DatabaseHelper>.value(value: dbHelper)],
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}
