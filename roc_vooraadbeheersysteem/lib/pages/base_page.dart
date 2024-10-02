// lib/pages/base_page.dart
import 'package:flutter/material.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Base Page'),
    );
  }

  Widget buildBody(BuildContext context);
}
