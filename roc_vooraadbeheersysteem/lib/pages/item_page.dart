import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/models/item_model.dart';
import 'package:roc_vooraadbeheersysteem/widgets/floating_nav_bar.dart';
import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class ItemPage extends StatefulWidget {
  final int itemId;

  const ItemPage({Key? key, required this.itemId}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Future<Item?> itemFuture;

  @override
  void initState() {
    super.initState();

    itemFuture = Item.getItem(widget.itemId);
  }

  Future<void> refreshItem() async {
    setState(() {
      itemFuture = Item.getItem(widget.itemId);
    });
  }

  Future<Item?> fetchItemById(int id) async {
    final data = await DatabaseHelper.instance.getData(
      tableName: 'item',
      whereClause: 'id = ?',
      // whereArgs: [id],
    );

    if (data != null && data.isNotEmpty) {
      // Assuming you have an Item.fromMap constructor
      return Item.fromMap(data.first);
    }
    return null;
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      'Item Page',
      style: TextStyle(color: const Color(0xff3f2e56)),
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
            // return const Center(child: CircularProgressIndicator());
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
                    constraints: BoxConstraints(
                      maxWidth: 800,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        // Center(
                        //   child: Image.network(
                        //     'https://fakeimg.pl/600x400/', // Large placeholder image
                        //     height: 400, // Adjust height as needed
                        //     width: 600, // Adjust width as needed
                        //     fit: BoxFit.cover,
                        //     loadingBuilder: (context, child, loadingProgress) {
                        //       if (loadingProgress == null) return child;
                        //       return Center(
                        //         child: CircularProgressIndicator(
                        //           value: loadingProgress.expectedTotalBytes !=
                        //                   null
                        //               ? loadingProgress.cumulativeBytesLoaded /
                        //                   loadingProgress.expectedTotalBytes!
                        //               : null,
                        //         ),
                        //       );
                        //     },
                        //     errorBuilder: (context, error, stackTrace) {
                        //       return Image.asset(
                        //         'assets/images/fallback_image.png', // Replace with your local asset
                        //         height: 400,
                        //         width: 600,
                        //         fit: BoxFit.cover,
                        //       );
                        //     },
                        //   ),
                        // ),

                        ///
                        const SizedBox(height: 16),
                        const Text(
                          'Item Details',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Name:',
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
                              'Notes:',
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
                              'Available:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.availablity ? 'Yes' : 'No',
                              style: const TextStyle(fontSize: 18),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            top: 56.0), // Adjust the bottom padding to your needs
        child: const FloatingNavBar(),
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

    return await showDialog<Item>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              SwitchListTile(
                title: const Text('Available'),
                value: availability,
                onChanged: (bool value) {
                  availability = value;
                },
              ),
            ],
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
                  categorieID: item.categorieID,
                  name: nameController.text,
                  availablity: availability,
                  notes: notesController.text,
                  image: item.image,
                );
                Navigator.of(context).pop(editedItem);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
