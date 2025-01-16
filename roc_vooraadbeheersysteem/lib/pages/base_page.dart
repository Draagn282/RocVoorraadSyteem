import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/widgets/floating_nav_bar.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: buildBody(context),
          ),
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
