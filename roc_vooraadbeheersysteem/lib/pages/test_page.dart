// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class TestPage extends BasePage {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Test Page'),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: const Text('This is some random text on the Test Page'),
    );
  }
}
