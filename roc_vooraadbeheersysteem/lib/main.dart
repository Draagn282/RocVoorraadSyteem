import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '/providers/database_provider.dart';
import '/helpers/database_helper.dart' as helpers;
import 'package:provider/provider.dart';
import 'package:roc_vooraadbeheersysteem/pages/home_page.dart';
import 'package:roc_vooraadbeheersysteem/pages/test_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROC Voorraadbeheer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
