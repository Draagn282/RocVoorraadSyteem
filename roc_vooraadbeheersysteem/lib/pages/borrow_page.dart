import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class BorrowPage extends BasePage {
  const BorrowPage({super.key});

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        'Borrow Item',
        style: TextStyle(color: Color(0xff3f2e56)),
      ),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Color(0xff3f2e56)),
      elevation: 1,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final TextEditingController itemIdController = TextEditingController();
    final TextEditingController studentIdController = TextEditingController();
    final FocusNode studentIdFocusNode = FocusNode(); // Create a FocusNode

    ValueNotifier<Map<String, dynamic>?> itemDetailsNotifier = ValueNotifier(null);

    Future<void> fetchItemDetails(String itemId) async {
      final dbHelper = DatabaseHelper.instance;
      final results = await dbHelper.getData(
        tableName: 'item',
        whereClause: 'id = ?',
        whereArgs: [itemId],
      );

      if (results == null || results.isEmpty) {
        itemDetailsNotifier.value = null;
        _showSnackBar(context, 'Item not found.');
      } else {
        itemDetailsNotifier.value = results.first;
        // Automatically focus on the Student ID field
        studentIdFocusNode.requestFocus();
      }
    }

    Future<void> borrowItem(String itemId, String studentId) async {
      final dbHelper = DatabaseHelper.instance;

      try {
        await dbHelper.insertOrUpdate(
          tableName: 'item',
          data: {'availablity': false},
          whereClause: 'id = ?',
          whereArgs: [itemId],
        );

        _showSnackBar(context, 'Item succesvol uitgeleend!');
        itemIdController.clear();
        studentIdController.clear();
        itemDetailsNotifier.value = null;
      } catch (e) {
        _showSnackBar(context, 'Error item zoeken.');
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Zoek een Item',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff3f2e56),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: itemIdController,
              decoration: const InputDecoration(
                labelText: 'Item ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final itemId = itemIdController.text.trim();
                if (itemId.isEmpty) {
                  _showSnackBar(context, 'Vul een Item ID in.');
                } else {
                  await fetchItemDetails(itemId);
                }
              },
              child: const Text('Vind Item'),
            ),
            const SizedBox(height: 24.0),
            ValueListenableBuilder<Map<String, dynamic>?>(
              valueListenable: itemDetailsNotifier,
              builder: (context, itemDetails, child) {
                if (itemDetails == null) {
                  return const Text(
                    'Geen Item details beschickbaar. Vul een Item in.',
                    style: TextStyle(color: Colors.red),
                  );
                }

                final isAvailable = itemDetails['availablity'] == 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Name: ${itemDetails['name']}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Availability: ${isAvailable ? "Beschickbaar" : "Niet Beschickbaar"}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Notities: ${itemDetails['notes']}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    if (isAvailable)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: studentIdController,
                            focusNode: studentIdFocusNode, // Attach FocusNode
                            decoration: const InputDecoration(
                              labelText: 'Student ID',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              final studentId = studentIdController.text.trim();
                              if (studentId.isEmpty) {
                                _showSnackBar(context, 'vul een studenten ID in.');
                              } else {
                                borrowItem(itemIdController.text.trim(), studentId);
                              }
                            },
                            child: const Text('Leen Item'),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
