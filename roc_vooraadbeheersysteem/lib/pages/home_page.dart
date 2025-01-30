// lib/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/widgets/custom_button.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      'Home Page',
      style: TextStyle(color: Color(0xff3f2e56)),
    ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text('Home Pagina wordt aan gewerkt'),
    );
  }
}
