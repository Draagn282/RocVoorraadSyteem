// lib/pages/base_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/widgets/floating_nav_bar.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          buildBody(context),
          const FloatingNavBar(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Base Page'),
    );
  }

  Widget buildBody(BuildContext context);
}
