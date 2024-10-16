// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class StudentPage extends BasePage {
  const StudentPage({Key? key}) : super(key: key);

  @override
  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      'Student Page',
      style: TextStyle(color: const Color(0xff3f2e56)),
    ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding to the entire page
      child: ListView(
        children: []
      )
    );
  }
}
