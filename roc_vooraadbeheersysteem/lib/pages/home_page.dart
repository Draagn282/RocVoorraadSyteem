// lib/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/widgets/custom_button.dart';

class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

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
      title: const Text('Home Page'),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to Home Page'),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Go to Test Page',
            routeName: '/test',
          ),
        ],
      ),
    );
  }
}
