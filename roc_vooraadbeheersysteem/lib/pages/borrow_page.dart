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
  }
}


    Future<void> borrowItem(String itemId, String studentId) async {
      final dbHelper = DatabaseHelper.instance;

      try {
        // Update the item's availability
        await dbHelper.insertOrUpdate(
          tableName: 'item',
          data: {'availablity': false}, // Mark as unavailable
          whereClause: 'id = ?',
          whereArgs: [itemId],
        );

        // Log borrowing or create order entry if required
        _showSnackBar(context, 'Item borrowed successfully!');
        itemIdController.clear();
        studentIdController.clear();
        itemDetailsNotifier.value = null;
      } catch (e) {
        _showSnackBar(context, 'Error borrowing item.');
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Borrow an Item',
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
                  _showSnackBar(context, 'Please enter an Item ID.');
                } else {
                  await fetchItemDetails(itemId);
                }
              },
              child: const Text('Find Item'),
            ),
            const SizedBox(height: 24.0),
            ValueListenableBuilder<Map<String, dynamic>?>(
              valueListenable: itemDetailsNotifier,
              builder: (context, itemDetails, child) {
                if (itemDetails == null) {
                  return const Text(
                    'No item details available. Please search for an item.',
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
                      'Availability: ${isAvailable ? "Available" : "Not Available"}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Notes: ${itemDetails['notes']}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    if (isAvailable)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: studentIdController,
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
                                _showSnackBar(context, 'Please enter a Student ID.');
                              } else {
                                borrowItem(itemIdController.text.trim(), studentId);
                              }
                            },
                            child: const Text('Borrow Item'),
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
