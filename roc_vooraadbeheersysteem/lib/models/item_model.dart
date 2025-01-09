import 'dart:typed_data';
import 'dart:developer';

import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class Item {
  final int? id;
  final int statusID; // Foreign key to the status table
  final int categorieID; // Foreign key to the categorie table
  final String name;
  final bool availablity; // Boolean indicating availability
  final String notes; // Additional notes about the item
  final Uint8List image; // Binary data for the item's image

  Item({
    this.id, //nullable
    required this.statusID,
    required this.categorieID,
    required this.name,
    required this.availablity,
    required this.notes,
    required this.image,
  });

  // Named constructor to create an Item from a Map
  factory Item.fromMap(Map<String, dynamic> map) {
    final image = map['image']; // Ensure this matches your DB schema
    return Item(
      id: map['id'] as int,
      statusID: map['statusID'] as int,
      categorieID: map['categorieID'] as int,
      name: map['name'] as String,
      availablity: map['availablity'] == 1,
      notes: map['notes'] as String,
      image:
          image is Uint8List ? image : Uint8List(0), // Default to empty if null
    );
  }

  // Method to convert an Item to a Map (for database insertions or updates)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statusID': statusID,
      'categorieID': categorieID,
      'name': name,
      'availablity': availablity ? 1 : 0, // Convert bool to int for storage
      'notes': notes,
      'image': image, // Store binary data in the database
    };
  }

  static Future<Item?> getItem(int id) async {
    try {
      log('Fetching item with id: $id');

      final data = await DatabaseHelper.instance.getData(
        tableName: 'item',
        whereClause: 'id = ' + id.toString(), // Use placeholder for safety
        // whereArgs: [id], // Bind the id parameter
      );

      if (data != null && data.isNotEmpty) {
        return Item.fromMap(data.first);
      }
    } catch (e) {
      log('Error fetching item with id: $id', error: e);
    }

    return null;
  }

  static Future<void> create(
    _nameController,
    _notesController,
    _imgController,
  ) async {
    final newItem = Item(
      name: _nameController.text, // Access `.text` from TextEditingController
      notes: _notesController.text,
      statusID: 1,
      categorieID: 1,
      availablity: true,
      image: Uint8List(0),
    );
    // Insert the item into the database
    final id = await DatabaseHelper.instance.createItem(newItem);
    log('Inserted item with id: $id');
  }

  Future<void> save() async {
    // Ensure this item has an id (required for updating)
    if (id == null) {
      log('Error: Cannot save an item without an ID.');
      return;
    }

    // Create the updated item instance
    final updatedItem = Item(
      id: id, // Ensure the ID is set for updating
      name: name, // Use the updated name
      notes: notes, // Use the updated notes
      statusID: statusID, // Use the updated status ID
      categorieID: categorieID, // Use the updated category ID
      availablity: availablity, // Use the updated availability
      image: image, // Keep the current image unless updated elsewhere
    );

    // Update the item in the database
    final rowsAffected = await DatabaseHelper.instance.createItem(updatedItem);

    log('Updated item with id: $id. Rows affected: $rowsAffected');
  }

  Future<void> delete() async {
    // Add delete logic here (e.g., delete the item from the database)
  }
}
