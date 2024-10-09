// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class TablesPage extends BasePage {
  const TablesPage({Key? key}) : super(key: key);

  @override
  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      'Tables Page',
      style: TextStyle(color: const Color(0xff3f2e56)),
    ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: const Text('This is some random text on the Tables Page'),
    );
  }
}
