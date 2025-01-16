// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class BorrowPage extends BasePage {
  const BorrowPage({super.key});

  @override
  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      'Borrow Page',
      style: TextStyle(color: Color(0xff3f2e56)),
    ));
  }

  @override
  Widget buildBody(BuildContext context) {
    final TextEditingController studentIdController = TextEditingController();
    final TextEditingController itemIdController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: studentIdController,
            decoration: const InputDecoration(
              labelText: 'Student ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: itemIdController,
            decoration: const InputDecoration(
              labelText: 'Item ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle the button press
              final studentId = studentIdController.text;
              final itemId = itemIdController.text;
              // Add your logic to handle the borrow action here
            },
            child: const Text('Borrow Item'),
          ),
        ],
      ),
    );
  }
}
