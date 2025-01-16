// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class TestPage extends BasePage {
  const TestPage({super.key});

  @override
  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      'Test Page',
      style: TextStyle(color: Color(0xff3f2e56)),
    ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text('This is some random text on the Test Page'),
    );
  }
}
