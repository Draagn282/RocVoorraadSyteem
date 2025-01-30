import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';
import 'package:roc_vooraadbeheersysteem/models/item_model.dart';

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
    ValueNotifier<List<Item>> itemsListNotifier = ValueNotifier([]);

    // Fetch all items for the dropdown
    Future<void> fetchAllItems() async {
      final dbHelper = DatabaseHelper.instance;
      final items = await dbHelper.getAllItems();
      itemsListNotifier.value = items.map((item) => Item.fromMap(item)).toList();
    }

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
        studentIdFocusNode.requestFocus();  // Automatically focus on the Student ID field
      }
    }

Future<void> borrowItem(String itemId, String studentId) async {
  final dbHelper = DatabaseHelper.instance;

  try {
    // Fetch the item first to ensure it exists
    final item = await Item.getItem(int.parse(itemId));

    if (item != null) {
      // Create a new Item instance with the updated availability and rented time
      final updatedItem = Item(
        id: item.id,
        statusID: item.statusID,
        categorieID: item.categorieID,
        name: item.name,
        availablity: false, // Set availability to false (item is now rented)
        rented: DateTime.now(), // Set rented to the current time
        notes: item.notes,
        image: item.image,
      );

      // Use the save method to update the item in the database
      await updatedItem.save();

      _showSnackBar(context, 'Item succesvol uitgeleend!');

      // Navigate to the '/tables' page after successful borrowing
      Navigator.pushReplacementNamed(context, '/tables');

      itemIdController.clear();
      studentIdController.clear();
      itemDetailsNotifier.value = null;
    } else {
      _showSnackBar(context, 'Item not found.');
    }
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
            // Dropdown for item selection
            ValueListenableBuilder<List<Item>>(
              valueListenable: itemsListNotifier,
              builder: (context, itemsList, child) {
                return DropdownButtonFormField<String>(
                  items: itemsList
                      .map((item) => DropdownMenuItem<String>(
                            value: item.id.toString(),
                            child: Text(item.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      fetchItemDetails(value);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Item',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            // OR text field for scanner input
            TextField(
              controller: itemIdController,
              decoration: const InputDecoration(
                labelText: 'Item ID (or scan)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  fetchItemDetails(value);
                }
              },
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
                    'Geen Item details beschikbaar. Vul een Item in.',
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
                      'Availability: ${isAvailable ? "Beschikbaar" : "Niet Beschikbaar"}',
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
                                _showSnackBar(context, 'Vul een studenten ID in.');
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
