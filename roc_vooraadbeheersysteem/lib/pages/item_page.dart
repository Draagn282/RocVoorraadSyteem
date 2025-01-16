import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/models/item_model.dart';
import 'package:roc_vooraadbeheersysteem/widgets/floating_nav_bar.dart';
import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class ItemPage extends StatefulWidget {
  final int itemId;

  const ItemPage({super.key, required this.itemId});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Future<Item?> itemFuture;

  @override
  void initState() {
    super.initState();
    itemFuture =
        Item.getItem(widget.itemId); // This is where the item data is fetched.
  }

  Future<void> refreshItem() async {
    setState(() {
      itemFuture = Item.getItem(widget.itemId); // Refresh the item data.
    });
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final db = await DatabaseHelper.instance.database;
    return await db
        .query('categorie'); // Replace 'categorie' with your table name
  }

  Future<String> fetchCategory(int categoryId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'categorie', // Replace with your actual categories table name
      columns: ['name'], // Replace with the column that stores category names
      where: 'id = ?',
      whereArgs: [categoryId],
    );
    if (result.isNotEmpty) {
      return result.first['name'] as String;
    }
    return 'Unknown';
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      'Item Page',
      style: TextStyle(color: Color(0xff3f2e56)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder<Item?>(
        future: itemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Item not found'));
          }

          final item = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 800,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        //
                        Center(
                          child: item.image.isNotEmpty
                              ? Image.memory(
                                  item.image, // Use the Uint8List image directly
                                  height: 400,
                                  width: 600,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/fallback_image.png', // Fallback asset image
                                      height: 400,
                                      width: 600,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/fallback_image.png', // Fallback asset image
                                  height: 400,
                                  width: 600,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        //
                        //
                        const SizedBox(height: 16),
                        const Text(
                          'Item details',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Naam:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Opmerkingen:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.notes,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Beschikbaarheid:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.availablity
                                  ? 'Beschikbaar'
                                  : 'Niet beschikbaar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 8), // Consistente verticale ruimte
                        Row(
                          children: [
                            const Text(
                              'Categorie:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FutureBuilder<String>(
                                future: fetchCategory(item
                                    .categorieID), // Call the fetchCategory function
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Loading...',
                                      style: TextStyle(
                                          fontSize: 18), // Same styling
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                      'Error loading category',
                                      style: TextStyle(
                                          fontSize: 18), // Same styling
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text(
                                      'Unknown',
                                      style: TextStyle(
                                          fontSize: 18), // Same styling
                                    );
                                  }
                                  return Text(
                                    snapshot
                                        .data!, // Display the fetched category name
                                    style: const TextStyle(
                                        fontSize: 18), // Same styling
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final editedItem =
                                await _showEditDialog(context, item);
                            if (editedItem != null) {
                              await editedItem.save();
                              refreshItem();
                            }
                          },
                          child: const Text('Edit Item'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await item.delete();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete Item'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(
            top: 56.0), // Adjust the bottom padding to your needs
        child: FloatingNavBar(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<Item?> _showEditDialog(BuildContext context, Item item) async {
    final TextEditingController nameController =
        TextEditingController(text: item.name);
    final TextEditingController notesController =
        TextEditingController(text: item.notes);
    bool availability = item.availablity;
    int categoryId = item.categorieID;

    Widget buildRow(String title, Widget child, {bool isCompact = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 130, // Fixed width for consistent title alignment
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 15), // Spacing between title and content
            isCompact
                ? child // Compact layout
                : Expanded(child: child), // Expanded layout
          ],
        ),
      );
    }

    return await showDialog<Item>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildRow(
                      'Name:',
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    buildRow(
                      'Notes:',
                      TextField(
                        controller: notesController,
                        maxLines: 3, // Allow up to 3 lines
                        minLines: 1, // Minimum 1 line
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    buildRow(
                      'Beschikbaarheid:',
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButton<bool>(
                          value: availability,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              setState(() {
                                availability = newValue; // Update availability
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem<bool>(
                              value: true,
                              child: Text('Beschikbaar'),
                            ),
                            DropdownMenuItem<bool>(
                              value: false,
                              child: Text('Niet Beschikbaar'),
                            ),
                          ],
                          underline:
                              const SizedBox(), // Remove default underline
                          isDense: true, // Compact the dropdown
                        ),
                      ),
                      isCompact: true,
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('Error loading categories');
                        }

                        final categories = snapshot.data!;
                        return buildRow(
                          'Categorie:',
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: DropdownButton<int>(
                              value: categoryId,
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    categoryId = newValue; // Update category ID
                                  });
                                }
                              },
                              items: categories.map((category) {
                                return DropdownMenuItem<int>(
                                  value: category['id'] as int,
                                  child: Text(category['name'] as String),
                                );
                              }).toList(),
                              underline:
                                  const SizedBox(), // Remove default underline
                              isDense: true, // Compact the dropdown
                            ),
                          ),
                          isCompact: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final editedItem = Item(
                      id: item.id,
                      statusID: item.statusID,
                      categorieID: categoryId, // Updated category ID
                      name: nameController.text, // Updated name
                      availablity: availability, // Updated availability
                      notes: notesController.text, // Updated notes
                      image: item.image, // Keep the same image
                    );

                    Navigator.of(context).pop(editedItem);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
